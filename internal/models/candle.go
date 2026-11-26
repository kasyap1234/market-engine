package models

import "time"

type Candle1m struct {
	TS           time.Time `db:"ts" json:"ts"`
	ReceivedTS   time.Time `db:"received_ts" json:"received_ts"`
	InstrumentID string    `db:"instrument_id" json:"instrument_id"`
	Open         float64   `db:"open" json:"open"`
	High         float64   `db:"high" json:"high"`
	Low          float64   `db:"low" json:"low"`
	Close        float64   `db:"close" json:"close"`
	Volume       float64   `db:"volume" json:"volume"`
	OI           *float64  `db:"oi" json:"oi,omitempty"`
}
