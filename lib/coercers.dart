import 'package:common_utils/common_utils.dart';

DateTime fromGraphQLDateTimeToDartDateTime(int ms) =>
    DateUtil.getDateTime(DateUtil.formatDateMs(ms))!;
DateTime? fromGraphQLDateTimeNullableToDartDateTimeNullable(int? ms) =>
    ms == null ? null : DateUtil.getDateTime(DateUtil.formatDateMs(ms))!;
String fromDartDateTimeToGraphQLDateTime(DateTime date) =>
    DateUtil.formatDate(date);
String? fromDartDateTimeNullableToGraphQLDateTimeNullable(DateTime? date) =>
    date == null ? null : DateUtil.formatDate(date);
