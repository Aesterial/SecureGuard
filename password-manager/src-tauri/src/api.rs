use reqwest::Client;
use serde::{Deserialize, Serialize};

const API_BASE: &str = "http://localhost:8080/api";

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct PasswordEntry {
    pub id: Option<String>,
    pub title: String,
    pub encrypted_password: String,
    pub salt: String,
    pub created_at: Option<String>,
}

#[derive(Serialize)]
struct RegisterReq {
    username: String,
    password_hash: String,
    seed_hash: String,
}

#[derive(Serialize)]
struct LoginReq {
    username: String,
    password_hash: String,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct AuthResponse {
    pub token: String,
    pub user_id: String,
}

#[derive(Serialize)]
struct AddPassReq {
    title: String,
    encrypted_password: String,
    salt: String,
}

#[derive(Deserialize)]
struct ApiErr {
    error: String,
}

pub struct ApiClient {
    client: Client,
    token: Option<String>,
}

impl ApiClient {
    pub fn new() -> Self {
        Self {
            client: Client::new(),
            token: None,
        }
    }

    pub fn set_token(&mut self, token: String) {
        self.token = Some(token);
    }

    pub fn clear_token(&mut self) {
        self.token = None;
    }

    pub async fn register(&self, user: &str, pw: &str, seed: &str) -> Result<String, String> {
        let body = RegisterReq {
            username: user.into(),
            password_hash: pw.into(),
            seed_hash: seed.into(),
        };

        let resp = self
            .client
            .post(format!("{}/register", API_BASE))
            .json(&body)
            .send()
            .await
            .map_err(|e| format!("Network: {}", e))?;

        if resp.status().is_success() {
            Ok("Registration successful".into())
        } else {
            let e: ApiErr = resp.json().await.unwrap_or(ApiErr {
                error: "Unknown error".into(),
            });
            Err(e.error)
        }
    }

    pub async fn login(&self, user: &str, pw: &str) -> Result<AuthResponse, String> {
        let body = LoginReq {
            username: user.into(),
            password_hash: pw.into(),
        };

        let resp = self
            .client
            .post(format!("{}/login", API_BASE))
            .json(&body)
            .send()
            .await
            .map_err(|e| format!("Network: {}", e))?;

        if resp.status().is_success() {
            resp.json()
                .await
                .map_err(|e| format!("Parse: {}", e))
        } else {
            let e: ApiErr = resp.json().await.unwrap_or(ApiErr {
                error: "Login failed".into(),
            });
            Err(e.error)
        }
    }

    pub async fn get_passwords(&self) -> Result<Vec<PasswordEntry>, String> {
        let token = self.token.as_ref().ok_or("Not authenticated")?;

        let resp = self
            .client
            .get(format!("{}/passwords", API_BASE))
            .header("Authorization", format!("Bearer {}", token))
            .send()
            .await
            .map_err(|e| format!("Network: {}", e))?;

        if resp.status().is_success() {
            resp.json()
                .await
                .map_err(|e| format!("Parse: {}", e))
        } else {
            Err("Failed to fetch passwords".into())
        }
    }

    pub async fn add_password(
        &self,
        title: &str,
        enc: &str,
        salt: &str,
    ) -> Result<PasswordEntry, String> {
        let token = self.token.as_ref().ok_or("Not authenticated")?;

        let body = AddPassReq {
            title: title.into(),
            encrypted_password: enc.into(),
            salt: salt.into(),
        };

        let resp = self
            .client
            .post(format!("{}/passwords", API_BASE))
            .header("Authorization", format!("Bearer {}", token))
            .json(&body)
            .send()
            .await
            .map_err(|e| format!("Network: {}", e))?;

        if resp.status().is_success() {
            resp.json()
                .await
                .map_err(|e| format!("Parse: {}", e))
        } else {
            Err("Failed to add password".into())
        }
    }

    pub async fn delete_password(&self, id: &str) -> Result<(), String> {
        let token = self.token.as_ref().ok_or("Not authenticated")?;

        let resp = self
            .client
            .delete(format!("{}/passwords/{}", API_BASE, id))
            .header("Authorization", format!("Bearer {}", token))
            .send()
            .await
            .map_err(|e| format!("Network: {}", e))?;

        if resp.status().is_success() {
            Ok(())
        } else {
            Err("Failed to delete".into())
        }
    }
}

