import 'package:asuna_flutter/asuna_flutter.dart';
import 'package:graphql/client.dart';
import 'package:reminder/graphql/graphql_api.dart';

class GraphQLFetcher extends AsunaGraphQLFetcher with GraphQLProcessor {
  static final ins = GraphQLFetcher._();

  GraphQLFetcher._();

  Future<LoadMyReminders$Query?> loadMyReminders() => process(
      query: (variables) => LoadMyRemindersQuery(),
      parser: (json) => LoadMyReminders$Query.fromJson(json),
      fetchPolicy: FetchPolicy.networkOnly);
}
