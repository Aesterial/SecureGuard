package passdomain

import (
	"net/url"
	"strings"
	"time"

	passpb "github.com/aesterial/secureguard/internal/api/v1/passwords/v1"
	"github.com/aesterial/secureguard/internal/domain"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type Target int

const (
	ServiceTarget Target = iota
	LoginTarget
	PassTarget
)

func ParseService(s string) Service {
	s = strings.TrimSpace(s)

	result := Service{name: s}
	if s == "" {
		return result
	}

	if !strings.Contains(s, ".") && !strings.Contains(s, "://") {
		return result
	}

	raw := s
	if !strings.Contains(raw, "://") {
		raw = "https://" + raw
	}

	u, err := url.Parse(raw)
	if err != nil || u.Hostname() == "" {
		return result
	}

	host := strings.TrimPrefix(strings.ToLower(u.Hostname()), "www.")
	result.name = serviceNameFromHost(host)
	result.url = &host

	return result
}

func serviceNameFromHost(host string) string {
	parts := strings.Split(host, ".")
	if len(parts) == 0 {
		return host
	}
	return parts[0]
}

type Service struct {
	url  *string
	name string
}

func (s Service) Protobuf() *passpb.ServiceInfo {
	var url string
	if s.url != nil {
		url = *s.url
	}
	return &passpb.ServiceInfo{
		Url:  url,
		Name: s.name,
	}
}

type Password struct {
	ID       domain.UUID
	Service  Service
	Login    string
	Password string
	Created  time.Time
}

func (p *Password) Protobuf() *passpb.Password {
	return &passpb.Password{
		Serv:      p.Service.Protobuf(),
		Login:     p.Login,
		Pass:      p.Password,
		CreatedAt: timestamppb.New(p.Created),
	}
}

type Passwords []*Password

func (p Passwords) Protobuf() []*passpb.Password {
	var list = make([]*passpb.Password, len(p))
	for i, element := range p {
		list[i] = element.Protobuf()
	}
	return list
}
