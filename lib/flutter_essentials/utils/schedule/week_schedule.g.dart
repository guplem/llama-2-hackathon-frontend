// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeekSchedule _$WeekScheduleFromJson(Map<String, dynamic> json) => WeekSchedule(
      DayTimeFrame.fromJson(json['timeFrame'] as Map<String, dynamic>),
      monday: json['monday'] as bool? ?? false,
      tuesday: json['tuesday'] as bool? ?? false,
      wednesday: json['wednesday'] as bool? ?? false,
      thursday: json['thursday'] as bool? ?? false,
      friday: json['friday'] as bool? ?? false,
      saturday: json['saturday'] as bool? ?? false,
      sunday: json['sunday'] as bool? ?? false,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$WeekScheduleToJson(WeekSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timeFrame': instance.timeFrame.toJson(),
      'monday': instance.monday,
      'tuesday': instance.tuesday,
      'wednesday': instance.wednesday,
      'thursday': instance.thursday,
      'friday': instance.friday,
      'saturday': instance.saturday,
      'sunday': instance.sunday,
    };
