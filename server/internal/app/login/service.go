package loginapp

import (
	dbrepo "github.com/aesterial/secureguard/internal/infra/db"
	"golang.org/x/crypto/bcrypt"
)

type Service struct {
	client dbrepo.Client
}

func (s *Service) generatePassword(raw string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(raw), bcrypt.DefaultCost)
	return string(hash), err
}
