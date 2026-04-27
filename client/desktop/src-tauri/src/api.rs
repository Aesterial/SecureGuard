use crate::crypto;
use base64::{engine::general_purpose::STANDARD as BASE64, Engine as _};
use reqwest::Url;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::env;
use tonic::metadata::MetadataValue;
use tonic::transport::{Channel, Endpoint};
use tonic::{Code, Request, Status};
use zeroize::{Zeroize, Zeroizing};

#[allow(
    dead_code,
    clippy::clone_on_copy,
    clippy::empty_docs,
    clippy::enum_variant_names
)]
pub mod xyz {
    pub mod secureguard {
        pub mod api {
            pub mod v1 {
                pub mod meta {
                    pub mod v1 {
                        include!(concat!(
                            env!("CARGO_MANIFEST_DIR"),
                            "/../grpc/xyz/secureguard/api/v1/meta/v1/xyz.secureguard.api.v1.meta.v1.rs"
                        ));
                    }
                }
            }
        }

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

            pub mod sessions {
                pub mod v1 {
                    include!(concat!(
                        env!("CARGO_MANIFEST_DIR"),
                        "/../grpc/xyz/secureguard/v1/sessions/v1/xyz.secureguard.v1.sessions.v1.rs"
                    ));
                }
            }
        }
    }
}

use self::xyz::secureguard::api::v1::meta::v1 as api_meta_contract_v1;
use self::xyz::secureguard::v1 as shared_contract_v1;
use self::xyz::secureguard::v1::login::v1 as login_contract_v1;
use self::xyz::secureguard::v1::passwords::v1 as passwords_contract_v1;
use self::xyz::secureguard::v1::sessions::v1 as sessions_contract_v1;
use self::xyz::secureguard::v1::stats::v1 as stats_contract_v1;
use self::xyz::secureguard::v1::users::v1 as users_contract_v1;

const DEFAULT_BACKEND: &str = "http://127.0.0.1:8080";
const DEFAULT_ENCRYPTION_ALGORITHM: &str = "aes256gcm-argon2id";
const CLIENT_API_VERSION: f32 = 1.0;
const PAGE_SIZE: i32 = 200;

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct PasswordEntry {
    pub id: String,
    pub title: String,
    pub encrypted_login: String,
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
    pub wrapped_master_key: String,
    pub wrapping_salt: String,
    pub vault_encryption_algorithm: String,
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
pub struct BackendEndpointResponse {
    pub endpoint: String,
    pub reauth_required: bool,
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct ServerMetadata {
    pub name: String,
    pub version: String,
    pub runtime_version: String,
    pub supported_api_versions: Vec<f32>,
    pub commit_hash: String,
    pub repository: String,
    pub build_time_unix: Option<i64>,
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct ServerProbeResponse {
    pub endpoint: String,
    pub healthy: bool,
    pub health_error: String,
    pub compatibility_checked: bool,
    pub compatible: bool,
    pub compatibility_error: String,
    pub reasons: Vec<String>,
    pub client_api_version: f32,
    pub info: Option<ServerMetadata>,
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct SessionSummary {
    pub id: String,
    pub is_current: bool,
    pub created_at_unix: i64,
    pub expires_at_unix: i64,
    pub last_seen_unix: Option<i64>,
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
struct PasswordPayload {
    #[serde(default)]
    id: String,
    #[serde(default)]
    title: String,
    #[serde(default)]
    encrypted_login: String,
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

#[derive(Deserialize, Default)]
struct UserKeyBundlePayload {
    #[serde(default)]
    wrapped_master_key: String,
    #[serde(default)]
    salt: String,
    #[serde(default)]
    wrapping_salt: String,
    #[serde(default)]
    encryption_method: String,
    #[serde(default)]
    encryption_algorithm: String,
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
            .unwrap_or_else(|| compiled_default_backend().to_string());
        let backend =
            validate_backend_endpoint(&backend).unwrap_or_else(|_| DEFAULT_BACKEND.to_string());

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

    pub fn backend(&self) -> &str {
        &self.backend
    }

    pub fn set_backend(&mut self, endpoint: &str) -> Result<bool, String> {
        let normalized = validate_backend_endpoint(endpoint)?;
        if self.backend == normalized {
            return Ok(false);
        }
        self.backend = normalized;
        Ok(true)
    }

    async fn connect(&self) -> Result<Channel, String> {
        let endpoint_url = validate_backend_endpoint(&self.backend)?;
        let endpoint = Endpoint::from_shared(endpoint_url.clone())
            .map_err(|e| format!("Backend endpoint: {}", e))?;
        if endpoint_url.starts_with("https://") {
            endpoint
                .tls_config(tonic::transport::ClientTlsConfig::new())
                .map_err(|e| format!("TLS config: {}", e))?
                .connect()
                .await
                .map_err(|e| format!("Backend connection: {}", e))
        } else {
            endpoint
                .connect()
                .await
                .map_err(|e| format!("Backend connection: {}", e))
        }
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
        use login_contract_v1::RegisterRequest;
        use shared_contract_v1::Kdf;

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
                wrapped_master_key: String::new(),
                wrapping_salt: String::new(),
                vault_encryption_algorithm: String::new(),
            },
            |info| {
                let preferences = info.preferences;
                let encryption_algorithm = preferences
                    .as_ref()
                    .map(|p| map_crypt(p.crypto))
                    .unwrap_or_default();
                let key_bundle = info
                    .phrase
                    .as_deref()
                    .and_then(|phrase| parse_user_key_bundle(phrase, &encryption_algorithm));
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
                    encryption_algorithm,
                    wrapped_master_key: key_bundle
                        .as_ref()
                        .map(|bundle| bundle.wrapped_master_key.clone())
                        .unwrap_or_default(),
                    wrapping_salt: key_bundle
                        .as_ref()
                        .map(|bundle| bundle.wrapping_salt.clone())
                        .unwrap_or_default(),
                    vault_encryption_algorithm: key_bundle
                        .as_ref()
                        .map(|bundle| bundle.encryption_algorithm.clone())
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
                let fallback_created_at = timestamp_to_string(item.created_at);
                let decoded = decode_password_entry(&item, fallback_created_at);
                out.push(PasswordEntry {
                    id: decoded.id,
                    title: decoded.title,
                    encrypted_login: decoded.encrypted_login,
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

        let meta = serde_json::json!({ "format": "self-contained-aesgcm-v1" }).to_string();

        let request = CreateRequest {
            service_url: entry.title.clone(),
            login: entry.encrypted_login.clone(),
            ciphertext: entry.encrypted_password.clone(),
            version: 1,
            nonce: "self-contained-aesgcm-v1".to_string(),
            aad: vec![1],
            metadata: meta,
        };
        let req = self.with_auth_metadata(Request::new(request))?;
        let response = client.create(req).await.map_err(map_tonic_error)?;
        let info = response
            .into_inner()
            .info
            .ok_or("Сервер не вернул данные записи")?;

        let fallback_created_at = timestamp_to_string(info.created_at);
        let decoded = decode_password_entry(&info, fallback_created_at);

        Ok(PasswordEntry {
            id: decoded.id,
            title: decoded.title,
            encrypted_login: decoded.encrypted_login,
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

    pub async fn list_sessions(&self) -> Result<Vec<SessionSummary>, String> {
        use sessions_contract_v1::sessions_service_client::SessionsServiceClient;
        use shared_contract_v1::RequestWithBooleanLimitOffset;

        let channel = self.connect().await?;
        let mut client = SessionsServiceClient::new(channel);
        let mut out = Vec::new();
        let mut offset = 0_i32;

        loop {
            let request = RequestWithBooleanLimitOffset {
                value: true,
                limit: PAGE_SIZE,
                offset,
            };
            let req = self.with_auth_metadata(Request::new(request))?;
            let response = match client.get_list(req).await {
                Ok(response) => response,
                Err(status) if status.code() == Code::NotFound => break,
                Err(status) => return Err(map_tonic_error(status)),
            };
            let payload = response.into_inner();
            let mut batch_len = 0_i32;

            for item in payload.list {
                if item.id.trim().is_empty() {
                    continue;
                }
                batch_len += 1;
                out.push(SessionSummary {
                    id: item.id,
                    is_current: item.hash == self.client_hash,
                    created_at_unix: timestamp_to_unix_seconds(item.created_at),
                    expires_at_unix: timestamp_to_unix_seconds(item.expires_at),
                    last_seen_unix: timestamp_to_unix_seconds_option(item.last_seen),
                });
            }

            if batch_len == 0 {
                break;
            }
            offset += batch_len;
            if batch_len < PAGE_SIZE {
                break;
            }
        }

        Ok(out)
    }

    pub async fn revoke_session(&self, id: &str) -> Result<(), String> {
        use sessions_contract_v1::sessions_service_client::SessionsServiceClient;
        use shared_contract_v1::RequestWithId;

        let channel = self.connect().await?;
        let mut client = SessionsServiceClient::new(channel);
        let request = RequestWithId { id: id.to_string() };
        let req = self.with_auth_metadata(Request::new(request))?;
        client.revoke(req).await.map_err(map_tonic_error)?;
        Ok(())
    }

    pub async fn probe_server(&self) -> ServerProbeResponse {
        use api_meta_contract_v1::meta_service_client::MetaServiceClient;

        let mut response = ServerProbeResponse {
            endpoint: self.backend.clone(),
            client_api_version: CLIENT_API_VERSION,
            ..ServerProbeResponse::default()
        };

        let channel = match self.connect().await {
            Ok(channel) => channel,
            Err(err) => {
                response.health_error = err;
                return response;
            }
        };

        let mut client = MetaServiceClient::new(channel);
        let info_request = match self.with_client_metadata(Request::new(())) {
            Ok(request) => request,
            Err(err) => {
                response.health_error = err;
                return response;
            }
        };

        let info_response = match client.server_information(info_request).await {
            Ok(result) => result.into_inner(),
            Err(err) => {
                response.health_error = map_tonic_error(err);
                return response;
            }
        };

        response.healthy = true;
        response.info = info_response.info.map(serialize_server_metadata);

        let compatibility_request = api_meta_contract_v1::CompatibilityRequest {
            client_api_version: CLIENT_API_VERSION,
            r#type: resolve_client_type() as i32,
        };
        let compatibility_request =
            match self.with_client_metadata(Request::new(compatibility_request)) {
                Ok(request) => request,
                Err(err) => {
                    response.compatibility_error = err;
                    return response;
                }
            };

        match client.client_compatibility(compatibility_request).await {
            Ok(result) => {
                let payload = result.into_inner();
                response.compatibility_checked = true;
                response.compatible = payload.value;
                response.reasons = payload.reasons;
            }
            Err(err) => {
                response.compatibility_error = map_tonic_error(err);
            }
        }

        response
    }
}

fn compiled_default_backend() -> &'static str {
    match option_env!("SECUREGUARD_DEFAULT_BACKEND") {
        Some(value) if !value.trim().is_empty() => value,
        _ => DEFAULT_BACKEND,
    }
}

fn validate_backend_endpoint(value: &str) -> Result<String, String> {
    let trimmed = value.trim();
    if trimmed.is_empty() {
        return Err("Invalid backend endpoint".into());
    }

    let mut url = Url::parse(trimmed).map_err(|_| "Invalid backend endpoint".to_string())?;
    if (url.scheme() != "https" && url.scheme() != "http")
        || url.host_str().is_none()
        || !url.username().is_empty()
        || url.password().is_some()
        || url.query().is_some()
        || url.fragment().is_some()
        || (!url.path().is_empty() && url.path() != "/")
    {
        return Err("Invalid backend endpoint".into());
    }

    url.set_path("/");
    url.set_query(None);
    url.set_fragment(None);
    Ok(url.to_string().trim_end_matches('/').to_string())
}

fn normalize_encryption(value: &str) -> String {
    let normalized = value.trim().to_lowercase();
    if normalized.is_empty() {
        return DEFAULT_ENCRYPTION_ALGORITHM.to_string();
    }
    normalized
}

fn parse_user_key_bundle(raw: &str, fallback_algorithm: &str) -> Option<crypto::MasterKeyEnvelope> {
    let bundle = serde_json::from_str::<UserKeyBundlePayload>(raw).ok()?;
    let wrapped_master_key = bundle.wrapped_master_key.trim().to_string();
    let wrapping_salt = if bundle.wrapping_salt.trim().is_empty() {
        bundle.salt.trim().to_string()
    } else {
        bundle.wrapping_salt.trim().to_string()
    };

    if wrapped_master_key.is_empty() || wrapping_salt.is_empty() {
        return None;
    }

    let raw_algorithm = if bundle.encryption_algorithm.trim().is_empty() {
        bundle.encryption_method
    } else {
        bundle.encryption_algorithm
    };
    let encryption_algorithm = if raw_algorithm.trim().is_empty() {
        normalize_encryption(fallback_algorithm)
    } else {
        normalize_encryption(&raw_algorithm)
    };

    Some(crypto::MasterKeyEnvelope {
        wrapped_master_key,
        wrapping_salt,
        encryption_algorithm,
    })
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
            time: timestamp_to_unix_seconds(point.time),
            value: point.value,
        })
        .collect()
}

fn serialize_server_metadata(info: api_meta_contract_v1::ServerInfo) -> ServerMetadata {
    ServerMetadata {
        name: info.name,
        version: info.version,
        runtime_version: info.runtime_version,
        supported_api_versions: info.supporing_ver,
        commit_hash: info.commit_hash,
        repository: info.reporitory,
        build_time_unix: timestamp_to_unix_seconds_option(info.build_time),
    }
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
        encrypted_login: String::new(),
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
        if !meta.encrypted_login.trim().is_empty() {
            payload.encrypted_login = meta.encrypted_login;
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

    if payload.encrypted_login.trim().is_empty() && looks_like_encrypted_field(&item.login) {
        payload.encrypted_login = item.login.clone();
    } else if payload.salt.trim().is_empty() {
        payload.salt = item.login.clone();
    }

    fill_payload_defaults(item, &mut payload, String::new());
    payload
}

fn looks_like_encrypted_field(value: &str) -> bool {
    let normalized = value.trim();
    if normalized.is_empty() || normalized.len() < 24 {
        return false;
    }

    BASE64
        .decode(normalized)
        .map(|decoded| decoded.len() >= 28)
        .unwrap_or(false)
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

fn timestamp_to_unix_seconds_option(value: Option<prost_types::Timestamp>) -> Option<i64> {
    value.map(|ts| ts.seconds)
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

fn resolve_client_type() -> api_meta_contract_v1::ClientType {
    #[cfg(target_os = "windows")]
    {
        return api_meta_contract_v1::ClientType::SecureguardWindows;
    }

    #[cfg(target_os = "macos")]
    {
        return api_meta_contract_v1::ClientType::SecureguardMac;
    }

    #[cfg(target_os = "android")]
    {
        return api_meta_contract_v1::ClientType::SecureguardAndroid;
    }

    #[cfg(target_os = "ios")]
    {
        return api_meta_contract_v1::ClientType::SecureguardIos;
    }

    #[allow(unreachable_code)]
    api_meta_contract_v1::ClientType::SecureguardUnspecified
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
