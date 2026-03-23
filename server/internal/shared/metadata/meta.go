package metadata

import (
	"runtime"
	"time"
)

var (
	BuildTime         string
	GoVersion         string = runtime.Version()
	CommitHash        string
	SupportedVersions []float32 = []float32{1.0}
	ServerName        string    = "SecureGuard Server"
)

const (
	Repository      string  = "https://github.com/aesterial/secureguard"
	ApiMajorVersion float32 = 1.0
	ServerVersion   string  = "1.1.1"
)

func BuildTimestamp() time.Time {
	for _, layout := range []string{time.RFC3339Nano, time.RFC3339} {
		if ts, err := time.Parse(layout, BuildTime); err == nil {
			return ts.UTC()
		}
	}
	return time.Time{}
}
