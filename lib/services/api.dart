import 'package:asuna_flutter/asuna_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:retrofit/retrofit.dart';

import 'dto.dart';

part 'api.g.dart';

@RestApi()
abstract class ApiRestClient {
  factory ApiRestClient(Dio dio, {String baseUrl}) = _ApiRestClient;

  @POST('/api/v1/reminder')
  Future createReminder(@Body() CreateReminderDTO dto);

  @PUT('/api/v1/reminder/{id}')
  Future updateReminder(@Path() String id, @Body() UpdateReminderDTO dto);

  @PATCH('/api/v1/reminder/{id}')
  Future patchReminder(@Path() String id, @Body() UpdateReminderDTO dto);
}
