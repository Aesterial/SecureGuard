package metadomain

import "context"

type Repository interface {
	GetLocalisationsByLocale(ctx context.Context, locale string) (map[string]string, error)
}
