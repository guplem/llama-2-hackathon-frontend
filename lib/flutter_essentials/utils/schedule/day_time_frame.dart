import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "package:receptes_rostisseries_delgado/flutter_essentials/library.dart";

part "day_time_frame.g.dart";

@JsonSerializable()
class DayTimeFrame {
  @JsonKey(fromJson: TimeOfDayExtensions.jsonToItem, toJson: TimeOfDayExtensions.itemToJson)
  final TimeOfDay start;
  @JsonKey(fromJson: TimeOfDayExtensions.jsonToItem, toJson: TimeOfDayExtensions.itemToJson)
  final TimeOfDay end;

  final String d = "DAYTIME";

  const DayTimeFrame({required this.start, required this.end});

  factory DayTimeFrame.fromJson(Map<String, dynamic> json) => _$DayTimeFrameFromJson(json);

  Map<String, dynamic> toJson() => _$DayTimeFrameToJson(this);

  bool isInRange(DateTime date) {
    TimeOfDay dateTime = TimeOfDay.fromDateTime(date);
    return dateTime.isAfter(start) && dateTime.isBefore(end);
  }

  bool isBeforeStart(DateTime date) {
    TimeOfDay dateTime = TimeOfDay.fromDateTime(date);
    return dateTime.isBefore(start);
  }

  bool isAfterStart(DateTime date) {
    TimeOfDay dateTime = TimeOfDay.fromDateTime(date);
    return dateTime.isAfter(start);
  }

  bool isBeforeEnd(DateTime date) {
    TimeOfDay dateTime = TimeOfDay.fromDateTime(date);
    return dateTime.isBefore(end);
  }

  bool isAfterEnd(DateTime date) {
    TimeOfDay dateTime = TimeOfDay.fromDateTime(date);
    return dateTime.isAfter(end);
  }

  DayTimeFrame copyWith({TimeOfDay? start, TimeOfDay? end}) {
    return DayTimeFrame(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DayTimeFrame && runtimeType == other.runtimeType && start == other.start && end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
