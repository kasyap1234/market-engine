package models

type Instrument struct {
	InstrumentID  string `json:"instrument_id"`
	Exchange      string `json:"exchange"`
	ExchangeToken string
	Underlying    string
	AssetType     string  `json:"asset_type"`
	ExpiryDate    string  `json:"expiry_date"`
	StrikePrice   float64 `json:"strike_price"`
	OptionType    string  `json:"option_type"`
	LotSize       int     `json:"lot_size"`
	TickSize      float64 `json:"tick_size"`
	IsActive      bool    `json:"is_active"`
	UpdatedAt     string  `json:"updated_at"`
}
