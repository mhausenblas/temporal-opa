package play

ts_reference := time.parse_rfc3339_ns("2020-04-01T12:00:00Z")

time_window_check[results] {
  some i
  msg := input[i].msg
  ts := time.parse_rfc3339_ns(input[i].timestamp)
  results := {
    "same_year" : same_year(ts),
    "within_a_week" : within_a_week(ts),
    "message": msg,
  }
}

same_year(ts) {
  [c_y, c_m, c_d] := time.date(ts_reference)
  [ts_y, ts_m, ts_d] := time.date(ts)
  ts_y == c_y
}

within_a_week(ts) {
  a_week := 60 * 60 * 24 * 7
  diff := ts_reference/1000/1000/1000 - ts/1000/1000/1000
  diff < a_week
  ts_reference > ts
}
