import "package:freezed_annotation/freezed_annotation.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

part "weekly_schedule.g.dart";

@JsonSerializable()
class WeeklySchedule {
  List<WeekSchedule>? list;

  WeeklySchedule([this.list]);

  /// Connect the generated [_$WeeklyScheduleFromJson] function to the `fromJson` factory.
  factory WeeklySchedule.fromJson(Map<String, dynamic> json) => _$WeeklyScheduleFromJson(json);

  /// Connect the generated [_$WeeklyScheduleToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$WeeklyScheduleToJson(this);

  bool isDateIncluded(DateTime date) {
    if (isNullOrEmpty) return true;
    for (WeekSchedule entry in list!) {
      if (entry.isDayOfDateIncluded(date) && entry.timeFrame.isInRange(date)) {
        return true;
      }
    }
    return false;
  }

  bool isDateExcluded(DateTime date) {
    return !isDateIncluded(date);
  }

  bool containsScheduleWithSameTimeFrame(DayTimeFrame timeFrame) {
    if (isNullOrEmpty) return false;
    for (final entry in list!) {
      if (entry.timeFrame == timeFrame) {
        return true;
      }
    }
    return false;
  }

  void add(WeekSchedule weekSchedule) {
    list ??= [];
    WeekSchedule? inList = list!.firstWhereOrNull((element) => element.id == weekSchedule.id);
    if (inList == null) {
      list!.add(weekSchedule);
    }
  }

  void remove(String id) {
    if (list == null) return;
    list!.removeWhere((element) => element.id == id);
  }

  void update(WeekSchedule weekSchedule) {
    if (list == null) return;
    int index = list!.indexWhere((element) => element.id == weekSchedule.id);
    Debug.logWarning(index < 0, "Trying to update a WeekSchedule that does not exist");
    if (index >= 0) {
      list![index] = weekSchedule;
    }
  }

  bool get isNullOrEmpty => list == null || list!.isEmpty;

  bool get isNotEmpty => !isNullOrEmpty;

  int get length => isNullOrEmpty ? 0 : list!.length;

  WeekSchedule? elementAt(int index) => list?.elementAt(index);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WeeklySchedule) return false;

    List<WeekSchedule>? a = list;
    List<WeekSchedule>? b = other.list;

    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    if (identical(a, b)) {
      return true;
    }
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode {
    int hash = 0;
    if (list != null) {
      for (final element in list!) {
        hash ^= element.hashCode;
      }
    }
    return hash;
  }

  WeeklySchedule? copy() {
    return WeeklySchedule(list == null ? null : [...list!]);
  }

  DateTime getNextDateIncluded({required DateTime? date}) {
    date ??= DateTime.now();

    DateTime? foundDateTime;

    // Get the closest DateTime included in the WeekSchedule list to the given date
    if (list != null) {
      for (final WeekSchedule entry in list!) {
        DateTime? dateTime = entry.getNextDateIncluded(date: date);
        if (foundDateTime == null) {
          foundDateTime = dateTime;
        } else if (dateTime.isBefore(foundDateTime)) {
          foundDateTime = dateTime;
        }
      }
    }

    return foundDateTime ?? date;
  }
}
