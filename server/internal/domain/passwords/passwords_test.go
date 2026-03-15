package passdomain

import (
	"testing"
	"time"

	"github.com/aesterial/secureguard/internal/domain"
	"github.com/google/uuid"
)

func newPasswordUUID() domain.UUID {
	return domain.ParseUUID(uuid.New())
}

func TestParseServiceExtractsHostAndName(t *testing.T) {
	cases := []struct {
		input   string
		wantURL string
		want    string
	}{
		{input: "https://www.GitHub.com/login", wantURL: "github.com", want: "github"},
		{input: "mail.google.com", wantURL: "mail.google.com", want: "mail"},
		{input: "local-service", wantURL: "", want: "local-service"},
	}

	for _, tc := range cases {
		t.Run(tc.input, func(t *testing.T) {
			got := ParseService(tc.input).Protobuf()
			if got.Url != tc.wantURL || got.Name != tc.want {
				t.Fatalf("unexpected parse result: %#v", got)
			}
		})
	}
}

func TestPasswordsProtobuf(t *testing.T) {
	createdAt := time.Unix(1700000000, 0).UTC()
	entry := &Password{
		ID:       newPasswordUUID(),
		Service:  ParseService("example.com"),
		Login:    "login",
		Password: "encrypted",
		Created:  createdAt,
	}

	result := Passwords{entry}.Protobuf()
	if len(result) != 1 {
		t.Fatalf("expected one protobuf item, got %d", len(result))
	}
	if result[0].GetServ().GetName() != "example" {
		t.Fatalf("unexpected service name: %q", result[0].GetServ().GetName())
	}
	if !result[0].GetCreatedAt().AsTime().Equal(createdAt) {
		t.Fatalf("unexpected created timestamp")
	}
}
