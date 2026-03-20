package sessionsdomain

import (
	"time"

	sessionspb "github.com/aesterial/secureguard/internal/api/v1/sessions/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type Session struct {
	ID        string
	Hash      string
	Revoked   bool
	RevokedAt *time.Time
	Created   time.Time
	Expires   time.Time
	LastSeen  *time.Time
}

func (s *Session) rvProtobuf() *sessionspb.Session_RevokeInfo {
	var revokedAt *timestamppb.Timestamp = nil
	if s.Revoked {
		revokedAt = timestamppb.New(*s.RevokedAt)
	}
	return &sessionspb.Session_RevokeInfo{
		Revoked:   s.Revoked,
		RevokedAt: revokedAt,
	}
}

func (s *Session) Protobuf() *sessionspb.Session {
	if s == nil {
		return nil
	}
	var lastSeen *timestamppb.Timestamp = nil
	if s.LastSeen != nil {
		lastSeen = timestamppb.New(*s.LastSeen)
	}
	return &sessionspb.Session{
		Id:        s.ID,
		Hash:      s.Hash,
		Revoke:    s.rvProtobuf(),
		CreatedAt: timestamppb.New(s.Created),
		ExpiresAt: timestamppb.New(s.Expires),
		LastSeen:  lastSeen,
	}
}

type Sessions []*Session

func (s *Sessions) Protobuf(skipRevoked ...bool) []*sessionspb.Session {
	if s == nil {
		return nil
	}
	var skipRv bool
	if len(skipRevoked) > 0 {
		skipRv = skipRevoked[0]
	}
	var list = make([]*sessionspb.Session, len(*s))
	for i, e := range *s {
		if e.Revoked && skipRv {
			continue
		}
		list[i] = e.Protobuf()
	}
	return list
}
