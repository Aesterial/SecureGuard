package dbrepo

import (
	"context"
	"errors"
	"fmt"

	dbconnection "github.com/aesterial/secureguard/internal/infra/db/connection"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"
	"github.com/jackc/pgx/v5/pgxpool"
)

type Client struct {
	Pool    *pgxpool.Pool
	Queries *dbsqlc.Queries
}

func New() (*Client, error) {
	pool, err := dbconnection.Connect()
	if err != nil {
		return nil, fmt.Errorf("open database connection: %w", err)
	}
	return NewWithPool(pool), nil
}

func NewWithPool(pool *pgxpool.Pool) *Client {
	return &Client{
		Pool:    pool,
		Queries: dbsqlc.New(pool),
	}
}

func (c *Client) Ping(ctx context.Context) error {
	if c == nil || c.Pool == nil {
		return errors.New("database client is not initialized")
	}
	return c.Pool.Ping(ctx)
}

func (c *Client) Querier() dbsqlc.Querier {
	if c == nil || c.Queries == nil {
		return nil
	}
	return c.Queries
}

func (c *Client) Close() {
	if c == nil || c.Pool == nil {
		return
	}
	c.Pool.Close()
}
