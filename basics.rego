package play

ts_in_rfc3339 := "2020-04-03T02:01:00Z"
ts := time.parse_rfc3339_ns(ts_in_rfc3339)
now := time.now_ns()

adate = { "Y" : year, "M": month, "D": day } {  
  [year, month, day] := time.date(ts)
}

atime = { "h" : hour, "m": minute, "s": second } {
  [hour, minute, second]:= time.clock(ts)
}

aweekday := time.weekday(ts)


one_month_in_the_future = output {
  y := 0
  m := 1
  d := 0
  omif_ts := time.add_date(ts, y, m, d)
  output := epoch2rfc3339(omif_ts)
}

epoch2rfc3339(ts) = res {
  [Y, M, D] := time.date(ts)
  [h, m, s]:= time.clock(ts)
  res := sprintf("%d-%02d-%02dT%02d:%02d:%02dZ", [Y, M, D, h, m, s])
}
