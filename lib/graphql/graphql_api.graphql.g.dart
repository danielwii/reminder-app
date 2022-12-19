// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoadMyReminders$Query$MixedReminder
    _$LoadMyReminders$Query$MixedReminderFromJson(Map<String, dynamic> json) =>
        LoadMyReminders$Query$MixedReminder()
          ..$$typename = json['__typename'] as String?
          ..origin = MixedReminderFragmentMixin$Reminder.fromJson(
              json['origin'] as Map<String, dynamic>);

Map<String, dynamic> _$LoadMyReminders$Query$MixedReminderToJson(
        LoadMyReminders$Query$MixedReminder instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'origin': instance.origin.toJson(),
    };

LoadMyReminders$Query _$LoadMyReminders$QueryFromJson(
        Map<String, dynamic> json) =>
    LoadMyReminders$Query()
      ..myReminders = (json['my_reminders'] as List<dynamic>)
          .map((e) => LoadMyReminders$Query$MixedReminder.fromJson(
              e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$LoadMyReminders$QueryToJson(
        LoadMyReminders$Query instance) =>
    <String, dynamic>{
      'my_reminders': instance.myReminders.map((e) => e.toJson()).toList(),
    };

MixedReminderFragmentMixin$Reminder
    _$MixedReminderFragmentMixin$ReminderFromJson(Map<String, dynamic> json) =>
        MixedReminderFragmentMixin$Reminder()
          ..$$typename = json['__typename'] as String?
          ..id = json['id'] as String
          ..name = json['name'] as String
          ..description = json['description'] as String?
          ..startDate = fromGraphQLDateTimeNullableToDartDateTimeNullable(
              json['startDate'] as int?)
          ..startTime = json['startTime'] as String?;

Map<String, dynamic> _$MixedReminderFragmentMixin$ReminderToJson(
        MixedReminderFragmentMixin$Reminder instance) =>
    <String, dynamic>{
      '__typename': instance.$$typename,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'startDate':
          fromDartDateTimeNullableToGraphQLDateTimeNullable(instance.startDate),
      'startTime': instance.startTime,
    };
