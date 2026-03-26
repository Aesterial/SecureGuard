use aes_gcm::{
    aead::{Aead, KeyInit},
    Aes256Gcm, Nonce,
};
use argon2::{self, Argon2};
use base64::{engine::general_purpose::STANDARD as BASE64, Engine as _};
use rand::{rngs::OsRng, RngCore};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use zeroize::Zeroize;

pub const ENCRYPTION_ALGORITHM_AES_256_GCM_ARGON2ID: &str = "aes256gcm-argon2id";
pub const ENCRYPTION_ALGORITHM_AES_256_GCM_SHA256: &str = "aes256gcm-sha256";

#[derive(Clone, Debug, Default, Deserialize, Serialize)]
pub struct MasterKeyEnvelope {
    pub wrapped_master_key: String,
    pub wrapping_salt: String,
    pub encryption_algorithm: String,
}

pub fn default_encryption_algorithm() -> &'static str {
    ENCRYPTION_ALGORITHM_AES_256_GCM_ARGON2ID
}

pub fn resolve_encryption_algorithm(value: &str) -> Option<&'static str> {
    let normalized = value.trim().to_ascii_lowercase();
    match normalized.as_str() {
        "" | "default" | "argon2id" | "aes-256-gcm-argon2id" | "aes256gcm-argon2id" => {
            Some(ENCRYPTION_ALGORITHM_AES_256_GCM_ARGON2ID)
        }
        "sha256" | "aes-256-gcm-sha256" | "aes256gcm-sha256" => {
            Some(ENCRYPTION_ALGORITHM_AES_256_GCM_SHA256)
        }
        _ => None,
    }
}


pub fn decrypt_password(
    encrypted_b64: &str,
    salt_b64: &str,
    seed_phrase: &str,
    encryption_algorithm: &str,
) -> Result<String, String> {
    let algorithm = resolve_encryption_algorithm(encryption_algorithm)
        .ok_or("Unsupported encryption algorithm".to_string())?;

    let salt = BASE64
        .decode(salt_b64)
        .map_err(|e| format!("Salt decode: {}", e))?;
    let mut key = derive_key_from_seed(seed_phrase, &salt, algorithm)?;
    let plaintext = decrypt_bytes_with_key(encrypted_b64, &key)?;

    key.zeroize();

    decode_secret_utf8(plaintext)
}

pub fn generate_master_key() -> [u8; 32] {
    let mut key = [0u8; 32];
    OsRng.fill_bytes(&mut key);
    key
}

pub fn prepare_master_key_envelope(
    seed_phrase: &str,
    encryption_algorithm: &str,
) -> Result<MasterKeyEnvelope, String> {
    let mut master_key = generate_master_key();
    let envelope = wrap_master_key(&master_key, seed_phrase, encryption_algorithm)?;
    master_key.zeroize();
    Ok(envelope)
}

pub fn wrap_master_key(
    master_key: &[u8; 32],
    seed_phrase: &str,
    encryption_algorithm: &str,
) -> Result<MasterKeyEnvelope, String> {
    let algorithm = resolve_encryption_algorithm(encryption_algorithm)
        .ok_or("Unsupported encryption algorithm".to_string())?;

    let mut wrapping_salt = [0u8; 16];
    OsRng.fill_bytes(&mut wrapping_salt);

    let mut wrapping_key = derive_key_from_seed(seed_phrase, &wrapping_salt, algorithm)?;
    let wrapped_master_key = encrypt_bytes_with_key(master_key, &wrapping_key)?;
    wrapping_key.zeroize();

    Ok(MasterKeyEnvelope {
        wrapped_master_key,
        wrapping_salt: BASE64.encode(wrapping_salt),
        encryption_algorithm: algorithm.to_string(),
    })
}

pub fn unwrap_master_key(
    wrapped_master_key_b64: &str,
    wrapping_salt_b64: &str,
    seed_phrase: &str,
    encryption_algorithm: &str,
) -> Result<[u8; 32], String> {
    let algorithm = resolve_encryption_algorithm(encryption_algorithm)
        .ok_or("Unsupported encryption algorithm".to_string())?;
    let wrapping_salt = BASE64
        .decode(wrapping_salt_b64)
        .map_err(|e| format!("Salt decode: {}", e))?;

    let mut wrapping_key = derive_key_from_seed(seed_phrase, &wrapping_salt, algorithm)?;
    let mut master_key_bytes = decrypt_bytes_with_key(wrapped_master_key_b64, &wrapping_key)?;
    wrapping_key.zeroize();

    if master_key_bytes.len() != 32 {
        master_key_bytes.zeroize();
        return Err("Invalid master key".into());
    }

    let mut master_key = [0u8; 32];
    master_key.copy_from_slice(&master_key_bytes[..32]);
    master_key_bytes.zeroize();
    Ok(master_key)
}

pub fn encrypt_password_with_master_key(
    plaintext: &str,
    master_key: &[u8; 32],
) -> Result<String, String> {
    encrypt_bytes_with_key(plaintext.as_bytes(), master_key)
}

pub fn decrypt_password_with_master_key(
    encrypted_b64: &str,
    master_key: &[u8; 32],
) -> Result<String, String> {
    let plaintext = decrypt_bytes_with_key(encrypted_b64, master_key)?;
    decode_secret_utf8(plaintext)
}

fn derive_key_from_seed(
    seed_phrase: &str,
    salt: &[u8],
    encryption_algorithm: &str,
) -> Result<[u8; 32], String> {
    match encryption_algorithm {
        ENCRYPTION_ALGORITHM_AES_256_GCM_ARGON2ID => derive_key_argon2id(seed_phrase, salt),
        ENCRYPTION_ALGORITHM_AES_256_GCM_SHA256 => Ok(derive_key_sha256(seed_phrase, salt)),
        _ => Err("Unsupported encryption algorithm".into()),
    }
}

fn derive_key_argon2id(seed_phrase: &str, salt: &[u8]) -> Result<[u8; 32], String> {
    let mut key = [0u8; 32];
    let argon2 = Argon2::new(
        argon2::Algorithm::Argon2id,
        argon2::Version::V0x13,
        argon2::Params::new(65536, 3, 4, Some(32)).map_err(|e| format!("Argon2 params: {}", e))?,
    );

    argon2
        .hash_password_into(seed_phrase.as_bytes(), salt, &mut key)
        .map_err(|e| format!("Key derivation: {}", e))?;

    Ok(key)
}

fn derive_key_sha256(seed_phrase: &str, salt: &[u8]) -> [u8; 32] {
    let mut hasher = Sha256::new();
    hasher.update(seed_phrase.as_bytes());
    hasher.update(salt);
    let result = hasher.finalize();
    let mut key = [0u8; 32];
    key.copy_from_slice(&result[..32]);
    key
}

fn encrypt_bytes_with_key(plaintext: &[u8], key: &[u8]) -> Result<String, String> {
    let cipher = Aes256Gcm::new_from_slice(key).map_err(|e| format!("Cipher init: {}", e))?;

    let mut nonce_bytes = [0u8; 12];
    OsRng.fill_bytes(&mut nonce_bytes);
    let nonce = Nonce::from_slice(&nonce_bytes);

    let ciphertext = cipher
        .encrypt(nonce, plaintext)
        .map_err(|e| format!("Encrypt: {}", e))?;

    let mut combined = Vec::with_capacity(12 + ciphertext.len());
    combined.extend_from_slice(&nonce_bytes);
    combined.extend_from_slice(&ciphertext);

    Ok(BASE64.encode(combined))
}

fn decrypt_bytes_with_key(encrypted_b64: &str, key: &[u8]) -> Result<Vec<u8>, String> {
    let mut combined = BASE64
        .decode(encrypted_b64)
        .map_err(|e| format!("Data decode: {}", e))?;

    if combined.len() < 12 {
        combined.zeroize();
        return Err("Invalid encrypted data".into());
    }

    let cipher = Aes256Gcm::new_from_slice(key).map_err(|e| format!("Cipher init: {}", e))?;
    let nonce = Nonce::from_slice(&combined[..12]);
    let ciphertext = &combined[12..];
    let plaintext = cipher
        .decrypt(nonce, ciphertext)
        .map_err(|_| "Wrong seed phrase or corrupted data".to_string())?;
    combined.zeroize();
    Ok(plaintext)
}

fn decode_secret_utf8(bytes: Vec<u8>) -> Result<String, String> {
    match String::from_utf8(bytes) {
        Ok(value) => Ok(value),
        Err(err) => {
            let mut bytes = err.into_bytes();
            bytes.zeroize();
            Err("UTF-8: invalid secret payload".to_string())
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn wraps_and_unwraps_master_key_with_argon2id() {
        let seed_phrase = "alpha beta gamma delta";
        let master_key = generate_master_key();
        let envelope = wrap_master_key(
            &master_key,
            seed_phrase,
            ENCRYPTION_ALGORITHM_AES_256_GCM_ARGON2ID,
        )
        .expect("wrap master key");
        let unwrapped = unwrap_master_key(
            &envelope.wrapped_master_key,
            &envelope.wrapping_salt,
            seed_phrase,
            &envelope.encryption_algorithm,
        )
        .expect("unwrap master key");

        assert_eq!(master_key, unwrapped);
    }

    #[test]
    fn encrypts_and_decrypts_with_master_key() {
        let master_key = generate_master_key();
        let encrypted =
            encrypt_password_with_master_key("super-secret", &master_key).expect("encrypt");
        let decrypted = decrypt_password_with_master_key(&encrypted, &master_key).expect("decrypt");

        assert_eq!(decrypted, "super-secret");
    }
}
