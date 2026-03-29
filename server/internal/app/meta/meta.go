package metaapp

import (
	"context"
	"sync"

	metapb "github.com/aesterial/secureguard/internal/api/v1/meta/v1"
	metadomain "github.com/aesterial/secureguard/internal/domain/meta"
	meta "github.com/aesterial/secureguard/internal/shared/metadata"
)

type Service struct {
	meta metadomain.Repository
}

func NewService(r metadomain.Repository) *Service {
	return &Service{meta: r}
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
	return correctVer && correctClient, reasons
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

func (s *Service) GetLocalisations(ctx context.Context) (*metadomain.Localisation, error) {
	var wg sync.WaitGroup
	var resp = metadomain.Localisation{
		Russian: make(map[string]string),
		English: make(map[string]string),
	}
	var err error
	setErr := func(e error) {
		err = e
	}
	for _, element := range []string{"ru", "en"} {
		wg.Add(1)
		go func() {
			data, loopErr := s.meta.GetLocalisationsByLocale(ctx, element)
			if loopErr != nil {
				setErr(loopErr)
			}
			switch element {
			case "ru":
				resp.Russian = data
			case "en":
				resp.English = data
			}
			wg.Done()
		}()
	}
	wg.Wait()
	if err != nil {
		return nil, err
	}
	return &resp, nil
}
