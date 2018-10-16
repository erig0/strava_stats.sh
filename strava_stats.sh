#!/bin/sh
# SPDX-License-Identifier: MIT

CONFIG_FILE="${XDG_CONFIG_HOME:-${HOME}/.config}/strava_stats"
if [ ! -f "$CONFIG_FILE" ]; then
	echo "You need to set ATHLETE_ID and ACCESS_TOKEN in $CONFIG_FILE."
	echo "Obtain from https://www.strava.com/settings/api"
	exit 1
fi
. "$CONFIG_FILE"

TEMP_FILE=$(mktemp)
curl -s -X GET "https://www.strava.com/api/v3/athlete/activities?access_token=${ACCESS_TOKEN}&after=$(date -d $(date +%Y-%m-01T00:00:00Z) +%s)" -H "accept: application/json" > "$TEMP_FILE"

JQ_PACE_EXPR="try (min_by(.moving_time / (.distance / 1000)) | .moving_time / (.distance / 1000) | floor + 1) catch 0"

TOTAL_DISTANCE_KM=$(printf "%.2f" $(jq 'map(.distance) | add / 1000' "$TEMP_FILE"))
FASTEST_1K=$(units -t $(jq   "map(select(.type == \"Run\" and .distance >=  1000)) | ${JQ_PACE_EXPR}" ${TEMP_FILE})" seconds" "min;sec")
FASTEST_5K=$(units -t $(jq   "map(select(.type == \"Run\" and .distance >=  5000)) | ${JQ_PACE_EXPR}" ${TEMP_FILE})" seconds" "min;sec")
FASTEST_10K=$(units -t $(jq  "map(select(.type == \"Run\" and .distance >= 10000)) | ${JQ_PACE_EXPR}" ${TEMP_FILE})" seconds" "min;sec")
FASTEST_HALF=$(units -t $(jq "map(select(.type == \"Run\" and .distance >= 21097)) | ${JQ_PACE_EXPR}" ${TEMP_FILE})" seconds" "min;sec")
FASTEST_25K=$(units -t $(jq  "map(select(.type == \"Run\" and .distance >= 25000)) | ${JQ_PACE_EXPR}" ${TEMP_FILE})" seconds" "min;sec")
FASTEST_FULL=$(units -t $(jq "map(select(.type == \"Run\" and .distance >= 42195)) | ${JQ_PACE_EXPR}" ${TEMP_FILE})" seconds" "min;sec")

echo "Total Distance: ${TOTAL_DISTANCE_KM} km"
echo "Fastest 1k: ${FASTEST_1K} per km"
echo "Fastest 5k: ${FASTEST_5K} per km"
echo "Fastest 10k: ${FASTEST_10K} per km"
echo "Fastest half: ${FASTEST_HALF} per km"
echo "Fastest 25k: ${FASTEST_25K} per km"
echo "Fastest full: ${FASTEST_FULL} per km"

rm "$TEMP_FILE"
