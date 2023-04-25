package store

import (
	"fmt"
	"sort"
	"strconv"
	"time"
)

// OnlineThreshold is a value used for uptime calculation.
const OnlineThreshold = time.Minute * 6

// UptimeResponse is the tracker API response format for `/uptimes`.
type UptimeResponse []UptimeDef

// UptimeDef is the item of `UptimeResponse`.
type UptimeDef struct {
	Key        string  `json:"key"`
	Uptime     float64 `json:"uptime"`
	Downtime   float64 `json:"downtime"`
	Percentage float64 `json:"percentage"`
	Online     bool    `json:"online"`
	Version    string  `json:"-"`
}

// UptimeResponseV2 is the tracker API response format v2 for `/uptimes`.
type UptimeResponseV2 []UptimeDefV2

// UptimeDefV2 is the item of `UptimeResponseV2`.
type UptimeDefV2 struct {
	Key                string            `json:"pk"`
	Uptime             float64           `json:"up"`
	Downtime           float64           `json:"down"`
	Percentage         float64           `json:"pct"`
	Online             bool              `json:"on"`
	Version            string            `json:"version,omitempty"`
	DailyOnlineHistory map[string]string `json:"daily,omitempty"`
}

func makeUptimeResponse(uptimes []map[string]string, lastTS map[string]string, versions map[string]string, startYear int, startMonth time.Month, endYear int, endMonth time.Month, callingErr error) (UptimeResponse, error) {
	if callingErr != nil {
		return UptimeResponse{}, callingErr
	}

	if len(uptimes) == 0 {
		return UptimeResponse{}, nil
	}

	startDate := time.Date(startYear, startMonth, 1, 0, 0, 0, 0, time.Now().Location())
	endDate := time.Date(endYear, endMonth, 1, 0, 0, 0, 0, time.Now().Location()).AddDate(0, 1, 0)

	// take just complete seconds
	totalPeriodSeconds := float64(int(endDate.Sub(startDate).Seconds()))

	now := time.Now()
	currentYear := now.Year()
	currentMonth := now.Month()

	var ensureLimit bool
	var totalPeriodSecondsPassed float64
	if endYear == currentYear && endMonth == currentMonth {
		// interval ends with the current month, we'll need to ensure limits. All intervals which
		// ended before the current month are complete, but for the current month, we need to ensure
		// that uptime of the node is not more than the passed part of the month, i.e. uptime can't be
		// 16 days on the 15th of the month
		ensureLimit = true

		currentMonthStart := time.Date(currentYear, currentMonth, 1, 0, 0, 0, 0, now.Location())
		currentMonthEnd := currentMonthStart.AddDate(0, 1, 0)
		currentMonthTotalSeconds := float64(int(currentMonthEnd.Sub(currentMonthStart).Seconds()))

		// take just complete seconds
		partOfMonthPassed := float64(int(now.Sub(currentMonthStart).Seconds()))

		// initially `totalPeriodSeconds` contains full time interval including full current month,
		// so we need to subtract total month seconds and add time of the month which is actually
		// passed. And this is the hard cap for our uptimes, we can't overcome this boundary
		totalPeriodSecondsPassed = totalPeriodSeconds - currentMonthTotalSeconds + partOfMonthPassed
	}

	totalUptimes := make(map[string]int64, len(uptimes[0]))
	for _, monthUptimes := range uptimes {
		for pk, uptimeStr := range monthUptimes {
			uptime, err := strconv.ParseInt(uptimeStr, 10, 64)
			if err != nil {
				return nil, fmt.Errorf("error parsing uptime value for visor %s: %w", pk, err)
			}

			totalUptimes[pk] += uptime
		}
	}

	response := make(UptimeResponse, 0)
	for pk, uptime := range totalUptimes {
		uptime64 := float64(uptime)
		if ensureLimit && uptime64 > totalPeriodSecondsPassed {
			uptime64 = totalPeriodSecondsPassed
		}
		if !ensureLimit && uptime64 > totalPeriodSeconds {
			uptime64 = totalPeriodSeconds
		}

		percentage := uptime64 / totalPeriodSeconds * 100
		if percentage > 100 {
			percentage = 100
		}

		online := false
		ts, err := strconv.ParseInt(lastTS[pk], 10, 64)
		if err == nil {
			online = time.Unix(ts, 0).Add(OnlineThreshold).After(time.Now())
		}

		entry := UptimeDef{
			Key:        pk,
			Uptime:     uptime64,
			Downtime:   totalPeriodSeconds - uptime64,
			Percentage: percentage,
			Online:     online,
			Version:    versions[pk],
		}

		response = append(response, entry)
	}

	sort.Slice(response, func(i, j int) bool {
		for k := 0; k < 33; k++ {
			if response[i].Key[k] != response[j].Key[k] {
				return response[i].Key[k] < response[j].Key[k]
			}
		}
		return true
	})

	return response, nil
}
