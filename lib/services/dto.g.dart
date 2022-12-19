// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReminderDTO _$CreateReminderDTOFromJson(Map<String, dynamic> json) =>
    CreateReminderDTO(
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: json['startDate'] as String?,
      startTime: json['startTime'] as String?,
      endDate: json['endDate'] as String?,
      endTime: json['endTime'] as String?,
    );

Map<String, dynamic> _$CreateReminderDTOToJson(CreateReminderDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'startDate': instance.startDate,
      'startTime': instance.startTime,
      'endDate': instance.endDate,
      'endTime': instance.endTime,
    };
