package models

import "time"

type Instrument struct {
	InstrumentID  string     `db:"instrument_id" json:"instrument_id"`
	Exchange      string     `db:"exchange" json:"exchange"`
	ExchangeToken string     `db:"exchange_token" json:"exchange_token"`
	Underlying    string     `db:"underlying" json:"underlying"`
	AssetType     string     `db:"asset_type" json:"asset_type"`
	ExpiryDate    *time.Time `db:"expiry_date" json:"expiry_date,omitempty"`
	Strike        *float64   `db:"strike" json:"strike,omitempty"`
	OptionType    *string    `db:"option_type" json:"option_type,omitempty"`
	LotSize       float64    `db:"lot_size" json:"lot_size"`
	TickSize      float64    `db:"tick_size" json:"tick_size"`
	IsActive      bool       `db:"is_active" json:"is_active"`
	UpdatedAt     time.Time  `db:"updated_at" json:"updated_at"`
}
