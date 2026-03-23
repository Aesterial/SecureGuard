package ratelimitapp

import (
	"context"

	ratelimitdomain "github.com/aesterial/secureguard/internal/domain/ratelimit"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
)

type Service struct {
	repo  ratelimitdomain.Repository
	rules ratelimitdomain.Rules
}

func NewService(repo ratelimitdomain.Repository, rules ratelimitdomain.Rules) *Service {
	return &Service{repo: repo, rules: rules}
}

func (s *Service) AllowAuthorize(ctx context.Context, ip string) error {
	if s == nil {
		return nil
	}
	return s.allow(ctx, ratelimitdomain.AuthorizeBucket, ip, s.rules.Authorize)
}

func (s *Service) AllowRegister(ctx context.Context, ip string) error {
	if s == nil {
		return nil
	}
	return s.allow(ctx, ratelimitdomain.RegisterBucket, ip, s.rules.Register)
}

func (s *Service) AllowMeta(ctx context.Context, ip string) error {
	if s == nil {
		return nil
	}
	return s.allow(ctx, ratelimitdomain.MetaBucket, ip, s.rules.Meta)
}

func (s *Service) allow(ctx context.Context, bucket ratelimitdomain.Bucket, ip string, rule ratelimitdomain.Rule) error {
	if s == nil || s.repo == nil || rule.IsZero() {
		return nil
	}
	allowed, _, err := s.repo.Allow(ctx, bucket, ip, rule)
	if err != nil {
		return apperrors.Wrap(err)
	}
	if !allowed {
		return apperrors.ResourceExhausted
	}
	return nil
}
