import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../graphql/graphql_api.dart';
import '../helpers/func.dart';

final myRemindersProvider = FutureProvider<LoadMyReminders$Query?>(
    (_) => Func.ins.fetcher.loadMyReminders());
