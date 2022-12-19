import 'package:asuna_flutter/services/func.dart';
import 'package:flutter/material.dart';
import 'package:flutter_buffs/helper/context.dart';
import 'package:intl/intl.dart';

import '../services/api.dart';
import '../services/dto.dart';
import '../services/graphql.dart';

final dateFormat = DateFormat('yyyy-MM-dd');
final timeFormat = DateFormat('HH:mm');

class Func {
  static final ins = Func._();

  late ApiRestClient rest;
  late GraphQLFetcher fetcher;

  Func._() : super() {
    rest = ApiRestClient(
      AsunaFunc.ins.api.dio,
      baseUrl: AppContext.connection.resolveUrl('/'),
    );
    fetcher = GraphQLFetcher.ins;
  }

  Future<dynamic> upsertReminder(
    BuildContext context, {
    String? id,
    required String name,
    String? description,
    DateTime? date,
    TimeOfDay? time,
  }) {
    final startTime = time != null
        ? MaterialLocalizations.of(context)
            .formatTimeOfDay(time, alwaysUse24HourFormat: true)
        : null;
    return id != null
        ? Func.ins.rest.updateReminder(
            id,
            UpdateReminderDTO(
              name: name.trim(),
              description: description?.trim(),
              startDate: date != null ? dateFormat.format(date) : null,
              startTime: startTime,
            ))
        : Func.ins.rest.createReminder(CreateReminderDTO(
            name: name.trim(),
            description: description?.trim(),
            startDate: date != null ? dateFormat.format(date) : null,
            startTime: startTime,
          ));
  }
}
