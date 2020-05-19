# Temporal reasoning with OPA

OPA's Rego has a number of built-in functions, ranging from string manipulation to cryptographic helpers to [time-related](https://www.openpolicyagent.org/docs/latest/policy-reference/#time) functions. In the following we will have a look how to do temporal reasoning with OPA, useful for all kinds of telemetry use cases, such as logging and metrics, as well as as security audits and more.

## Basics

To get a timestamp of the current time and date in [UNIX Epoch format](https://en.wikipedia.org/wiki/Unix_time) (ns resolution), do:

```
now := time.now_ns()
# now is something like 1589025600000000000 
```

To parse a timestamp in [RFC 3339](https://tools.ietf.org/html/rfc3339) format into an UNIX Epoch timestamp, do:

```
ts := time.parse_rfc3339_ns("2020-04-03T02:01:00Z")
#  ts == 1585879260000000000
```

To get year, month, and day from an UNIX Epoch timestamp, do:

```
[year, month, day] := time.date(ts)
# year == 2020 , month == 4, day == 3
```

To get hour, minute, and second from an UNIX Epoch timestamp, do:

```
[hour, minute, second]:= time.clock(ts)
# hour== 2, minute == 1, second == 0
```

To get the weekday from an UNIX Epoch timestamp, do:

```
wday := time.weekday(ts)
# wday == "Friday"
```

To add year/month/day to an UNIX Epoch timestamp, do:

```
y := 0
m := 1
d := 0
one_month_in_the_future := time.add_date(ts, y, m, d)
# one_month_in_the_future == 1588471260000000000
```

The result of `time.add_date()` is an UNIX Epoch timestamp. If you want to convert it into an RFC 3339 formatted string, you can use a function like the following:

```
epoch2rfc3339(ts) = res {
  [Y, M, D] := time.date(ts)
  [h, m, s]:= time.clock(ts)
  res := sprintf("%d-%02d-%02dT%02d:%02d:%02dZ", [Y, M, D, h, m, s])
}
```

If you want to play around with the above basics yourself, you can use the [Rego Playground](https://play.openpolicyagent.org/p/UifwXAlfy2) containing the [rules](basics.rego).

## Validating time window

Let's assume we have input data in the following form:

```json
    ...
    {
        "msg": "...",
        "timestamp": "YYY-MM-DDThh:mm:ssZ"
    }
    ...
```

That is, we're dealing with an array of timestamped entries. How can we check if a certain entry lies within a certain time window? 

For example, we want to filter for entries within the past week. The basic idea is to convert the `timestamp` into a UNIX epoch represenation and diff it to the current timestamp:

```
within_a_week(ts) {
  now := time.now_ns()
  a_week := 60 * 60 * 24 * 7
  diff := now/1000/1000/1000 - ts/1000/1000/1000
  diff < a_week
  now > ts
}
```

Note, above, that we're not only checking if the timestamp provided is within seven days (`diff < a_week`) but also if it is in the past (`now > ts`), otherwise values within seven days into the future would also be valid.

If you want to play around with the above  yourself, you can use the [Rego Playground](https://play.openpolicyagent.org/p/6v2EfFSq3l) containing the [rules](timewindow.rego).


## Event ordering in logs and metrics

In this section we assume we have some sort of structured logs or metrics as an input and want to figure out in what order certain events happened? For example, `before`/`after` or if a time span is given, are they overlapping or not.

## Access auditing

In after-the-fact scenarios it's often necessary to verify when a certain event happened. For example, a question could be: has X been accessed out of business hour time?
