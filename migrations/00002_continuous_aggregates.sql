-- +goose NO TRANSACTION
-- +goose Up
CREATE MATERIALIZED VIEW candles_4h
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('4 hours', ts) AS bucket,
    instrument_id,
    first(open, ts)            AS open,
    max(high)                  AS high,
    min(low)                   AS low,
    last(close, ts)            AS close,
    sum(volume)                AS volume,
    last(oi, ts)               AS oi
FROM candles_1m
GROUP BY bucket, instrument_id
WITH NO DATA;

SELECT add_continuous_aggregate_policy('candles_4h',
    start_offset      => INTERVAL '1 day',
    end_offset        => INTERVAL '1 minute',
    schedule_interval => INTERVAL '15 minutes'
);

CREATE MATERIALIZED VIEW candles_6h
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('6 hours', ts) AS bucket,
    instrument_id,
    first(open, ts)            AS open,
    max(high)                  AS high,
    min(low)                   AS low,
    last(close, ts)            AS close,
    sum(volume)                AS volume,
    last(oi, ts)               AS oi
FROM candles_1m
GROUP BY bucket, instrument_id
WITH NO DATA;

SELECT add_continuous_aggregate_policy('candles_6h',
    start_offset      => INTERVAL '1 day',
    end_offset        => INTERVAL '1 minute',
    schedule_interval => INTERVAL '15 minutes'
);

CREATE MATERIALIZED VIEW candles_1d
WITH (timescaledb.continuous) AS
SELECT
    time_bucket('1 day', ts)   AS bucket,
    instrument_id,
    first(open, ts)            AS open,
    max(high)                  AS high,
    min(low)                   AS low,
    last(close, ts)            AS close,
    sum(volume)                AS volume,
    last(oi, ts)               AS oi
FROM candles_1m
GROUP BY bucket, instrument_id
WITH NO DATA;

SELECT add_continuous_aggregate_policy('candles_1d',
    start_offset      => INTERVAL '3 days',
    end_offset        => INTERVAL '1 minute',
    schedule_interval => INTERVAL '1 hour'
);

-- +goose Down
DROP MATERIALIZED VIEW IF EXISTS candles_1d;
DROP MATERIALIZED VIEW IF EXISTS candles_6h;
DROP MATERIALIZED VIEW IF EXISTS candles_4h;
