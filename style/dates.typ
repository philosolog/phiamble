// Date-only values need no zone. Timed values require an explicit UTC offset.
// Typst does not resolve IANA daylight-saving rules; supply the offset for this date.
#let deadline(month: none, day: none, year: auto, hour: none, minute: 0, second: 0,
  timezone: "America/Los_Angeles", utc-offset-minutes: auto) = {
  let year = if year == auto { datetime.today(offset: -8).year() } else { year }
  let date = datetime(year: year, month: month, day: day)
  if hour == none { return date }
  let local = datetime(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
  let offset = utc-offset-minutes
  if offset == auto {
    assert(timezone == "America/Los_Angeles", message: "Other timezones require utc-offset-minutes")
    assert(year >= 2007, message: "Before 2007, supply utc-offset-minutes explicitly")
    // US rules since 2007: second Sunday in March, first Sunday in November.
    let sunday(month) = {
      let first = datetime(year: year, month: month, day: 1).weekday()
      1 + calc.rem(7 - first, 7)
    }
    let march = sunday(3) + 7
    let november = sunday(11)
    assert(not (month == 3 and day == march and hour == 2),
      message: "This Los Angeles time does not exist during the spring clock change")
    assert(not (month == 11 and day == november and hour == 1),
      message: "Repeated Los Angeles hour: specify utc-offset-minutes (-420 or -480)")
    let summer = (month > 3 and month < 11) or (
      month == 3 and (day > march or (day == march and hour >= 3))
    ) or (month == 11 and (day < november or (day == november and hour < 1)))
    offset = if summer { -420 } else { -480 }
  }
  (local: local, timezone: timezone, utc-offset-minutes: offset)
}

#let format_date(value, field: "date") = {
  if value == none { return none }
  let timed = type(value) == dictionary
  assert(type(value) == datetime or timed,
    message: field + " must be a date-only datetime or (local: datetime(...), timezone: ..., utc-offset-minutes: ...); strings are no longer supported")
  let local = if timed { value.at("local") } else { value }
  assert(type(local) == datetime and local.year() != none,
    message: field + " requires a calendar date")
  let day = local.display("[month repr:long] [day padding:none], [year]")
  if not timed {
    assert(local.hour() == none, message: field + " with a time requires timezone and utc-offset-minutes")
    return day
  }
  assert(local.hour() != none, message: field + " timed record requires a time")
  let zone = value.at("timezone")
  let offset = value.at("utc-offset-minutes")
  assert(type(zone) == str and zone.len() > 0, message: "timezone must be a nonempty IANA zone name")
  assert(type(offset) == int and offset >= -720 and offset <= 840,
    message: "utc-offset-minutes must be an integer between -720 and 840")
  let pad(n) = if n < 10 { "0" + str(n) } else { str(n) }
  let hour = local.hour()
  let clock = str(if calc.rem(hour, 12) == 0 { 12 } else { calc.rem(hour, 12) }) + ":" + pad(local.minute())
  if local.second() != 0 { clock += ":" + pad(local.second()) }
  day + ", " + clock + (if hour < 12 { " a.m." } else { " p.m." })
}
