import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";
import "package:uuid/uuid.dart";

part "week_schedule.g.dart";

@JsonSerializable()
class WeekSchedule {
  late final String id;
  final DayTimeFrame timeFrame;
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;

  WeekSchedule(
    this.timeFrame, {
    this.monday = false,
    this.tuesday = false,
    this.wednesday = false,
    this.thursday = false,
    this.friday = false,
    this.saturday = false,
    this.sunday = false,
    String? id,
  }) {
    if (id == null) {
      this.id = const Uuid().v1();
    } else {
      this.id = id;
    }
  }

  factory WeekSchedule.only(DayTimeFrame timeFrame, int i) => WeekSchedule(
        timeFrame,
        monday: i == 1,
        tuesday: i == 2,
        wednesday: i == 3,
        thursday: i == 4,
        friday: i == 5,
        saturday: i == 6,
        sunday: i == 7,
      );

  factory WeekSchedule.allDays(DayTimeFrame timeFrame) => WeekSchedule(
        timeFrame,
        monday: true,
        tuesday: true,
        wednesday: true,
        thursday: true,
        friday: true,
        saturday: true,
        sunday: true,
      );

  factory WeekSchedule.noDays(DayTimeFrame timeFrame) => WeekSchedule(
        timeFrame,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
      );

  factory WeekSchedule.weekdays(DayTimeFrame timeFrame) => WeekSchedule(
        timeFrame,
        monday: true,
        tuesday: true,
        wednesday: true,
        thursday: true,
        friday: true,
        saturday: false,
        sunday: false,
      );

  factory WeekSchedule.weekends(DayTimeFrame timeFrame) => WeekSchedule(
        timeFrame,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: true,
        sunday: true,
      );

  factory WeekSchedule.fromJson(Map<String, dynamic> json) => _$WeekScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$WeekScheduleToJson(this);

  bool isDayIncluded(int day) {
    switch (day) {
      case 1:
        return monday;
      case 2:
        return tuesday;
      case 3:
        return wednesday;
      case 4:
        return thursday;
      case 5:
        return friday;
      case 6:
        return saturday;
      case 7:
        return sunday;
      default:
        Debug.logWarning(true, "Unnexpected weekday number: $day");
        return false;
    }
  }

  bool isDayExcluded(int day) {
    return !isDayIncluded(day);
  }

  bool isDayOfDateIncluded(DateTime date) {
    return isDayIncluded(date.weekday);
  }

  bool isDayOfDateExcluded(DateTime date) {
    return !isDayOfDateIncluded(date);
  }

  WeekSchedule copyWith({
    DayTimeFrame? timeFrame,
    bool? monday,
    bool? tuesday,
    bool? wednesday,
    bool? thursday,
    bool? friday,
    bool? saturday,
    bool? sunday,
  }) {
    return WeekSchedule(
      id: id,
      timeFrame ?? this.timeFrame,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeekSchedule &&
        other.id == id &&
        other.timeFrame == timeFrame &&
        other.monday == monday &&
        other.tuesday == tuesday &&
        other.wednesday == wednesday &&
        other.thursday == thursday &&
        other.friday == friday &&
        other.saturday == saturday &&
        other.sunday == sunday;
  }

  @override
  int get hashCode {
    return id.hashCode ^ monday.hashCode ^ tuesday.hashCode ^ wednesday.hashCode ^ thursday.hashCode ^ friday.hashCode ^ saturday.hashCode ^ sunday.hashCode;
  }

  WeekSchedule getWithSwitchedDay(int tapped) {
    switch (tapped) {
      case 1:
        return copyWith(monday: !monday);
      case 2:
        return copyWith(tuesday: !tuesday);
      case 3:
        return copyWith(wednesday: !wednesday);
      case 4:
        return copyWith(thursday: !thursday);
      case 5:
        return copyWith(friday: !friday);
      case 6:
        return copyWith(saturday: !saturday);
      case 7:
        return copyWith(sunday: !sunday);
      default:
        return this;
    }
  }

  DateTime getNextDateIncluded({required DateTime? date}) {
    date ??= DateTime.now();

    DateTime? foundDateTime;

    for (int i = 0; i < 7; i++) {
      final DateTime nextDate = date.add(Duration(days: i));
      if (isDayOfDateIncluded(nextDate)) {
        if (i == 0 && timeFrame.start.isBefore(TimeOfDay.fromDateTime(date))) {
          foundDateTime = date;
        } else {
          foundDateTime = nextDate.copyWith(hour: timeFrame.start.hour, minute: timeFrame.start.minute, second: 0, millisecond: 0, microsecond: 0);
        }
        break;
      }
    }

    return foundDateTime ?? date;
  }
}
