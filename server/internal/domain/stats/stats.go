package statsdomain

// import (
// 	"math"
// 	"sort"
// )

// type Latency struct {
// 	P50 float64
// 	P90 float64
// }

// func NewLatency(list []float32) Latency {
// 	sort.Slice(list, func(i, j int) bool {
// 		return list[i] < list[j]
// 	})
// 	return Latency{
// 		P50: math.Ceil(0.5*float64(len(list)) - 1),
// 		P90: math.Ceil(0.9*float64(len(list)) - 1),
// 	}
// }
