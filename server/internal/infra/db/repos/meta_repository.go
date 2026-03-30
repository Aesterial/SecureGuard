package repos

import (
	metadomain "github.com/aesterial/secureguard/internal/domain/meta"
	dbsqlc "github.com/aesterial/secureguard/internal/infra/db/sqlc"

	"context"
)

type MetaRepository struct {
	querier dbsqlc.Querier
}

var _ metadomain.Repository = (*MetaRepository)(nil)

func NewMetaRepository(querier dbsqlc.Querier) *MetaRepository {
	return &MetaRepository{querier: querier}
}

func (m *MetaRepository) GetLocalisationsByLocale(ctx context.Context, locale string) (map[string]string, error) {
	rows, err := m.querier.GetListByLocale(ctx, dbsqlc.LocalisationType(locale))
	if err != nil {
		return nil, err
	}
	var resp = make(map[string]string)
	for _, e := range rows {
		resp[e.Key] = e.Content
	}
	return resp, nil
}
