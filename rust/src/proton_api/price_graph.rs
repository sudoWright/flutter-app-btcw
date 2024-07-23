pub use andromeda_api::price_graph::{DataPoint, PriceGraph, Timeframe};
pub use andromeda_api::settings::FiatCurrencySymbol as FiatCurrency;
pub use andromeda_common::BitcoinUnit;
use flutter_rust_bridge::frb;

#[frb(mirror(Timeframe))]
pub enum _Timeframe {
    OneDay,
    OneWeek,
    OneMonth,
    Unsupported,
}

#[frb(mirror(DataPoint))]
pub struct _DataPoint {
    pub ExchangeRate: u32,
    pub Cents: Option<u8>,
    pub Timestamp: u64,
}

#[frb(mirror(PriceGraph))]
pub struct _PriceGraph {
    pub FiatCurrencySymbol: Option<FiatCurrency>,
    pub BitcoinUnitSymbol: Option<BitcoinUnit>,
    pub FiatCurrency: Option<FiatCurrency>,
    pub BitcoinUnit: Option<BitcoinUnit>,
    pub GraphData: Vec<DataPoint>,
}
