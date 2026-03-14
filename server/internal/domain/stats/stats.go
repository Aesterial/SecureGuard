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

func NewLatency(list []float32) Latency {
	n := len(list)
	if n == 0 {
		return Latency{}
	}
	sort.Slice(list, func(i, j int) bool {
		return list[i] < list[j]
	})
	return Latency{
		P50: math.Ceil(0.5*float64(len(list)) - 1),
		P90: math.Ceil(0.9*float64(len(list)) - 1),
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

type CryptUses map[string]int32
type ServicesTop map[string]int32

type Stats struct {
	Services ServicesTop
	Activity GraphPoints
	Register GraphPoints
	Crypt    CryptUses
	Latency  Latency
}

func (s *Stats) Protobuf() *statspb.StatsResponse {
	return &statspb.StatsResponse{
		TopServices:   s.Services,
		ActivityGraph: s.Activity.Protobuf(),
		RegisterGraph: s.Register.Protobuf(),
		Crypt:         s.Crypt,
		Latency:       s.Latency.Protobuf(),
	}
}

type TimeRange struct {
	Start time.Time
	End   time.Time
}

func NewTimeRange(at time.Time) TimeRange {
	now := time.Now()
	startOfDay := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
	endOfDay := startOfDay.AddDate(0, 0, 1)
	return TimeRange{
		Start: startOfDay,
		End:   endOfDay,
	}
}

func (t TimeRange) IsZero() bool {
	return t.Start.IsZero() || t.End.IsZero()
}
