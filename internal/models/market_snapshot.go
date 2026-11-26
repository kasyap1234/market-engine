package models

import (
	"time"
)

// Instrument represents a tradable contract or asset on an exchange.

// Candle1m represents a 1-minute OHLCV bar.

// MarketSnapshot captures high-frequency top-of-book and derivative state at a point in time.
type MarketSnapshot struct {
	ExchangeTS     time.Time `db:"exchange_ts" json:"exchange_ts"`
	ReceivedTS     time.Time `db:"received_ts" json:"received_ts"`
	InstrumentID   string    `db:"instrument_id" json:"instrument_id"`
	LTP            float64   `db:"ltp" json:"ltp"`
	MarkPrice      *float64  `db:"mark_price" json:"mark_price,omitempty"`
	FundingRate    *float64  `db:"funding_rate" json:"funding_rate,omitempty"`
	BestBid        *float64  `db:"best_bid" json:"best_bid,omitempty"`
	BestBidQty     *float64  `db:"best_bid_qty" json:"best_bid_qty,omitempty"`
	BestAsk        *float64  `db:"best_ask" json:"best_ask,omitempty"`
	BestAskQty     *float64  `db:"best_ask_qty" json:"best_ask_qty,omitempty"`
	DepthImbalance *float64  `db:"depth_imbalance" json:"depth_imbalance,omitempty"`
	OI             *float64  `db:"oi" json:"oi,omitempty"`
	MarketStatus   *string   `db:"market_status" json:"market_status,omitempty"`
}

// OptionChainSnapshot captures an option's price, liquidity, and Greeks at a point in time.
type OptionChainSnapshot struct {
	ExchangeTS    time.Time `db:"exchange_ts" json:"exchange_ts"`
	ReceivedTS    time.Time `db:"received_ts" json:"received_ts"`
	InstrumentID  string    `db:"instrument_id" json:"instrument_id"`
	UnderlyingLTP float64   `db:"underlying_ltp" json:"underlying_ltp"`
	LTP           *float64  `db:"ltp" json:"ltp,omitempty"`
	BestBid       *float64  `db:"best_bid" json:"best_bid,omitempty"`
	BestAsk       *float64  `db:"best_ask" json:"best_ask,omitempty"`
	IV            *float64  `db:"iv" json:"iv,omitempty"`
	Delta         *float64  `db:"delta" json:"delta,omitempty"`
	Gamma         *float64  `db:"gamma" json:"gamma,omitempty"`
	Theta         *float64  `db:"theta" json:"theta,omitempty"`
	Vega          *float64  `db:"vega" json:"vega,omitempty"`
	OI            *float64  `db:"oi" json:"oi,omitempty"`
	Volume        *float64  `db:"volume" json:"volume,omitempty"`
}

// CollectorHealthLog tracks WebSocket/API disconnections and backfill status.
type CollectorHealthLog struct {
	ID             int64      `db:"id" json:"id"`
	Exchange       string     `db:"exchange" json:"exchange"`
	StreamName     string     `db:"stream_name" json:"stream_name"`
	DisconnectedAt time.Time  `db:"disconnected_at" json:"disconnected_at"`
	ReconnectedAt  *time.Time `db:"reconnected_at" json:"reconnected_at,omitempty"`
	Backfilled     bool       `db:"backfilled" json:"backfilled"`
	Reason         *string    `db:"reason" json:"reason,omitempty"`
}
