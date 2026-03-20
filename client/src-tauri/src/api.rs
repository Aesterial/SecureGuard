use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::env;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tonic::{Code, Request, Status};
use zeroize::{Zeroize, Zeroizing};

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

            pub mod stats {
                pub mod v1 {
                    include!(concat!(
                        env!("CARGO_MANIFEST_DIR"),
                        "/../grpc/xyz/secureguard/v1/stats/v1/xyz.secureguard.v1.stats.v1.rs"
                    ));
                }
            }
        }
    }
}

use self::xyz::secureguard::v1 as shared_contract_v1;
use self::xyz::secureguard::v1::login::v1 as login_contract_v1;
use self::xyz::secureguard::v1::passwords::v1 as passwords_contract_v1;
use self::xyz::secureguard::v1::stats::v1 as stats_contract_v1;
use self::xyz::secureguard::v1::users::v1 as users_contract_v1;

#[cfg(debug_assertions)]
const DEFAULT_BACKEND: &str = "http://127.0.0.1:8080";
#[cfg(not(debug_assertions))]
const DEFAULT_BACKEND: &str = "";

const DEFAULT_ENCRYPTION_ALGORITHM: &str = "aes256gcm-argon2id";

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct PasswordEntry {
    pub id: String,
    pub title: String,
    pub encrypted_password: String,
    pub salt: String,
    pub wrapped_master_key: String,
    pub encryption_algorithm: String,
    pub created_at: String,
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct AuthProfile {
    pub id: String,
    pub username: String,
    pub staff: bool,
    pub has_preferences: bool,
    pub light_theme_enabled: bool,
    pub language: String,
    pub encryption_algorithm: String,
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct StatsTotal {
    pub users: i32,
    pub admins: i32,
    pub passwords: i32,
    pub active_sessions: i32,
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct StatsGraphPoint {
    pub time: i64,
    pub value: i32,
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct AdminStats {
    pub top_services: HashMap<String, i32>,
    pub activity_graph: Vec<StatsGraphPoint>,
    pub register_graph: Vec<StatsGraphPoint>,
    pub total: StatsTotal,
    pub crypt: HashMap<String, i32>,
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
    wrapped_master_key: String,
    #[serde(default)]
    encryption_algorithm: String,
    #[serde(default)]
    created_at: String,
}

pub struct ApiClient {
    backend: String,
    client_hash: String,
    session: Option<Zeroizing<String>>,
}

impl ApiClient {
    pub fn new() -> Self {
        let backend = env::var("SECUREGUARD_GRPC_ENDPOINT")
            .ok()
            .filter(|v| !v.trim().is_empty())
            .or_else(|| env::var("SECUREGUARD_BACKEND").ok())
            .filter(|v| !v.trim().is_empty())
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
        if let Some(mut s) = self.session.take() {
            s.zeroize();
        }
    }

    async fn connect(&self) -> Result<Channel, String> {
        let endpoint = Endpoint::from_shared(self.backend.clone())
            .map_err(|e| format!("Backend endpoint: {}", e))?;

        #[cfg(not(debug_assertions))]
        {
            if !self.backend.starts_with("https://") {
                return Err("Production requires TLS endpoint (https://)".into());
            }
            return endpoint
                .tls_config(tonic::transport::ClientTlsConfig::new())
                .map_err(|e| format!("TLS config: {}", e))?
                .connect()
                .await
                .map_err(|e| format!("Backend connection: {}", e));
        }

        #[cfg(debug_assertions)]
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
        let session = self.session.as_deref().ok_or("Not authenticated")?;
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
        wrapped_master_key: &str,
        wrapping_salt: &str,
    ) -> Result<(), String> {
        use login_contract_v1::login_service_client::LoginServiceClient;
        use shared_contract_v1::Kdf;
        use login_contract_v1::RegisterRequest;

        let channel = self.connect().await?;
        let mut client = LoginServiceClient::new(channel);
        let request = RegisterRequest {
            username: username.to_string(),
            password: password.to_string(),
            master_key: wrapped_master_key.to_string(),
            salt: wrapping_salt.to_string(),
            kdf_params: Some(Kdf {
                version: 19,
                memory: 65536,
                iterations: 3,
                parallelism: 4,
            }),
        };
        let req = self.with_client_metadata(Request::new(request))?;
        client.register(req).await.map_err(map_tonic_error)?;
        self.session = None;
        Ok(())
    }

    pub async fn authorize(
        &mut self,
        username: &str,
        password: &str,
    ) -> Result<AuthProfile, String> {
        use login_contract_v1::login_service_client::LoginServiceClient;
        use login_contract_v1::AuthorizeRequest;

        let channel = self.connect().await?;
        let mut client = LoginServiceClient::new(channel);
        let request = AuthorizeRequest {
            username: username.to_string(),
            password: password.to_string(),
            master_key: String::new(),
        };
        let req = self.with_client_metadata(Request::new(request))?;
        let response = client.authorize(req).await.map_err(map_tonic_error)?;
        let payload = response.into_inner();
        if payload.session.trim().is_empty() {
            return Err("Сервер не вернул сессию".into());
        }
        self.session = Some(Zeroizing::new(payload.session));
        Ok(payload.info.map_or_else(
            || AuthProfile {
                id: String::new(),
                username: username.to_string(),
                staff: false,
                has_preferences: false,
                light_theme_enabled: false,
                language: String::new(),
                encryption_algorithm: String::new(),
            },
            |info| {
                let preferences = info.preferences;
                AuthProfile {
                    id: info.id,
                    username: info.username,
                    staff: info.staff,
                    has_preferences: preferences.is_some(),
                    light_theme_enabled: preferences
                        .as_ref()
                        .map(|p| map_theme(p.theme))
                        .unwrap_or(false),
                    language: preferences
                        .as_ref()
                        .map(|p| map_language(p.lang))
                        .unwrap_or_default(),
                    encryption_algorithm: preferences
                        .as_ref()
                        .map(|p| map_crypt(p.crypto))
                        .unwrap_or_default(),
                }
            },
        ))
    }

    pub async fn logout(&self) -> Result<(), String> {
        use login_contract_v1::login_service_client::LoginServiceClient;

        if self.session.is_none() {
            return Ok(());
        }

        let channel = self.connect().await?;
        let mut client = LoginServiceClient::new(channel);
        let req = self.with_auth_metadata(Request::new(()))?;
        client.logout(req).await.map_err(map_tonic_error)?;
        Ok(())
    }

    pub async fn list_passwords(&self) -> Result<Vec<PasswordEntry>, String> {
        use passwords_contract_v1::password_service_client::PasswordServiceClient;
        use shared_contract_v1::RequestWithLimitAndOffset;

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
            let response = match client.list(req).await {
                Ok(response) => response,
                Err(status) if status.code() == Code::NotFound => break,
                Err(status) => return Err(map_tonic_error(status)),
            };
            let payload = response.into_inner();
            let batch_len = payload.list.len() as i32;

            for item in payload.list {
                let fallback_created_at = timestamp_to_string(item.created_at.clone());
                let decoded = decode_password_entry(&item, fallback_created_at);
                out.push(PasswordEntry {
                    id: decoded.id,
                    title: decoded.title,
                    encrypted_password: decoded.encrypted_password,
                    salt: decoded.salt,
                    wrapped_master_key: decoded.wrapped_master_key,
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

    pub async fn get_admin_stats(&self) -> Result<AdminStats, String> {
        use stats_contract_v1::stats_service_client::StatsServiceClient;

        let channel = self.connect().await?;
        let mut client = StatsServiceClient::new(channel);

        let today_req = self.with_auth_metadata(Request::new(()))?;
        let today = client.today(today_req).await.map_err(map_tonic_error)?;

        let total_req = self.with_auth_metadata(Request::new(()))?;
        let total = client.total(total_req).await.map_err(map_tonic_error)?;

        let stats = today.into_inner().stats;
        let total = total.into_inner();

        Ok(AdminStats {
            top_services: stats
                .as_ref()
                .map(|value| value.top_services.clone())
                .unwrap_or_default(),
            activity_graph: stats
                .as_ref()
                .map(|value| serialize_graph_points(&value.users_graph))
                .unwrap_or_default(),
            register_graph: stats
                .as_ref()
                .map(|value| serialize_graph_points(&value.register_graph))
                .unwrap_or_default(),
            total: StatsTotal {
                users: total.users,
                admins: total.admins,
                passwords: total.passwords,
                active_sessions: total.active_sessions,
            },
            crypt: stats
                .as_ref()
                .map(|value| value.crypt_uses.clone())
                .unwrap_or_default(),
        })
    }

    pub async fn add_password(&self, entry: PasswordEntry) -> Result<PasswordEntry, String> {
        use passwords_contract_v1::password_service_client::PasswordServiceClient;
        use passwords_contract_v1::CreateRequest;

        let channel = self.connect().await?;
        let mut client = PasswordServiceClient::new(channel);

        let meta = serde_json::json!({
            "id": entry.id,
            "title": entry.title,
            "salt": entry.salt,
            "wrapped_master_key": entry.wrapped_master_key,
            "encryption_algorithm": normalize_encryption(&entry.encryption_algorithm),
            "created_at": entry.created_at,
        })
        .to_string();

        let request = CreateRequest {
            service_url: entry.title.clone(),
            login: meta,
            ciphertext: entry.encrypted_password.clone(),
            version: 1,
            nonce: "inline-v1".to_string(),
            aad: vec![1],
            metadata: "{\"format\":\"inline-v1\"}".to_string(),
        };
        let req = self.with_auth_metadata(Request::new(request))?;
        let response = client.create(req).await.map_err(map_tonic_error)?;
        let info = response
            .into_inner()
            .info
            .ok_or("Сервер не вернул данные записи")?;

        let fallback_created_at = timestamp_to_string(info.created_at.clone());
        let decoded = decode_password_entry(&info, fallback_created_at);

        Ok(PasswordEntry {
            id: decoded.id,
            title: decoded.title,
            encrypted_password: decoded.encrypted_password,
            salt: decoded.salt,
            wrapped_master_key: decoded.wrapped_master_key,
            encryption_algorithm: normalize_encryption(&decoded.encryption_algorithm),
            created_at: decoded.created_at,
        })
    }

    pub async fn change_theme(&self, light_theme_enabled: bool) -> Result<(), String> {
        use users_contract_v1::user_service_client::UserServiceClient;
        use users_contract_v1::{ChangeThemeRequest, Theme};

        let channel = self.connect().await?;
        let mut client = UserServiceClient::new(channel);
        let request = ChangeThemeRequest {
            value: if light_theme_enabled {
                Theme::White as i32
            } else {
                Theme::Black as i32
            },
        };
        let req = self.with_auth_metadata(Request::new(request))?;
        client.change_theme(req).await.map_err(map_tonic_error)?;
        Ok(())
    }

    pub async fn change_language(&self, language: &str) -> Result<String, String> {
        use users_contract_v1::user_service_client::UserServiceClient;
        use users_contract_v1::{ChangeLanguageRequest, Language};

        let channel = self.connect().await?;
        let mut client = UserServiceClient::new(channel);
        let request = ChangeLanguageRequest {
            value: match normalize_language(language).as_str() {
                "en" => Language::En as i32,
                _ => Language::Ru as i32,
            },
        };
        let req = self.with_auth_metadata(Request::new(request))?;
        client.change_language(req).await.map_err(map_tonic_error)?;
        Ok(normalize_language(language))
    }

    pub async fn change_encryption(&self, value: &str) -> Result<String, String> {
        use users_contract_v1::user_service_client::UserServiceClient;
        use users_contract_v1::{ChangeCryptRequest, Crypt};

        let normalized = normalize_encryption(value);
        let channel = self.connect().await?;
        let mut client = UserServiceClient::new(channel);
        let request = ChangeCryptRequest {
            value: match normalized.as_str() {
                "aes256gcm-sha256" => Crypt::Sha256 as i32,
                _ => Crypt::Argon2id as i32,
            },
        };
        let req = self.with_auth_metadata(Request::new(request))?;
        client.change_crypt(req).await.map_err(map_tonic_error)?;
        Ok(normalized)
    }

    pub async fn delete_password(&self, id: &str) -> Result<(), String> {
        use passwords_contract_v1::password_service_client::PasswordServiceClient;
        use shared_contract_v1::RequestWithId;

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

fn normalize_language(value: &str) -> String {
    match value.trim().to_lowercase().as_str() {
        "en" => "en".to_string(),
        _ => "ru".to_string(),
    }
}

fn serialize_graph_points(points: &[stats_contract_v1::GraphPoint]) -> Vec<StatsGraphPoint> {
    points
        .iter()
        .map(|point| StatsGraphPoint {
            time: timestamp_to_unix_seconds(point.time.clone()),
            value: point.value,
        })
        .collect()
}

fn decode_password_entry(
    item: &passwords_contract_v1::Password,
    fallback_created_at: String,
) -> PasswordPayload {
    if let Ok(mut payload) = serde_json::from_str::<PasswordPayload>(&item.pass) {
        if !payload.encrypted_password.trim().is_empty()
            || !payload.salt.trim().is_empty()
            || !payload.wrapped_master_key.trim().is_empty()
        {
            fill_payload_defaults(item, &mut payload, fallback_created_at);
            return payload;
        }
    }

    let mut payload = PasswordPayload {
        id: String::new(),
        title: String::new(),
        encrypted_password: item.pass.clone(),
        salt: String::new(),
        wrapped_master_key: String::new(),
        encryption_algorithm: DEFAULT_ENCRYPTION_ALGORITHM.to_string(),
        created_at: fallback_created_at,
    };

    if let Ok(meta) = serde_json::from_str::<PasswordPayload>(&item.login) {
        if !meta.id.trim().is_empty() {
            payload.id = meta.id;
        }
        if !meta.title.trim().is_empty() {
            payload.title = meta.title;
        }
        if !meta.salt.trim().is_empty() {
            payload.salt = meta.salt;
        }
        if !meta.wrapped_master_key.trim().is_empty() {
            payload.wrapped_master_key = meta.wrapped_master_key;
        }
        if !meta.encryption_algorithm.trim().is_empty() {
            payload.encryption_algorithm = meta.encryption_algorithm;
        }
        if !meta.created_at.trim().is_empty() {
            payload.created_at = meta.created_at;
        }
    }

    if payload.salt.trim().is_empty() {
        payload.salt = item.login.clone();
    }

    fill_payload_defaults(item, &mut payload, String::new());
    payload
}

fn fill_payload_defaults(
    item: &passwords_contract_v1::Password,
    payload: &mut PasswordPayload,
    fallback_created_at: String,
) {
    if payload.id.trim().is_empty() {
        payload.id = build_fallback_entry_id(item);
    }

    if payload.title.trim().is_empty() {
        if let Some(service) = item.serv.as_ref() {
            if !service.name.trim().is_empty() {
                payload.title = service.name.clone();
            } else if !service.url.trim().is_empty() {
                payload.title = service.url.clone();
            }
        }
    }

    if payload.title.trim().is_empty() {
        payload.title = "Entry".to_string();
    }

    if payload.created_at.trim().is_empty() && !fallback_created_at.trim().is_empty() {
        payload.created_at = fallback_created_at;
    }

    if payload.encryption_algorithm.trim().is_empty() {
        payload.encryption_algorithm = DEFAULT_ENCRYPTION_ALGORITHM.to_string();
    }
}

fn build_fallback_entry_id(item: &passwords_contract_v1::Password) -> String {
    use sha2::{Digest, Sha256};

    let mut hasher = Sha256::new();

    if let Some(service) = item.serv.as_ref() {
        hasher.update(service.name.as_bytes());
        hasher.update(b"|");
        hasher.update(service.url.as_bytes());
        hasher.update(b"|");
    }

    hasher.update(item.login.as_bytes());
    hasher.update(b"|");
    hasher.update(item.pass.as_bytes());

    if let Some(ts) = item.created_at.as_ref() {
        hasher.update(ts.seconds.to_be_bytes());
        hasher.update(ts.nanos.to_be_bytes());
    }

    let digest = hasher.finalize();
    let mut bytes = [0u8; 16];
    bytes.copy_from_slice(&digest[..16]);
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    uuid::Uuid::from_bytes(bytes).to_string()
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

fn timestamp_to_unix_seconds(value: Option<prost_types::Timestamp>) -> i64 {
    value.map(|ts| ts.seconds).unwrap_or_default()
}

fn map_theme(value: i32) -> bool {
    use users_contract_v1::Theme;

    matches!(Theme::try_from(value).ok(), Some(Theme::White))
}

fn map_language(value: i32) -> String {
    use users_contract_v1::Language;

    match Language::try_from(value).ok() {
        Some(Language::En) => "en".to_string(),
        Some(Language::Ru) => "ru".to_string(),
        _ => String::new(),
    }
}

fn map_crypt(value: i32) -> String {
    use users_contract_v1::Crypt;

    match Crypt::try_from(value).ok() {
        Some(Crypt::Sha256) => "aes256gcm-sha256".to_string(),
        Some(Crypt::Argon2id) => "aes256gcm-argon2id".to_string(),
        _ => String::new(),
    }
}

fn map_tonic_error(status: Status) -> String {
    if status.code() == Code::Unauthenticated {
        return "Not authenticated".to_string();
    }

    if !status.message().trim().is_empty() {
        return status.message().to_string();
    }

    match status.code() {
        Code::PermissionDenied => "Access denied".to_string(),
        Code::Unauthenticated => "Не авторизован".to_string(),
        Code::NotFound => "Не найдено".to_string(),
        Code::AlreadyExists => "Уже существует".to_string(),
        Code::InvalidArgument => "Неверные данные".to_string(),
        Code::Unavailable => "Бэкенд недоступен".to_string(),
        _ => format!("gRPC ошибка: {}", status.code()),
    }
}
