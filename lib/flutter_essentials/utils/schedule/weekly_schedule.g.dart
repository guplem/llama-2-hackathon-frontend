// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklySchedule _$WeeklyScheduleFromJson(Map<String, dynamic> json) =>
    WeeklySchedule(
      (json['list'] as List<dynamic>?)
          ?.map((e) => WeekSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeeklyScheduleToJson(WeeklySchedule instance) =>
    <String, dynamic>{
      'list': instance.list?.map((e) => e.toJson()).toList(),
    };
