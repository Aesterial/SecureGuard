package loginapp

import (
	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	usersdomain "github.com/aesterial/secureguard/internal/domain/users"
	"golang.org/x/crypto/bcrypt"
)

type Service struct {
	usr usersdomain.Repository
	ses *sessionsapp.Service
}

func NewLoginService(usr usersdomain.Repository, ses *sessionsapp.Service) *Service {
	return &Service{usr: usr, ses: ses}
}

func (s *Service) generatePassword(raw string) (string, error) {
	hash, err := bcrypt.GenerateFromPassword([]byte(raw), bcrypt.DefaultCost)
	return string(hash), err
}
