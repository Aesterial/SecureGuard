package metaapp

import (
	metapb "github.com/aesterial/secureguard/internal/api/v1/meta/v1"
	metadomain "github.com/aesterial/secureguard/internal/domain/meta"
	meta "github.com/aesterial/secureguard/internal/shared/metadata"
)

type Service struct{}

func NewService() *Service {
	return &Service{}
}

func (s *Service) CheckCompability(clientVer float32, clientType metapb.ClientType) (bool, []string) {
	var reasons []string
	var correctVer, correctClient bool
	for _, e := range meta.SupportedVersions {
		if e == clientVer {
			correctVer = true
			break
		}
	}
	if !correctVer {
		reasons = append(reasons, "unsupported api version")
	}
	switch clientType {
	case metapb.ClientType_CLIENT_TYPE_SECUREGUARD_WINDOWS, metapb.ClientType_CLIENT_TYPE_SECUREGUARD_MAC, metapb.ClientType_CLIENT_TYPE_SECUREGUARD_ANDROID, metapb.ClientType_CLIENT_TYPE_SECUREGUARD_IOS:
		correctClient = true
	default:
		reasons = append(reasons, "unsupported client type")
	}
	return (correctVer == true) && (correctClient == true), reasons
}

func (s *Service) ServerInformation() *metadomain.ServerInfo {
	return &metadomain.ServerInfo{
		Name:           meta.ServerName,
		Version:        meta.ServerVersion,
		RuntimeVersion: meta.GoVersion,
		Apis:           meta.SupportedVersions,
		Commit:         meta.CommitHash,
		Repository:     meta.Repository,
		BuildTime:      meta.BuildTimestamp(),
	}
}
