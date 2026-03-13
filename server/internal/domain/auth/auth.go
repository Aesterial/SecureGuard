package authdomain

import "github.com/aesterial/secureguard/internal/domain"

type Meta struct {
	UserID    *domain.UUID
	SessionID *domain.UUID
	Hash      string
}
