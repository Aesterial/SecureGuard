package passdomain

import (
	"time"

	"github.com/aesterial/secureguard/internal/domain"
)

type service struct {
	url  string
	name string
}

type Password struct {
	ID       domain.UUID
	Service  service
	Login    string
	Password string
	Created  time.Time
}
