-- +goose Up
-- +goose StatementBegin
CREATE EXTENSION IF NOT EXISTS timescaledb;

CREATE TABLE instruments (
    instrument_id  TEXT             PRIMARY KEY,
    exchange       TEXT             NOT NULL,
    exchange_token TEXT             NOT NULL,
    underlying     TEXT             NOT NULL,
    asset_type     TEXT             NOT NULL,
    expiry_date    DATE,
    strike         DOUBLE PRECISION,
    option_type    TEXT,
    lot_size       DOUBLE PRECISION NOT NULL DEFAULT 1,
    tick_size      DOUBLE PRECISION NOT NULL DEFAULT 0.01,
    is_active      BOOLEAN          NOT NULL DEFAULT TRUE,
    updated_at     TIMESTAMPTZ      NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_instruments_lookup
    ON instruments (exchange, underlying, asset_type, is_active);

CREATE TABLE candles_1m (
    ts             TIMESTAMPTZ      NOT NULL,
    received_ts    TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
    instrument_id  TEXT             NOT NULL,
    open           DOUBLE PRECISION NOT NULL,
    high           DOUBLE PRECISION NOT NULL,
    low            DOUBLE PRECISION NOT NULL,
    close          DOUBLE PRECISION NOT NULL,
    volume         DOUBLE PRECISION NOT NULL,
    oi             DOUBLE PRECISION,
    PRIMARY KEY (instrument_id, ts)
);

SELECT create_hypertable('candles_1m', by_range('ts', INTERVAL '7 days'));
ALTER TABLE candles_1m SET (
    timescaledb.enable_columnstore,
    timescaledb.segmentby = 'instrument_id',
    timescaledb.orderby   = 'ts DESC'
);
CALL add_columnstore_policy('candles_1m', after => INTERVAL '7 days');

CREATE TABLE market_snapshots (
    exchange_ts     TIMESTAMPTZ      NOT NULL,
    received_ts     TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
    instrument_id   TEXT             NOT NULL,
    ltp             DOUBLE PRECISION NOT NULL,
    mark_price      DOUBLE PRECISION,
    funding_rate    DOUBLE PRECISION,
    best_bid        DOUBLE PRECISION,
    best_bid_qty    DOUBLE PRECISION,
    best_ask        DOUBLE PRECISION,
    best_ask_qty    DOUBLE PRECISION,
    depth_imbalance DOUBLE PRECISION,
    oi              DOUBLE PRECISION,
    market_status   TEXT,
    PRIMARY KEY (instrument_id, exchange_ts)
);

SELECT create_hypertable('market_snapshots', by_range('exchange_ts', INTERVAL '7 days'));
ALTER TABLE market_snapshots SET (
    timescaledb.enable_columnstore,
    timescaledb.segmentby = 'instrument_id',
    timescaledb.orderby   = 'exchange_ts DESC'
);
CALL add_columnstore_policy('market_snapshots', after => INTERVAL '7 days');

CREATE TABLE option_chain_snapshots (
    exchange_ts    TIMESTAMPTZ      NOT NULL,
    received_ts    TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
    instrument_id  TEXT             NOT NULL,
    underlying_ltp DOUBLE PRECISION NOT NULL,
    ltp            DOUBLE PRECISION,
    best_bid       DOUBLE PRECISION,
    best_ask       DOUBLE PRECISION,
    iv             DOUBLE PRECISION,
    delta          DOUBLE PRECISION,
    gamma          DOUBLE PRECISION,
    theta          DOUBLE PRECISION,
    vega           DOUBLE PRECISION,
    oi             DOUBLE PRECISION,
    volume         DOUBLE PRECISION,
    PRIMARY KEY (instrument_id, exchange_ts)
);

SELECT create_hypertable('option_chain_snapshots', by_range('exchange_ts', INTERVAL '7 days'));
ALTER TABLE option_chain_snapshots SET (
    timescaledb.enable_columnstore,
    timescaledb.segmentby = 'instrument_id',
    timescaledb.orderby   = 'exchange_ts DESC'
);
CALL add_columnstore_policy('option_chain_snapshots', after => INTERVAL '7 days');

CREATE TABLE collector_health_log (
    id              BIGSERIAL        PRIMARY KEY,
    exchange        TEXT             NOT NULL,
    stream_name     TEXT             NOT NULL,
    disconnected_at TIMESTAMPTZ      NOT NULL,
    reconnected_at  TIMESTAMPTZ,
    backfilled      BOOLEAN          NOT NULL DEFAULT FALSE,
    reason          TEXT
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS collector_health_log;
DROP TABLE IF EXISTS option_chain_snapshots;
DROP TABLE IF EXISTS market_snapshots;
DROP TABLE IF EXISTS candles_1m;
DROP TABLE IF EXISTS instruments;
-- +goose StatementEnd
