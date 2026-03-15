package statsdomain

import (
	"math"
	"sort"
	"time"

	statspb "github.com/aesterial/secureguard/internal/api/v1/stats/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type Latency struct {
	P50 float64
	P90 float64
}

func percentile(sorted []float32, p float64) float64 {
	n := len(sorted)
	if n == 0 {
		return 0
	}

	idx := int(math.Ceil(p*float64(n))) - 1
	if idx < 0 {
		idx = 0
	}
	if idx >= n {
		idx = n - 1
	}

	return float64(sorted[idx])
}

func NewLatency(list []float32) Latency {
	n := len(list)
	if n == 0 {
		return Latency{}
	}

	sorted := append([]float32(nil), list...)
	sort.Slice(sorted, func(i, j int) bool {
		return sorted[i] < sorted[j]
	})

	return Latency{
		P50: percentile(sorted, 0.50),
		P90: percentile(sorted, 0.90),
	}
}

func (l *Latency) Protobuf() *statspb.Latency {
	if l == nil {
		return nil
	}
	return &statspb.Latency{
		P50: l.P50,
		P90: l.P90,
	}
}

type GraphPoint struct {
	At    time.Time
	Value int32
}

func (g *GraphPoint) Protobuf() *statspb.GraphPoint {
	if g == nil {
		return nil
	}
	return &statspb.GraphPoint{
		Time:  timestamppb.New(g.At),
		Value: g.Value,
	}
}

type GraphPoints []*GraphPoint

func (g GraphPoints) Protobuf() []*statspb.GraphPoint {
	var list = make([]*statspb.GraphPoint, len(g))
	for i, e := range g {
		list[i] = e.Protobuf()
	}
	return list
}

type Total struct {
	Users          int32
	Admins         int32
	Passwords      int32
	ActiveSessions int32
}

func (t *Total) Protobuf() *statspb.TotalResponse {
	if t == nil {
		return nil
	}
	return &statspb.TotalResponse{
		Users:          t.Users,
		Admins:         t.Admins,
		Passwords:      t.Passwords,
		ActiveSessions: t.ActiveSessions,
	}
}

type ServicesTop map[string]int32

type Stats struct {
	Services ServicesTop
	Activity *ActivityStats
	Selected *PreferencesStats
	Latency  *Latency
}

func (s *Stats) Protobuf() *statspb.Stats {
	return &statspb.Stats{
		TopServices:   s.Services,
		UsersGraph:    s.Activity.Users.Protobuf(),
		RegisterGraph: s.Activity.Register.Protobuf(),
		LangUses:      s.Selected.Lang,
		CryptUses:     s.Selected.Crypt,
		ThemeUses:     s.Selected.Theme,
		Latency:       s.Latency.Protobuf(),
	}
}

type TimeRange struct {
	Start time.Time
	End   time.Time
}

func NewTimeRange(at time.Time) TimeRange {
	startOfDay := time.Date(at.Year(), at.Month(), at.Day(), 0, 0, 0, 0, at.Location())
	endOfDay := startOfDay.AddDate(0, 0, 1)
	return TimeRange{
		Start: startOfDay,
		End:   endOfDay,
	}
}

func (t TimeRange) IsZero() bool {
	return t.Start.IsZero() || t.End.IsZero()
}

type PreferencesStats struct {
	Theme map[string]int32
	Lang  map[string]int32
	Crypt map[string]int32
}

type ActivityStats struct {
	Users    GraphPoints
	Register GraphPoints
}
