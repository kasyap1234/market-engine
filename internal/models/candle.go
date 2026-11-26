package models

type Candle struct {
	Timestamp         string  `json:"timestamp"`
	ReceivedTimestamp string  `json:"received_timestamp"`
	InstrumentID      string  `json:"instrument_id"`
	Open              float64 `json:"open"`
	High              float64 `json:"high"`
	Low               float64 `json:"low"`
	Close             float64 `json:"close"`
	Volume            float64 `json:"volume"`
	OI                float64 `json:"oi"`
}
