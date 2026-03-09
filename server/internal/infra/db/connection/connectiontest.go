package dbconnection

import (
	"context"
	"time"

	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

func RunTest(pool *pgxpool.Pool) error {
	ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)
	defer cancel()
	if err := pingTest(ctx, pool); err != nil {
		// log drop on ping test
		return err
	}
	if err := queryTest(ctx, pool); err != nil {
		// log drop on query test
		return err
	}
	return nil
}

func pingTest(ctx context.Context, pool *pgxpool.Pool) error {
	return pool.Ping(ctx)
}

func queryTest(ctx context.Context, pool *pgxpool.Pool) error {
	tx, err := pool.BeginTx(ctx, pgx.TxOptions{AccessMode: pgx.ReadOnly})
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)
	var one int
	if err := tx.QueryRow(ctx, "SELECT 1").Scan(&one); err != nil {
		return err
	}
	if one == 1 {
		return nil
	}
	return apperrors.ParamsNotMatch
}
