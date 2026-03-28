package metadomain

import (
	"time"

	metapb "github.com/aesterial/secureguard/internal/api/v1/meta/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type ServerInfo struct {
	Name           string
	Version        string
	RuntimeVersion string
	Apis           []float32
	Commit         string
	Repository     string
	BuildTime      time.Time
}

type Localisation struct {
	English map[string]string
	Russian map[string]string
}

func (l *Localisation) Protobuf() *metapb.LocalisationResponse {
	return &metapb.LocalisationResponse{
		En: l.English,
		Ru: l.Russian,
	}
}

func (s *ServerInfo) Protobuf() *metapb.ServerInfo {
	if s == nil {
		return nil
	}
	info := &metapb.ServerInfo{
		Name:           s.Name,
		Version:        s.Version,
		RuntimeVersion: s.RuntimeVersion,
		Reporitory:     s.Repository,
		SupporingVer:   s.Apis,
		CommitHash:     s.Commit,
	}
	if !s.BuildTime.IsZero() {
		info.BuildTime = timestamppb.New(s.BuildTime)
	}
	return info
}
