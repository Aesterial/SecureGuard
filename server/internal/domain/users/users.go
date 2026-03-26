package usersdomain

import (
	"strings"
	"time"

	typespb "github.com/aesterial/secureguard/internal/api/v1"
	userpb "github.com/aesterial/secureguard/internal/api/v1/users/v1"
	"github.com/aesterial/secureguard/internal/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type Theme int
type Language int
type Crypt int

const (
	ThemeUnspecified Theme = iota
	ThemeWhite
	ThemeBlack
)

const (
	LanguageUnspecified Language = iota
	LanguageRU
	LanguageEn
)

const (
	CryptUnspecified Crypt = iota
	CryptArgon2ID
	CryptSha256
)

func ParseThemePB(pb userpb.Theme) Theme {
	switch pb {
	case userpb.Theme_THEME_BLACK:
		return ThemeBlack
	case userpb.Theme_THEME_WHITE:
		return ThemeWhite
	default:
		return ThemeUnspecified
	}
}

func ParseLanguagePB(pb userpb.Language) Language {
	switch pb {
	case userpb.Language_LANGUAGE_EN:
		return LanguageEn
	case userpb.Language_LANGUAGE_RU:
		return LanguageRU
	default:
		return LanguageUnspecified
	}
}

func ParseCryptPB(pb userpb.Crypt) Crypt {
	switch pb {
	case userpb.Crypt_CRYPT_ARGON2ID:
		return CryptArgon2ID
	case userpb.Crypt_CRYPT_SHA256:
		return CryptSha256
	default:
		return CryptUnspecified
	}
}

func ParseLanguageSTR(str string) Language {
	switch strings.ToLower(str) {
	case "ru":
		return LanguageRU
	case "en":
		return LanguageEn
	default:
		return LanguageUnspecified
	}
}

func ParseThemeSTR(str string) Theme {
	switch strings.ToLower(str) {
	case "white":
		return ThemeWhite
	case "black":
		return ThemeBlack
	default:
		return ThemeUnspecified
	}
}

func ParseCryptSTR(str string) Crypt {
	switch strings.ToLower(str) {
	case "argon2id":
		return CryptArgon2ID
	case "sha-256":
		return CryptSha256
	default:
		return CryptUnspecified
	}
}

func (t Theme) String() string {
	switch t {
	case ThemeWhite:
		return "white"
	case ThemeBlack:
		return "black"
	}
	return "white"
}

func (t Theme) Int32() int32 {
	return int32(t)
}

func (t Theme) IsValid() bool {
	switch t {
	case ThemeUnspecified, ThemeBlack, ThemeWhite:
		return true
	default:
		return false
	}
}

func (l Language) String() string {
	switch l {
	case LanguageRU:
		return "ru"
	case LanguageEn:
		return "en"
	}
	return "ru"
}

func (l Language) Int32() int32 {
	return int32(l)
}

func (l Language) IsValid() bool {
	switch l {
	case LanguageEn, LanguageRU, LanguageUnspecified:
		return true
	default:
		return false
	}
}

func (c Crypt) String() string {
	switch c {
	case CryptArgon2ID:
		return "argon2id"
	case CryptSha256:
		return "sha-256"
	}
	return "argon2id"
}

func (c Crypt) Int32() int32 {
	return int32(c)
}

func (c Crypt) IsValid() bool {
	switch c {
	case CryptArgon2ID, CryptSha256, CryptUnspecified:
		return true
	default:
		return false
	}
}

func (t Theme) PB() userpb.Theme {
	switch t {
	case ThemeWhite:
		return userpb.Theme_THEME_WHITE
	case ThemeBlack:
		return userpb.Theme_THEME_BLACK
	default:
		return userpb.Theme_THEME_UNSPECIFIED
	}
}

func (l Language) PB() userpb.Language {
	switch l {
	case LanguageRU:
		return userpb.Language_LANGUAGE_RU
	case LanguageEn:
		return userpb.Language_LANGUAGE_EN
	default:
		return userpb.Language_LANGUAGE_UNSPECIFIED
	}
}

func (c Crypt) PB() userpb.Crypt {
	switch c {
	case CryptArgon2ID:
		return userpb.Crypt_CRYPT_ARGON2ID
	case CryptSha256:
		return userpb.Crypt_CRYPT_SHA256
	default:
		return userpb.Crypt_CRYPT_UNSPECIFIED
	}
}

type Preferences struct {
	Theme Theme
	Lang  Language
	Crypt Crypt
}

type User struct {
	ID          domain.UUID
	Username    string
	Joined      time.Time
	Staff       bool
	Preferences Preferences
}

func (u *User) ProtobufSelf() *userpb.UserSelf {
	if u == nil {
		return nil
	}
	p := u.Preferences

	return &userpb.UserSelf{
		Id:       u.ID.String(),
		Username: u.Username,
		Joined:   timestamppb.New(u.Joined),
		Staff:    u.Staff,
		Preferences: &userpb.Preferences{
			Theme: p.Theme.PB(),
			Lang:  p.Lang.PB(),
		},
	}
}

func (u *User) ProtobufPublic() *userpb.UserPublic {
	if u == nil {
		return nil
	}
	p := u.Preferences
	return &userpb.UserPublic{
		Id:        u.ID.String(),
		Username:  u.Username,
		Lang:      p.Lang.PB(),
		Crypt:     p.Crypt.PB(),
	}
}

type Users []*User

func (usrs Users) Protobuf() []*userpb.UserPublic {
	if usrs == nil {
		return nil
	}
	out := make([]*userpb.UserPublic, len(usrs))
	for i, u := range usrs {
		out[i] = u.ProtobufPublic()
	}
	return out
}

type KDFparams struct {
	Version     int32
	Memory      int64
	Iterations  int32
	Parallelism int32
}

func ParseKdfParams(kdf *typespb.Kdf) KDFparams {
	return KDFparams{
		Version:     kdf.GetVersion(),
		Memory:      kdf.GetMemory(),
		Iterations:  kdf.GetIterations(),
		Parallelism: kdf.GetParallelism(),
	}
}
