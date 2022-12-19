import 'package:json_annotation/json_annotation.dart';

part 'dto.g.dart';

@JsonSerializable()
class CreateReminderDTO {
  final String name;
  final String? description;
  final String? startDate;
  final String? startTime;
  final String? endDate;
  final String? endTime;

  CreateReminderDTO({
    required this.name,
    this.description,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
  });

  factory CreateReminderDTO.fromJson(Map<String, dynamic> json) {
    return _$CreateReminderDTOFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CreateReminderDTOToJson(this);
}

class UpdateReminderDTO extends CreateReminderDTO {
  UpdateReminderDTO({
    required super.name,
    super.description,
    super.startDate,
    super.startTime,
    super.endDate,
    super.endTime,
  });
}
