// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart = 2.12

import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
import '../coercers.dart';
part 'graphql_api.graphql.g.dart';

mixin MixedReminderFragmentMixin {
  @JsonKey(name: '__typename')
  String? $$typename;
  late MixedReminderFragmentMixin$Reminder origin;
}
mixin ReminderFragmentMixin {
  @JsonKey(name: '__typename')
  String? $$typename;
  late String id;
  late String name;
  String? description;
  @JsonKey(
      fromJson: fromGraphQLDateTimeNullableToDartDateTimeNullable,
      toJson: fromDartDateTimeNullableToGraphQLDateTimeNullable)
  DateTime? startDate;
  String? startTime;
}

@JsonSerializable(explicitToJson: true)
class LoadMyReminders$Query$MixedReminder extends JsonSerializable
    with EquatableMixin, MixedReminderFragmentMixin {
  LoadMyReminders$Query$MixedReminder();

  factory LoadMyReminders$Query$MixedReminder.fromJson(
          Map<String, dynamic> json) =>
      _$LoadMyReminders$Query$MixedReminderFromJson(json);

  @override
  List<Object?> get props => [$$typename, origin];
  @override
  Map<String, dynamic> toJson() =>
      _$LoadMyReminders$Query$MixedReminderToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LoadMyReminders$Query extends JsonSerializable with EquatableMixin {
  LoadMyReminders$Query();

  factory LoadMyReminders$Query.fromJson(Map<String, dynamic> json) =>
      _$LoadMyReminders$QueryFromJson(json);

  @JsonKey(name: 'my_reminders')
  late List<LoadMyReminders$Query$MixedReminder> myReminders;

  @override
  List<Object?> get props => [myReminders];
  @override
  Map<String, dynamic> toJson() => _$LoadMyReminders$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MixedReminderFragmentMixin$Reminder extends JsonSerializable
    with EquatableMixin, ReminderFragmentMixin {
  MixedReminderFragmentMixin$Reminder();

  factory MixedReminderFragmentMixin$Reminder.fromJson(
          Map<String, dynamic> json) =>
      _$MixedReminderFragmentMixin$ReminderFromJson(json);

  @override
  List<Object?> get props =>
      [$$typename, id, name, description, startDate, startTime];
  @override
  Map<String, dynamic> toJson() =>
      _$MixedReminderFragmentMixin$ReminderToJson(this);
}

final LOAD_MY_REMINDERS_QUERY_DOCUMENT_OPERATION_NAME = 'loadMyReminders';
final LOAD_MY_REMINDERS_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'loadMyReminders'),
    variableDefinitions: [],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'my_reminders'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FragmentSpreadNode(
            name: NameNode(value: 'MixedReminderFragment'),
            directives: [],
          )
        ]),
      )
    ]),
  ),
  FragmentDefinitionNode(
    name: NameNode(value: 'MixedReminderFragment'),
    typeCondition: TypeConditionNode(
        on: NamedTypeNode(
      name: NameNode(value: 'MixedReminder'),
      isNonNull: false,
    )),
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'origin'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FragmentSpreadNode(
            name: NameNode(value: 'ReminderFragment'),
            directives: [],
          )
        ]),
      ),
    ]),
  ),
  FragmentDefinitionNode(
    name: NameNode(value: 'ReminderFragment'),
    typeCondition: TypeConditionNode(
        on: NamedTypeNode(
      name: NameNode(value: 'Reminder'),
      isNonNull: false,
    )),
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'id'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'name'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'description'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'startDate'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'startTime'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
]);

class LoadMyRemindersQuery
    extends GraphQLQuery<LoadMyReminders$Query, JsonSerializable> {
  LoadMyRemindersQuery();

  @override
  final DocumentNode document = LOAD_MY_REMINDERS_QUERY_DOCUMENT;

  @override
  final String operationName = LOAD_MY_REMINDERS_QUERY_DOCUMENT_OPERATION_NAME;

  @override
  List<Object?> get props => [document, operationName];
  @override
  LoadMyReminders$Query parse(Map<String, dynamic> json) =>
      LoadMyReminders$Query.fromJson(json);
}
