pub use andromeda_api::settings::{
    FiatCurrencySymbol as FiatCurrency, UserReceiveNotificationEmailTypes,
    UserSettings as ApiWalletUserSettings,
};
pub use andromeda_common::BitcoinUnit;
use flutter_rust_bridge::frb;

#[frb(mirror(UserReceiveNotificationEmailTypes))]
pub enum _UserReceiveNotificationEmailTypes {
    NotificationToInviter = 1,
    EmailIntegration = 2,
    TransactionalBvE = 4,
    Unsupported = 99,
}

#[frb(mirror(FiatCurrency))]
pub enum _FiatCurrency {
    ALL,
    DZD,
    ARS,
    AMD,
    AUD,
    AZN,
    BHD,
    BDT,
    BYN,
    BMD,
    BOB,
    BAM,
    BRL,
    BGN,
    KHR,
    CAD,
    CLP,
    CNY,
    COP,
    CRC,
    HRK,
    CUP,
    CZK,
    DKK,
    DOP,
    EGP,
    EUR,
    GEL,
    GHS,
    GTQ,
    HNL,
    HKD,
    HUF,
    ISK,
    INR,
    IDR,
    IRR,
    IQD,
    ILS,
    JMD,
    JPY,
    JOD,
    KZT,
    KES,
    KWD,
    KGS,
    LBP,
    MKD,
    MYR,
    MUR,
    MXN,
    MDL,
    MNT,
    MAD,
    MMK,
    NAD,
    NPR,
    TWD,
    NZD,
    NIO,
    NGN,
    NOK,
    OMR,
    PKR,
    PAB,
    PEN,
    PHP,
    PLN,
    GBP,
    QAR,
    RON,
    RUB,
    SAR,
    RSD,
    SGD,
    ZAR,
    KRW,
    SSP,
    VES,
    LKR,
    SEK,
    CHF,
    THB,
    TTD,
    TND,
    TRY,
    UGX,
    UAH,
    AED,
    USD,
    UYU,
    UZS,
    VND,
}

#[frb(mirror(BitcoinUnit))]
pub enum _BitcoinUnit {
    /// 100,000,000 sats
    BTC,
    /// 100,000 sats
    MBTC,
    /// 1 sat
    SATS,
}

#[frb(mirror(ApiWalletUserSettings))]
#[allow(non_snake_case)]
pub struct _ApiWalletUserSettings {
    pub BitcoinUnit: BitcoinUnit,
    pub FiatCurrency: FiatCurrency,
    pub HideEmptyUsedAddresses: u8,
    pub TwoFactorAmountThreshold: Option<u64>,
    pub ReceiveInviterNotification: Option<u8>,
    pub ReceiveEmailIntegrationNotification: Option<u8>,
    pub WalletCreated: Option<u8>,
    pub AcceptTermsAndConditions: Option<u8>,
}
