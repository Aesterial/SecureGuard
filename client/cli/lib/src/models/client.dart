import 'package:secureguard_cli/src/utils/generator.dart';

class ClientStore {
  String? session;
  final String clientHash;

  bool get isAuthorized => session != null && session!.isNotEmpty;

  ClientStore() : clientHash = randomString(30);

  String getClientHash() => clientHash;
  String? getSession() => session;

  void set(String value) => session = value;
  void clear() => session = null;
}
