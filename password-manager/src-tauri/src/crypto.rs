use aes_gcm::{
    aead::{Aead, KeyInit},
    Aes256Gcm, Nonce,
};
use argon2::{self, Argon2, PasswordHasher, password_hash::SaltString};
use base64::{engine::general_purpose::STANDARD as BASE64, Engine as _};
use rand::{rngs::OsRng, RngCore};
use sha2::{Digest, Sha256};
use zeroize::Zeroize;
pub fn derive_key_from_seed(seed_phrase: &str, salt: &[u8]) -> Result<[u8; 32], String> {
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
pub fn encrypt_password(plaintext: &str, seed_phrase: &str) -> Result<(String, String), String> {
    let mut salt = [0u8; 16];
    OsRng.fill_bytes(&mut salt);

    let mut key = derive_key_from_seed(seed_phrase, &salt)?;

    let cipher =
        Aes256Gcm::new_from_slice(&key).map_err(|e| format!("Cipher init: {}", e))?;

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

    Ok((BASE64.encode(&combined), BASE64.encode(&salt)))
}
pub fn decrypt_password(
    encrypted_b64: &str,
    salt_b64: &str,
    seed_phrase: &str,
) -> Result<String, String> {
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

    let mut key = derive_key_from_seed(seed_phrase, &salt)?;

    let cipher =
        Aes256Gcm::new_from_slice(&key).map_err(|e| format!("Cipher init: {}", e))?;

    let plaintext = cipher
        .decrypt(nonce, ciphertext)
        .map_err(|_| "Wrong seed phrase or corrupted data".to_string())?;

    key.zeroize();

    String::from_utf8(plaintext).map_err(|e| format!("UTF-8: {}", e))
}
pub fn hash_account_password(password: &str) -> Result<String, String> {
    let salt = SaltString::generate(&mut OsRng);
    let argon2 = Argon2::new(
        argon2::Algorithm::Argon2id,
        argon2::Version::V0x13,
        argon2::Params::new(65536, 3, 4, None).map_err(|e| format!("Params: {}", e))?,
    );
    let hash = argon2
        .hash_password(password.as_bytes(), &salt)
        .map_err(|e| format!("Hash: {}", e))?;
    Ok(hash.to_string())
}
pub fn hash_seed_phrase(seed_phrase: &str) -> String {
    let mut hasher = Sha256::new();
    hasher.update(seed_phrase.as_bytes());
    hex::encode(hasher.finalize())
}

