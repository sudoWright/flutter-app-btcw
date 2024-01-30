use super::api_service::ProtonAPIService;

pub static PROTON_WALLET_API_VERSION: &str = "v1";
    
pub static PROTON_AUTH_API_VERSION: &str = "v4";

pub trait RoutePath {
    fn get_wallet_path(&self) -> String;
    fn get_auth_path(&self) -> String;
}

impl RoutePath for ProtonAPIService {
    fn get_wallet_path(&self) -> String {
        format!("{}{}", "/wallet/", PROTON_WALLET_API_VERSION)
    }
    fn get_auth_path(&self) -> String {
        format!("{}{}", "/auth/", PROTON_AUTH_API_VERSION)
    }
}

// #[cfg(test)]
// mod test {
//     use crate::proton_api::{api_service::ProtonAPIService, network_routes::NetworkRoute};

//     #[tokio::test]
//     async fn test_ping_ok() {
//         let api_service = ProtonAPIService::default();
//         let result = api_service.ping().await;
//         assert!(result.is_ok());
//         assert_eq!(result.unwrap(), 200);
//     }
//     #[tokio::test]
//     async fn test_ping_object_ok() {
//         let api_service = ProtonAPIService::default();
//         let result = api_service.ping_object().await;
//         assert!(result.is_ok());
//         assert_eq!(result.unwrap().code, 1000);
//     }

//     #[tokio::test]
//     async fn test_get_network_ok() {
//         let mut api_service = ProtonAPIService::default();
//         api_service.login("feng100", "12345678").await.unwrap();

//         let result = api_service.get_network_type().await;
//         print!("{:?}", result);
//         assert!(result.is_ok());
//         let auth_response = result.unwrap();
//         assert_eq!(auth_response.Code, 1000);
//         assert_eq!(auth_response.Network, 1);
//     }

//     #[tokio::test]
//     #[should_panic] //session issue
//     async fn test_get_network_401() {
//         let api_service = ProtonAPIService::default();
//         api_service.get_network_type().await.unwrap();
//     }
// }
