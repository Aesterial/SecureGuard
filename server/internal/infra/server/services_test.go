package server

import (
	"context"
	"errors"
	"testing"
	"time"

	typespb "github.com/aesterial/secureguard/internal/api/v1"
	loginpb "github.com/aesterial/secureguard/internal/api/v1/login/v1"
	metapb "github.com/aesterial/secureguard/internal/api/v1/meta/v1"
	passpb "github.com/aesterial/secureguard/internal/api/v1/passwords/v1"
	statspb "github.com/aesterial/secureguard/internal/api/v1/stats/v1"
	userpb "github.com/aesterial/secureguard/internal/api/v1/users/v1"
	loginapp "github.com/aesterial/secureguard/internal/app/login"
	metaapp "github.com/aesterial/secureguard/internal/app/meta"
	passapp "github.com/aesterial/secureguard/internal/app/passwords"
	ratelimitapp "github.com/aesterial/secureguard/internal/app/ratelimit"
	sessionsapp "github.com/aesterial/secureguard/internal/app/sessions"
	statsapp "github.com/aesterial/secureguard/internal/app/stats"
	usersapp "github.com/aesterial/secureguard/internal/app/users"
	"github.com/aesterial/secureguard/internal/domain"
	passdomain "github.com/aesterial/secureguard/internal/domain/passwords"
	ratelimitdomain "github.com/aesterial/secureguard/internal/domain/ratelimit"
	sessionsdomain "github.com/aesterial/secureguard/internal/domain/sessions"
	statsdomain "github.com/aesterial/secureguard/internal/domain/stats"
	usersdomain "github.com/aesterial/secureguard/internal/domain/users"
	apperrors "github.com/aesterial/secureguard/internal/shared/errors"
	sharedmetadata "github.com/aesterial/secureguard/internal/shared/metadata"
	"github.com/google/uuid"
	"google.golang.org/grpc/metadata"
	"google.golang.org/protobuf/types/known/emptypb"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type serverUsersRepoMock struct {
	getByIDFn          func(context.Context, domain.UUID) (*usersdomain.User, error)
	getByUsernameFn    func(context.Context, string) (*usersdomain.User, error)
	getByIDsFn         func(context.Context, int32, ...domain.UUID) (usersdomain.Users, error)
	getPasswordByName  func(context.Context, string) (string, error)
	isExistsFn         func(context.Context, domain.UUID) (bool, error)
	isUsernameExistsFn func(context.Context, string) (bool, error)
	isUserAdminFn      func(context.Context, domain.UUID) (bool, error)
	changeCryptFn      func(context.Context, domain.UUID, usersdomain.Crypt) error
	changeThemeFn      func(context.Context, domain.UUID, usersdomain.Theme) error
	changeLanguageFn   func(context.Context, domain.UUID, usersdomain.Language) error
	createFn           func(context.Context, string, string, string) (*usersdomain.User, error)
	createUserKeyFn    func(context.Context, domain.UUID, string, string, usersdomain.KDFparams) error
}

func (m *serverUsersRepoMock) GetByID(ctx context.Context, target domain.UUID) (*usersdomain.User, error) {
	if m.getByIDFn != nil {
		return m.getByIDFn(ctx, target)
	}
	return nil, nil
}
func (m *serverUsersRepoMock) GetByUsername(ctx context.Context, target string) (*usersdomain.User, error) {
	if m.getByUsernameFn != nil {
		return m.getByUsernameFn(ctx, target)
	}
	return nil, nil
}
func (m *serverUsersRepoMock) GetByIDs(ctx context.Context, limit int32, targets ...domain.UUID) (usersdomain.Users, error) {
	if m.getByIDsFn != nil {
		return m.getByIDsFn(ctx, limit, targets...)
	}
	return nil, nil
}
func (m *serverUsersRepoMock) GetList(context.Context, int32, int32) (usersdomain.Users, error) {
	return nil, nil
}
func (m *serverUsersRepoMock) GetPassword(context.Context, domain.UUID) (string, error) {
	return "", nil
}
func (m *serverUsersRepoMock) GetPasswordByUsername(ctx context.Context, username string) (string, error) {
	if m.getPasswordByName != nil {
		return m.getPasswordByName(ctx, username)
	}
	return "", nil
}
func (m *serverUsersRepoMock) GetUserKey(context.Context, domain.UUID) (*usersdomain.UserKey, error) {
	return nil, nil
}
func (m *serverUsersRepoMock) IsExists(ctx context.Context, target domain.UUID) (bool, error) {
	if m.isExistsFn != nil {
		return m.isExistsFn(ctx, target)
	}
	return false, nil
}
func (m *serverUsersRepoMock) IsUserAdmin(ctx context.Context, target domain.UUID) (bool, error) {
	if m.isUserAdminFn != nil {
		return m.isUserAdminFn(ctx, target)
	}
	return false, nil
}
func (m *serverUsersRepoMock) IsUsernameExists(ctx context.Context, username string) (bool, error) {
	if m.isUsernameExistsFn != nil {
		return m.isUsernameExistsFn(ctx, username)
	}
	return false, nil
}
func (m *serverUsersRepoMock) ChangeCrypt(ctx context.Context, target domain.UUID, set usersdomain.Crypt) error {
	if m.changeCryptFn != nil {
		return m.changeCryptFn(ctx, target, set)
	}
	return nil
}
func (m *serverUsersRepoMock) ChangeTheme(ctx context.Context, target domain.UUID, set usersdomain.Theme) error {
	if m.changeThemeFn != nil {
		return m.changeThemeFn(ctx, target, set)
	}
	return nil
}
func (m *serverUsersRepoMock) ChangeLanguage(ctx context.Context, target domain.UUID, set usersdomain.Language) error {
	if m.changeLanguageFn != nil {
		return m.changeLanguageFn(ctx, target, set)
	}
	return nil
}
func (m *serverUsersRepoMock) ChangePhrase(context.Context, domain.UUID, string) error {
	return nil
}
func (m *serverUsersRepoMock) Create(ctx context.Context, username string, passwordHash, seedHash string) (*usersdomain.User, error) {
	if m.createFn != nil {
		return m.createFn(ctx, username, passwordHash, seedHash)
	}
	return nil, nil
}
func (m *serverUsersRepoMock) CreateUserKey(ctx context.Context, target domain.UUID, key string, salt string, kdf usersdomain.KDFparams) error {
	if m.createUserKeyFn != nil {
		return m.createUserKeyFn(ctx, target, key, salt, kdf)
	}
	return nil
}
func (m *serverUsersRepoMock) ChangeUserKey(context.Context, domain.UUID, string, string, usersdomain.KDFparams) error {
	return nil
}

type serverSessionsRepoMock struct {
	getOwnerFn    func(context.Context, string) (*domain.UUID, error)
	getInfoFn     func(context.Context, string) (*sessionsdomain.Session, error)
	isExistsFn    func(context.Context, string) (bool, error)
	createFn      func(context.Context, string, domain.UUID, string) (*string, error)
	revokeFn      func(context.Context, string) error
	setLastSeenFn func(context.Context, string, time.Time) error
}

func (m *serverSessionsRepoMock) GetOwner(ctx context.Context, id string) (*domain.UUID, error) {
	if m.getOwnerFn != nil {
		return m.getOwnerFn(ctx, id)
	}
	return nil, nil
}
func (m *serverSessionsRepoMock) GetInfo(ctx context.Context, id string) (*sessionsdomain.Session, error) {
	if m.getInfoFn != nil {
		return m.getInfoFn(ctx, id)
	}
	return nil, nil
}
func (m *serverSessionsRepoMock) IsExists(ctx context.Context, id string) (bool, error) {
	if m.isExistsFn != nil {
		return m.isExistsFn(ctx, id)
	}
	return false, nil
}
func (m *serverSessionsRepoMock) Create(ctx context.Context, id string, owner domain.UUID, hash string) (*string, error) {
	if m.createFn != nil {
		return m.createFn(ctx, id, owner, hash)
	}
	return nil, nil
}
func (m *serverSessionsRepoMock) Revoke(ctx context.Context, id string) error {
	if m.revokeFn != nil {
		return m.revokeFn(ctx, id)
	}
	return nil
}
func (m *serverSessionsRepoMock) GetExpired(context.Context) ([]string, error) {
	return nil, nil
}
func (m *serverSessionsRepoMock) SetLastSeen(ctx context.Context, id string, at time.Time) error {
	if m.setLastSeenFn != nil {
		return m.setLastSeenFn(ctx, id, at)
	}
	return nil
}
func (m *serverSessionsRepoMock) GetListByOwner(context.Context, domain.UUID, int32, int32) (sessionsdomain.Sessions, error) {
	return nil, nil
}

type serverPassRepoMock struct {
	getListFn  func(context.Context, domain.UUID, int32, int32) (passdomain.Passwords, error)
	getOwnerFn func(context.Context, domain.UUID) (*domain.UUID, error)
	createFn   func(context.Context, domain.UUID, string, string, string, int32, []byte, string, []byte) (*passdomain.Password, error)
	updateFn   func(context.Context, domain.UUID, passdomain.Target, string, string) (*passdomain.Password, error)
	deleteFn   func(context.Context, domain.UUID) error
}

func (m *serverPassRepoMock) GetList(ctx context.Context, target domain.UUID, limit int32, offset int32) (passdomain.Passwords, error) {
	if m.getListFn != nil {
		return m.getListFn(ctx, target, limit, offset)
	}
	return nil, nil
}
func (m *serverPassRepoMock) GetOwner(ctx context.Context, id domain.UUID) (*domain.UUID, error) {
	if m.getOwnerFn != nil {
		return m.getOwnerFn(ctx, id)
	}
	return nil, nil
}
func (m *serverPassRepoMock) Create(ctx context.Context, target domain.UUID, service string, login string, pass string, version int32, aad []byte, nonce string, metadata []byte) (*passdomain.Password, error) {
	if m.createFn != nil {
		return m.createFn(ctx, target, service, login, pass, version, aad, nonce, metadata)
	}
	return nil, nil
}
func (m *serverPassRepoMock) Update(ctx context.Context, target domain.UUID, update passdomain.Target, value string, salt string) (*passdomain.Password, error) {
	if m.updateFn != nil {
		return m.updateFn(ctx, target, update, value, salt)
	}
	return nil, nil
}
func (m *serverPassRepoMock) Delete(ctx context.Context, id domain.UUID) error {
	if m.deleteFn != nil {
		return m.deleteFn(ctx, id)
	}
	return nil
}

type serverStatsRepoMock struct {
	byDateFn func(context.Context, statsdomain.TimeRange, ...bool) (*statsdomain.Stats, error)
	totalFn  func(context.Context) (*statsdomain.Total, error)
}

type serverRateLimitRepoMock struct {
	allowFn func(context.Context, ratelimitdomain.Bucket, string, ratelimitdomain.Rule) (bool, time.Duration, error)
}

func (m *serverStatsRepoMock) ByDate(ctx context.Context, r statsdomain.TimeRange, viewSaved ...bool) (*statsdomain.Stats, error) {
	if m.byDateFn != nil {
		return m.byDateFn(ctx, r, viewSaved...)
	}
	return nil, nil
}
func (m *serverStatsRepoMock) GetLatency(context.Context, statsdomain.TimeRange, ...bool) (*statsdomain.Latency, error) {
	return nil, nil
}
func (m *serverStatsRepoMock) GetTotal(ctx context.Context) (*statsdomain.Total, error) {
	if m.totalFn != nil {
		return m.totalFn(ctx)
	}
	return nil, nil
}
func (m *serverStatsRepoMock) GetActivity(context.Context, statsdomain.TimeRange) (*statsdomain.ActivityStats, error) {
	return nil, nil
}
func (m *serverStatsRepoMock) GetUsersPreferences(context.Context) (*statsdomain.PreferencesStats, error) {
	return nil, nil
}
func (m *serverStatsRepoMock) GetTopServices(context.Context, statsdomain.TimeRange, ...bool) (map[string]int32, error) {
	return nil, nil
}

func (m *serverRateLimitRepoMock) Allow(ctx context.Context, bucket ratelimitdomain.Bucket, key string, rule ratelimitdomain.Rule) (bool, time.Duration, error) {
	if m.allowFn != nil {
		return m.allowFn(ctx, bucket, key, rule)
	}
	return true, 0, nil
}

func newServerUUID() domain.UUID {
	return domain.ParseUUID(uuid.New())
}

func newServerUser(id domain.UUID, username string) *usersdomain.User {
	return &usersdomain.User{
		ID:       id,
		Username: username,
		Joined:   time.Now().UTC(),
		Preferences: usersdomain.Preferences{
			Theme: usersdomain.ThemeBlack,
			Lang:  usersdomain.LanguageEn,
		},
	}
}

func newAuthContext(hash string, sessionID string) context.Context {
	return metadata.NewIncomingContext(
		context.Background(),
		metadata.Pairs("client", hash, "session", "SG-"+sessionID),
	)
}

func TestLoginServiceRegisterSuccess(t *testing.T) {
	userID := newServerUUID()
	createUserKeyCalled := false

	userRepo := &serverUsersRepoMock{
		isUsernameExistsFn: func(context.Context, string) (bool, error) {
			return false, nil
		},
		createFn: func(_ context.Context, username string, passwordHash, seedHash string) (*usersdomain.User, error) {
			if username == "" || passwordHash == "" || seedHash == "" {
				t.Fatalf("expected non-empty registration data")
			}
			return &usersdomain.User{ID: userID}, nil
		},
		createUserKeyFn: func(_ context.Context, target domain.UUID, key string, salt string, kdf usersdomain.KDFparams) error {
			createUserKeyCalled = true
			if target != userID || key != "master-key" || salt != "salt-value" {
				t.Fatalf("unexpected user key args")
			}
			if kdf.Version != 1 || kdf.Memory != 64 || kdf.Iterations != 3 || kdf.Parallelism != 2 {
				t.Fatalf("unexpected kdf params: %#v", kdf)
			}
			return nil
		},
		isExistsFn: func(context.Context, domain.UUID) (bool, error) {
			return true, nil
		},
		getByIDFn: func(context.Context, domain.UUID) (*usersdomain.User, error) {
			return newServerUser(userID, "abc123"), nil
		},
	}
	sessionsRepo := &serverSessionsRepoMock{
		createFn: func(_ context.Context, id string, owner domain.UUID, hash string) (*string, error) {
			if owner != userID {
				t.Fatalf("unexpected session owner")
			}
			if id == "" {
				t.Fatalf("expected encoded session id")
			}
			if hash != "device-hash" {
				t.Fatalf("unexpected hash: %s", hash)
			}
			return &id, nil
		},
	}

	usrService := usersapp.NewUserService(userRepo)
	sesService := sessionsapp.NewSessionService(sessionsRepo)
	loginService := loginapp.NewLoginService(userRepo, sesService)
	server := NewLoginService(usrService, loginService, NewAuthentificator(sesService, usrService))

	ctx := metadata.NewIncomingContext(context.Background(), metadata.Pairs("client", "device-hash"))
	resp, err := server.Register(ctx, &loginpb.RegisterRequest{
		Username:  "abcDEF123",
		Password:  "password-123",
		MasterKey: "master-key",
		Salt:      "salt-value",
		KdfParams: &typespb.Kdf{
			Version:     1,
			Memory:      64,
			Iterations:  3,
			Parallelism: 2,
		},
	})
	if err != nil {
		t.Fatalf("Register returned error: %v", err)
	}
	if resp == nil || resp.GetSession() == "" {
		t.Fatalf("unexpected register response: %#v", resp)
	}
	if !createUserKeyCalled {
		t.Fatalf("expected CreateUserKey call")
	}
}

func TestLoginServiceAuthorizeDeniesWhenUserMissing(t *testing.T) {
	userRepo := &serverUsersRepoMock{
		isUsernameExistsFn: func(context.Context, string) (bool, error) {
			return false, nil
		},
	}
	sessionsRepo := &serverSessionsRepoMock{}
	usrService := usersapp.NewUserService(userRepo)
	sesService := sessionsapp.NewSessionService(sessionsRepo)
	loginService := loginapp.NewLoginService(userRepo, sesService)
	server := NewLoginService(usrService, loginService, NewAuthentificator(sesService, usrService))

	ctx := metadata.NewIncomingContext(context.Background(), metadata.Pairs("client", "device-hash"))
	_, err := server.Authorize(ctx, &loginpb.AuthorizeRequest{Username: "tester", Password: "password-123"})
	if !errors.Is(err, apperrors.AccessDenied) {
		t.Fatalf("expected access denied, got %v", err)
	}
}

func TestLoginServiceLogoutSuccess(t *testing.T) {
	userID := newServerUUID()
	sessionID := uuid.NewString()
	revoked := false
	var encodedID string

	userRepo := &serverUsersRepoMock{
		isUserAdminFn: func(context.Context, domain.UUID) (bool, error) { return false, nil },
	}
	sessionsRepo := &serverSessionsRepoMock{
		isExistsFn: func(_ context.Context, id string) (bool, error) {
			encodedID = id
			return true, nil
		},
		getInfoFn: func(context.Context, string) (*sessionsdomain.Session, error) {
			return &sessionsdomain.Session{ID: sessionID, Hash: "device-hash", Expires: time.Now().Add(time.Hour)}, nil
		},
		getOwnerFn: func(context.Context, string) (*domain.UUID, error) { return &userID, nil },
		revokeFn: func(_ context.Context, id string) error {
			if id != encodedID {
				t.Fatalf("unexpected encoded session id")
			}
			revoked = true
			return nil
		},
	}

	usrService := usersapp.NewUserService(userRepo)
	sesService := sessionsapp.NewSessionService(sessionsRepo)
	server := NewLoginService(usrService, loginapp.NewLoginService(userRepo, sesService), NewAuthentificator(sesService, usrService))

	_, err := server.Logout(newAuthContext("device-hash", sessionID), &emptypb.Empty{})
	if err != nil {
		t.Fatalf("Logout returned error: %v", err)
	}
	if !revoked {
		t.Fatalf("expected session revoke call")
	}
}

func TestUserServiceInfoAndChangeTheme(t *testing.T) {
	userID := newServerUUID()
	sessionID := uuid.NewString()

	userRepo := &serverUsersRepoMock{
		isExistsFn: func(context.Context, domain.UUID) (bool, error) { return true, nil },
		getByIDFn: func(context.Context, domain.UUID) (*usersdomain.User, error) {
			return newServerUser(userID, "tester"), nil
		},
		changeThemeFn: func(context.Context, domain.UUID, usersdomain.Theme) error {
			return nil
		},
	}
	sessionsRepo := &serverSessionsRepoMock{
		isExistsFn: func(context.Context, string) (bool, error) { return true, nil },
		getInfoFn: func(context.Context, string) (*sessionsdomain.Session, error) {
			return &sessionsdomain.Session{ID: sessionID, Hash: "device-hash", Expires: time.Now().Add(time.Hour)}, nil
		},
		getOwnerFn: func(context.Context, string) (*domain.UUID, error) { return &userID, nil },
	}

	usrService := usersapp.NewUserService(userRepo)
	sesService := sessionsapp.NewSessionService(sessionsRepo)
	server := NewUserService(usrService, NewAuthentificator(sesService, usrService))
	ctx := newAuthContext("device-hash", sessionID)

	info, err := server.Info(ctx, &emptypb.Empty{})
	if err != nil {
		t.Fatalf("Info returned error: %v", err)
	}
	if info == nil || info.GetInfo().GetId() == "" {
		t.Fatalf("unexpected info response: %#v", info)
	}

	changed, err := server.ChangeTheme(ctx, &userpb.ChangeThemeRequest{Value: userpb.Theme_THEME_BLACK})
	if err != nil {
		t.Fatalf("ChangeTheme returned error: %v", err)
	}
	if changed.GetResult() != userpb.Theme_THEME_BLACK {
		t.Fatalf("unexpected theme response")
	}
}

func TestPasswordsServiceUpdateUsesFirstProvidedField(t *testing.T) {
	userID := newServerUUID()
	sessionID := uuid.NewString()
	targetID := newServerUUID()
	capturedTarget := passdomain.Target(-1)
	capturedValue := ""

	userRepo := &serverUsersRepoMock{}
	sessionsRepo := &serverSessionsRepoMock{
		isExistsFn: func(context.Context, string) (bool, error) { return true, nil },
		getInfoFn: func(context.Context, string) (*sessionsdomain.Session, error) {
			return &sessionsdomain.Session{ID: sessionID, Hash: "device-hash", Expires: time.Now().Add(time.Hour)}, nil
		},
		getOwnerFn: func(context.Context, string) (*domain.UUID, error) { return &userID, nil },
	}
	passRepo := &serverPassRepoMock{
		getOwnerFn: func(context.Context, domain.UUID) (*domain.UUID, error) { return &userID, nil },
		updateFn: func(_ context.Context, id domain.UUID, update passdomain.Target, value string, salt string) (*passdomain.Password, error) {
			capturedTarget = update
			capturedValue = value
			return &passdomain.Password{
				ID:       id,
				Service:  passdomain.ParseService("example.com"),
				Login:    "new-login",
				Password: "encrypted",
				Created:  time.Now().UTC(),
			}, nil
		},
	}

	usrService := usersapp.NewUserService(userRepo)
	sesService := sessionsapp.NewSessionService(sessionsRepo)
	server := NewPasswordsService(passapp.NewPassService(passRepo), NewAuthentificator(sesService, usrService))

	login := "new-login"
	newPass := "new-pass"
	_, err := server.Update(newAuthContext("device-hash", sessionID), &passpb.UpdateRequest{
		Id:    targetID.String(),
		Login: &login,
		Pass:  &newPass,
		Salt:  "salt",
	})
	if err != nil {
		t.Fatalf("Update returned error: %v", err)
	}
	if capturedTarget != passdomain.LoginTarget || capturedValue != "new-login" {
		t.Fatalf("expected LoginTarget/new-login, got target=%v value=%q", capturedTarget, capturedValue)
	}
}

func TestPasswordsServiceDeleteRejectsInvalidID(t *testing.T) {
	userID := newServerUUID()
	sessionID := uuid.NewString()
	server := NewPasswordsService(
		passapp.NewPassService(&serverPassRepoMock{}),
		NewAuthentificator(
			sessionsapp.NewSessionService(&serverSessionsRepoMock{
				isExistsFn: func(context.Context, string) (bool, error) { return true, nil },
				getInfoFn: func(context.Context, string) (*sessionsdomain.Session, error) {
					return &sessionsdomain.Session{ID: sessionID, Hash: "device-hash", Expires: time.Now().Add(time.Hour)}, nil
				},
				getOwnerFn: func(context.Context, string) (*domain.UUID, error) { return &userID, nil },
			}),
			usersapp.NewUserService(&serverUsersRepoMock{}),
		),
	)

	_, err := server.Delete(newAuthContext("device-hash", sessionID), &typespb.RequestWithID{Id: "not-a-uuid"})
	if !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}
}

func TestStatsServiceByDateAndToday(t *testing.T) {
	userID := newServerUUID()
	sessionID := uuid.NewString()

	userRepo := &serverUsersRepoMock{
		isUserAdminFn: func(context.Context, domain.UUID) (bool, error) { return true, nil },
	}
	sessionsRepo := &serverSessionsRepoMock{
		isExistsFn: func(context.Context, string) (bool, error) { return true, nil },
		getInfoFn: func(context.Context, string) (*sessionsdomain.Session, error) {
			return &sessionsdomain.Session{ID: sessionID, Hash: "device-hash", Expires: time.Now().Add(time.Hour)}, nil
		},
		getOwnerFn: func(context.Context, string) (*domain.UUID, error) { return &userID, nil },
	}
	statsRepo := &serverStatsRepoMock{
		byDateFn: func(_ context.Context, _ statsdomain.TimeRange, viewSaved ...bool) (*statsdomain.Stats, error) {
			return &statsdomain.Stats{
				Services: map[string]int32{"LoginService/Authorize": 2},
				Activity: &statsdomain.ActivityStats{
					Users:    statsdomain.GraphPoints{},
					Register: statsdomain.GraphPoints{},
				},
				Selected: &statsdomain.PreferencesStats{
					Theme: map[string]int32{"black": 1},
					Lang:  map[string]int32{"en": 1},
					Crypt: map[string]int32{"sha-256": 1},
				},
				Latency: &statsdomain.Latency{P50: 12, P90: 20},
			}, nil
		},
		totalFn: func(context.Context) (*statsdomain.Total, error) {
			return &statsdomain.Total{Users: 1, Admins: 1, Passwords: 1, ActiveSessions: 1}, nil
		},
	}

	usrService := usersapp.NewUserService(userRepo)
	sesService := sessionsapp.NewSessionService(sessionsRepo)
	server := NewStatsService(statsapp.NewStatsService(statsRepo), NewAuthentificator(sesService, usrService))
	ctx := newAuthContext("device-hash", sessionID)

	byDate, err := server.ByDate(ctx, &statspb.ByDateRequest{Day: timestamppb.Now()})
	if err != nil {
		t.Fatalf("ByDate returned error: %v", err)
	}
	if byDate == nil || byDate.GetStats() == nil {
		t.Fatalf("unexpected ByDate response: %#v", byDate)
	}

	today, err := server.Today(ctx, &emptypb.Empty{})
	if err != nil {
		t.Fatalf("Today returned error: %v", err)
	}
	if today == nil || today.GetStats() == nil {
		t.Fatalf("unexpected Today response: %#v", today)
	}

	total, err := server.Total(ctx, &emptypb.Empty{})
	if err != nil {
		t.Fatalf("Total returned error: %v", err)
	}
	if total.GetUsers() != 1 {
		t.Fatalf("unexpected total payload: %#v", total)
	}
}

func TestMetaServiceServerInformationReturnsConfiguredMetadata(t *testing.T) {
	oldServerName := sharedmetadata.ServerName
	oldCommitHash := sharedmetadata.CommitHash
	oldBuildTime := sharedmetadata.BuildTime
	t.Cleanup(func() {
		sharedmetadata.ServerName = oldServerName
		sharedmetadata.CommitHash = oldCommitHash
		sharedmetadata.BuildTime = oldBuildTime
	})

	sharedmetadata.ServerName = "QA Node"
	sharedmetadata.CommitHash = "abc123"
	sharedmetadata.BuildTime = "2026-03-23T12:34:56Z"

	server := NewMetaService(metaapp.NewService(nil))
	resp, err := server.ServerInformation(context.Background(), &emptypb.Empty{})
	if err != nil {
		t.Fatalf("ServerInformation returned error: %v", err)
	}
	if resp.GetInfo().GetName() != "QA Node" {
		t.Fatalf("unexpected server name: %#v", resp.GetInfo())
	}
	if resp.GetInfo().GetCommitHash() != "abc123" {
		t.Fatalf("unexpected commit hash: %#v", resp.GetInfo())
	}
	if resp.GetInfo().GetBuildTime() == nil {
		t.Fatalf("expected build time to be set")
	}
}

func TestMetaServiceServerInformationRespectsRateLimit(t *testing.T) {
	limiter := ratelimitapp.NewService(&serverRateLimitRepoMock{
		allowFn: func(_ context.Context, bucket ratelimitdomain.Bucket, key string, rule ratelimitdomain.Rule) (bool, time.Duration, error) {
			if bucket != ratelimitdomain.MetaBucket {
				t.Fatalf("unexpected bucket: %v", bucket)
			}
			if key != "203.0.113.10" {
				t.Fatalf("unexpected key: %q", key)
			}
			return false, time.Minute, nil
		},
	}, ratelimitdomain.Rules{
		Meta: ratelimitdomain.Rule{Limit: 1, Window: time.Minute},
	})

	server := NewMetaService(metaapp.NewService(nil), limiter)
	ctx := metadata.NewIncomingContext(context.Background(), metadata.Pairs("x-real-ip", "203.0.113.10"))

	_, err := server.ServerInformation(ctx, &emptypb.Empty{})
	if !errors.Is(err, apperrors.ResourceExhausted) {
		t.Fatalf("expected rate limit error, got %v", err)
	}
}

func TestMetaServiceClientCompatibilityValidatesRequest(t *testing.T) {
	server := NewMetaService(metaapp.NewService(nil))

	_, err := server.ClientCompatibility(context.Background(), &metapb.CompatibilityRequest{})
	if !errors.Is(err, apperrors.InvalidArguments) {
		t.Fatalf("expected invalid arguments, got %v", err)
	}
}
