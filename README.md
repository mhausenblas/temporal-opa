# Temporal reasoning with OPA

OPA's Rego has a number of built-in functions, ranging from string manipulation to cryptographic helpers to [time-related](https://www.openpolicyagent.org/docs/latest/policy-reference/#time) functions. In the following we will have a look how to do temporal reasoning with OPA, useful for all kinds of telemetry use cases, such as logging and metrics, as well as as security audits and more.

## Basics

Let's assume we have input data in the following form:

```json
    ...
    {
        "msg": "...",
        "timestamp": "YYY-MM-DDThh:mm:ssZ"
    }
    ...
```

That is, we're dealing with an array of timestamped entries. How can we check if a certain entry lies within a certain time window? For example, we want to filter for entries within the past week.

The basic idea is to convert the `timestamp` into a UNIX epoch represenation and diff it to the current timestamp:

```
valid_time_window(ts) = diff {
  now := time.now_ns()
  a_week := 60 * 60 * 24 * 7
  diff := now/1000/1000/1000 - ts/1000/1000/1000
  diff < a_week
  now > ts
}
```
    
Solution: https://play.openpolicyagent.org/p/GIzuIT0mDz

## Finding stuff in logs

Input: log, question: in what order did two events happen?

## Verifying access

Input: audit trail, question: has X been accessed out of business hour time?
