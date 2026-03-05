use aes_gcm::{
    aead::{Aead, KeyInit},
    Aes256Gcm, Nonce,
};
use argon2::{self, Argon2};
use base64::{engine::general_purpose::STANDARD as BASE64, Engine as _};
use bcrypt::{hash, verify, DEFAULT_COST};
use rand::{rngs::OsRng, RngCore};
use sha2::{Digest, Sha256};
use zeroize::Zeroize;

pub const ENCRYPTION_ALGORITHM_AES_256_GCM_ARGON2ID: &str = "aes256gcm-argon2id";
pub const ENCRYPTION_ALGORITHM_AES_256_GCM_SHA256: &str = "aes256gcm-sha256";

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

pub fn encrypt_password(
    plaintext: &str,
    seed_phrase: &str,
    encryption_algorithm: &str,
) -> Result<(String, String), String> {
    let algorithm = resolve_encryption_algorithm(encryption_algorithm)
        .ok_or("Unsupported encryption algorithm".to_string())?;

    let mut salt = [0u8; 16];
    OsRng.fill_bytes(&mut salt);

    let mut key = derive_key_from_seed(seed_phrase, &salt, algorithm)?;
    let cipher = Aes256Gcm::new_from_slice(&key).map_err(|e| format!("Cipher init: {}", e))?;

    let mut nonce_bytes = [0u8; 12];
    OsRng.fill_bytes(&mut nonce_bytes);
    let nonce = Nonce::from_slice(&nonce_bytes);

    let ciphertext = cipher
        .encrypt(nonce, plaintext.as_bytes())
        .map_err(|e| format!("Encrypt: {}", e))?;

    key.zeroize();

    let mut combined = Vec::with_capacity(12 + ciphertext.len());
    combined.extend_from_slice(&nonce_bytes);
    combined.extend_from_slice(&ciphertext);

    Ok((BASE64.encode(&combined), BASE64.encode(salt)))
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
    let combined = BASE64
        .decode(encrypted_b64)
        .map_err(|e| format!("Data decode: {}", e))?;

    if combined.len() < 12 {
        return Err("Invalid encrypted data".into());
    }

    let (nonce_bytes, ciphertext) = combined.split_at(12);
    let nonce = Nonce::from_slice(nonce_bytes);

    let mut key = derive_key_from_seed(seed_phrase, &salt, algorithm)?;
    let cipher = Aes256Gcm::new_from_slice(&key).map_err(|e| format!("Cipher init: {}", e))?;

    let plaintext = cipher
        .decrypt(nonce, ciphertext)
        .map_err(|_| "Wrong seed phrase or corrupted data".to_string())?;

    key.zeroize();

    String::from_utf8(plaintext).map_err(|e| format!("UTF-8: {}", e))
}

pub fn hash_account_password(password: &str) -> Result<String, String> {
    hash(password, DEFAULT_COST).map_err(|e| format!("Bcrypt hash: {}", e))
}

pub fn verify_account_password(password: &str, password_hash: &str) -> Result<bool, String> {
    verify(password, password_hash).map_err(|e| format!("Bcrypt verify: {}", e))
}

pub fn hash_seed_phrase(seed_phrase: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(seed_phrase.as_bytes());
    hex::encode(hasher.finalize())
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
        argon2::Params::new(65536, 3, 4, Some(32))
            .map_err(|e| format!("Argon2 params: {}", e))?,
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
