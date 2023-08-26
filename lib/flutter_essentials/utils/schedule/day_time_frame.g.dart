// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_time_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayTimeFrame _$DayTimeFrameFromJson(Map<String, dynamic> json) => DayTimeFrame(
      start: TimeOfDayExtensions.jsonToItem(json['start'] as String),
      end: TimeOfDayExtensions.jsonToItem(json['end'] as String),
    );

Map<String, dynamic> _$DayTimeFrameToJson(DayTimeFrame instance) =>
    <String, dynamic>{
      'start': TimeOfDayExtensions.itemToJson(instance.start),
      'end': TimeOfDayExtensions.itemToJson(instance.end),
    };
