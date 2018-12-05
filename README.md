# strava_stats.sh

Simple script to fetch some Strava stats for the month.

## Dependencies

* curl
* jq
* units

## Example Usage

```
$ strava_stats.sh                      
Stats for 2018-12-01 through NOW
=======================================
Total Distance: 10.15 km
Fastest 1k:     04;49 per km
Fastest 5k:     04;49 per km
Fastest 10k:    04;49 per km
Fastest half:   00;00 per km
Fastest 25k:    00;00 per km
Fastest full:   00;00 per km

```

```
$ strava_stats.sh 2018-09-01 2018-09-30
Stats for 2018-09-01 through 2018-09-30
=======================================
Total Distance: 166.06 km
Fastest 1k:     05;02 per km
Fastest 5k:     05;02 per km
Fastest 10k:    05;02 per km
Fastest half:   05;32 per km
Fastest 25k:    00;00 per km
Fastest full:   00;00 per km
```

These samples are from a slacker. As such the longer distances show zero
values.
