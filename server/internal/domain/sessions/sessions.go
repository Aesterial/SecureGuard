package sessionsdomain

import (
	"time"

	"github.com/aesterial/secureguard/internal/domain"
)

type Session struct {
	ID      domain.UUID
	Hash    string
	Revoked bool
	Created time.Time
	Expires time.Time
}
