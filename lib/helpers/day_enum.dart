String stringifyEnum(enumerator) {
  var string = enumerator.toString();
  return string.split('.')[1];
}

enum WeekDays { mon, tue, wed, thu, fri, sat, sun }

List<String> get weekdays {
  List<String> tmp = List<String>();
  WeekDays.values.forEach((element) {
    tmp.add(stringifyEnum(element));
  });
  return tmp;
}

List<String> listOfDaysToStringList(List<WeekDays> list) {
  List<String> tmp = list.map((e) => stringifyEnum(e)).toList();
  print(tmp);
  return tmp;
}

final Map<String, bool> defaultDayMap = {
  stringifyEnum(WeekDays.mon): true,
  stringifyEnum(WeekDays.tue): true,
  stringifyEnum(WeekDays.wed): true,
  stringifyEnum(WeekDays.thu): true,
  stringifyEnum(WeekDays.fri): true,
  stringifyEnum(WeekDays.sat): true,
  stringifyEnum(WeekDays.sun): true,
};
