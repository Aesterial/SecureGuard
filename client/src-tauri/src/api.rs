use serde::{Deserialize, Serialize};
use std::env;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tonic::{Code, Request, Status};

pub mod xyz {
    pub mod secureguard {
        pub mod v1 {
            include!(concat!(
                env!("CARGO_MANIFEST_DIR"),
                "/../grpc/xyz/secureguard/v1/xyz.secureguard.v1.rs"
            ));

            pub mod users {
                pub mod v1 {
                    include!(concat!(
                        env!("CARGO_MANIFEST_DIR"),
                        "/../grpc/xyz/secureguard/v1/users/v1/xyz.secureguard.v1.users.v1.rs"
                    ));
                }
            }

            pub mod login {
                pub mod v1 {
                    include!(concat!(
                        env!("CARGO_MANIFEST_DIR"),
                        "/../grpc/xyz/secureguard/v1/login/v1/xyz.secureguard.v1.login.v1.rs"
                    ));
                }
            }

            pub mod passwords {
                pub mod v1 {
                    include!(concat!(
                        env!("CARGO_MANIFEST_DIR"),
                        "/../grpc/xyz/secureguard/v1/passwords/v1/xyz.secureguard.v1.passwords.v1.rs"
                    ));
                }
            }
        }
    }
}

const DEFAULT_BACKEND: &str = "http://127.0.0.1:8080";
const DEFAULT_ENCRYPTION_ALGORITHM: &str = "aes256gcm-argon2id";

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct PasswordEntry {
    pub id: String,
    pub title: String,
    pub encrypted_password: String,
    pub salt: String,
    pub encryption_algorithm: String,
    pub created_at: String,
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
struct PasswordPayload {
    #[serde(default)]
    id: String,
    #[serde(default)]
    title: String,
    #[serde(default)]
    encrypted_password: String,
    #[serde(default)]
    salt: String,
    #[serde(default)]
    encryption_algorithm: String,
    #[serde(default)]
    created_at: String,
}

pub struct ApiClient {
    backend: String,
    client_hash: String,
    session: Option<String>,
}

impl ApiClient {
    pub fn new() -> Self {
        let backend = env::var("SECUREGUARD_GRPC_ENDPOINT")
            .ok()
            .filter(|v| !v.trim().is_empty())
            .or_else(|| env::var("SECUREGUARD_BACKEND").ok())
            .unwrap_or_else(|| DEFAULT_BACKEND.to_string());

        let client_hash = format!(
            "tauri-{}-{}",
            std::process::id(),
            uuid::Uuid::new_v4().simple()
        );

        Self {
            backend,
            client_hash,
            session: None,
        }
    }

    pub fn is_authenticated(&self) -> bool {
        self.session.is_some()
    }

    pub fn clear_session(&mut self) {
        self.session = None;
    }

    async fn connect(&self) -> Result<Channel, String> {
        let endpoint = Endpoint::from_shared(self.backend.clone())
            .map_err(|e| format!("Backend endpoint: {}", e))?;
        endpoint
            .connect()
            .await
            .map_err(|e| format!("Backend connection: {}", e))
    }

    fn with_client_metadata<T>(&self, mut req: Request<T>) -> Result<Request<T>, String> {
        let client = MetadataValue::try_from(self.client_hash.as_str())
            .map_err(|e| format!("Client metadata: {}", e))?;
        req.metadata_mut().insert("client", client);
        Ok(req)
    }

    fn with_auth_metadata<T>(&self, mut req: Request<T>) -> Result<Request<T>, String> {
        req = self.with_client_metadata(req)?;
        let session = self.session.as_deref().ok_or("Не авторизован")?;
        let session_header = format!("SG-{}", session);
        let value = MetadataValue::try_from(session_header.as_str())
            .map_err(|e| format!("Session metadata: {}", e))?;
        req.metadata_mut().insert("session", value);
        Ok(req)
    }

    pub async fn register(
        &mut self,
        username: &str,
        password: &str,
        seed_phrase: &str,
    ) -> Result<(), String> {
        use xyz::secureguard::v1::login::v1::login_service_client::LoginServiceClient;
        use xyz::secureguard::v1::login::v1::RegisterRequest;

        let channel = self.connect().await?;
        let mut client = LoginServiceClient::new(channel);
        let request = RegisterRequest {
            username: username.to_string(),
            password: password.to_string(),
            phraze: seed_phrase.to_string(),
        };
        let req = self.with_client_metadata(Request::new(request))?;
        client.register(req).await.map_err(map_tonic_error)?;

        self.session = None;
        Ok(())
    }

    pub async fn authorize(&mut self, username: &str, password: &str) -> Result<(), String> {
        use xyz::secureguard::v1::login::v1::login_service_client::LoginServiceClient;
        use xyz::secureguard::v1::login::v1::AuthorizeRequest;

        let channel = self.connect().await?;
        let mut client = LoginServiceClient::new(channel);
        let request = AuthorizeRequest {
            username: username.to_string(),
            password: password.to_string(),
        };
        let req = self.with_client_metadata(Request::new(request))?;
        let response = client.authorize(req).await.map_err(map_tonic_error)?;
        let session = response.into_inner().session;
        if session.trim().is_empty() {
            return Err("Сервер не вернул сессию".into());
        }
        self.session = Some(session);
        Ok(())
    }

    pub async fn list_passwords(&self) -> Result<Vec<PasswordEntry>, String> {
        use xyz::secureguard::v1::passwords::v1::password_service_client::PasswordServiceClient;
        use xyz::secureguard::v1::RequestWithLimitAndOffset;

        let channel = self.connect().await?;
        let mut client = PasswordServiceClient::new(channel);
        const PAGE_SIZE: i32 = 200;
        let mut out = Vec::new();
        let mut offset = 0_i32;

        loop {
            let request = RequestWithLimitAndOffset {
                limit: PAGE_SIZE,
                offset,
            };
            let req = self.with_auth_metadata(Request::new(request))?;
            let response = client.list(req).await.map_err(map_tonic_error)?;
            let payload = response.into_inner();
            let batch_len = payload.list.len() as i32;

            for item in payload.list {
                let fallback_created_at = timestamp_to_string(item.created_at);
                let decoded = decode_payload(&item.pass, fallback_created_at);
                out.push(PasswordEntry {
                    id: decoded.id,
                    title: decoded.title,
                    encrypted_password: decoded.encrypted_password,
                    salt: decoded.salt,
                    encryption_algorithm: normalize_encryption(&decoded.encryption_algorithm),
                    created_at: decoded.created_at,
                });
            }

            if batch_len == 0 {
                break;
            }
            offset += batch_len;
            if payload.count > 0 && offset >= payload.count {
                break;
            }
            if batch_len < PAGE_SIZE {
                break;
            }
        }
        Ok(out)
    }

    pub async fn add_password(&self, entry: PasswordEntry) -> Result<PasswordEntry, String> {
        use xyz::secureguard::v1::passwords::v1::password_service_client::PasswordServiceClient;
        use xyz::secureguard::v1::passwords::v1::CreateRequest;

        let channel = self.connect().await?;
        let mut client = PasswordServiceClient::new(channel);

        let payload = PasswordPayload {
            id: String::new(),
            title: entry.title.clone(),
            encrypted_password: entry.encrypted_password.clone(),
            salt: entry.salt.clone(),
            encryption_algorithm: normalize_encryption(&entry.encryption_algorithm),
            created_at: entry.created_at.clone(),
        };
        let packed = serde_json::to_string(&payload).map_err(|e| format!("Payload: {}", e))?;

        let request = CreateRequest {
            service_url: entry.title.clone(),
            login: entry.salt.clone(),
            pass: packed,
            salt: entry.salt.clone(),
        };
        let req = self.with_auth_metadata(Request::new(request))?;
        let response = client.create(req).await.map_err(map_tonic_error)?;
        let info = response
            .into_inner()
            .info
            .ok_or("Сервер не вернул данные записи")?;

        let fallback_created_at = timestamp_to_string(info.created_at);
        let decoded = decode_payload(&info.pass, fallback_created_at);

        Ok(PasswordEntry {
            id: decoded.id,
            title: decoded.title,
            encrypted_password: decoded.encrypted_password,
            salt: decoded.salt,
            encryption_algorithm: normalize_encryption(&decoded.encryption_algorithm),
            created_at: decoded.created_at,
        })
    }

    pub async fn delete_password(&self, id: &str) -> Result<(), String> {
        use xyz::secureguard::v1::passwords::v1::password_service_client::PasswordServiceClient;
        use xyz::secureguard::v1::RequestWithId;

        let channel = self.connect().await?;
        let mut client = PasswordServiceClient::new(channel);
        let request = RequestWithId { id: id.to_string() };
        let req = self.with_auth_metadata(Request::new(request))?;
        client.delete(req).await.map_err(map_tonic_error)?;
        Ok(())
    }
}

fn normalize_encryption(value: &str) -> String {
    let normalized = value.trim().to_lowercase();
    if normalized.is_empty() {
        return DEFAULT_ENCRYPTION_ALGORITHM.to_string();
    }
    normalized
}

fn decode_payload(raw: &str, fallback_created_at: String) -> PasswordPayload {
    if let Ok(mut payload) = serde_json::from_str::<PasswordPayload>(raw) {
        if payload.created_at.trim().is_empty() {
            payload.created_at = fallback_created_at;
        }
        if payload.encryption_algorithm.trim().is_empty() {
            payload.encryption_algorithm = DEFAULT_ENCRYPTION_ALGORITHM.to_string();
        }
        return payload;
    }

    PasswordPayload {
        id: String::new(),
        title: String::new(),
        encrypted_password: raw.to_string(),
        salt: String::new(),
        encryption_algorithm: DEFAULT_ENCRYPTION_ALGORITHM.to_string(),
        created_at: fallback_created_at,
    }
}

fn timestamp_to_string(value: Option<prost_types::Timestamp>) -> String {
    if let Some(ts) = value {
        let converted: Result<std::time::SystemTime, _> = ts.try_into();
        if let Ok(st) = converted {
            if let Ok(duration) = st.duration_since(std::time::UNIX_EPOCH) {
                return format!("{}", duration.as_secs());
            }
        }
    }
    String::new()
}

fn map_tonic_error(status: Status) -> String {
    if !status.message().trim().is_empty() {
        return status.message().to_string();
    }

    match status.code() {
        Code::Unauthenticated => "Не авторизован".to_string(),
        Code::NotFound => "Не найдено".to_string(),
        Code::AlreadyExists => "Уже существует".to_string(),
        Code::InvalidArgument => "Неверные данные".to_string(),
        Code::Unavailable => "Бэкенд недоступен".to_string(),
        _ => format!("gRPC ошибка: {}", status.code()),
    }
}
