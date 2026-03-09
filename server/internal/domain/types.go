package domain

import (
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
)

type UUID struct {
	uuid.UUID
}

func ParseUUID(bytes [16]byte) UUID {
	return UUID{UUID: bytes}
}

func (u UUID) PG() pgtype.UUID {
	return pgtype.UUID{Bytes: u.UUID, Valid: true}
}
