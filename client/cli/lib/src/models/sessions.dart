import 'package:secureguard_cli/src/api/xyz/secureguard/v1/sessions/v1/domain.pb.dart' as $session;

class Session {
  final String id;
  final String hash;
  final RevokeInfo? revoke;
  final DateTime created;
  final DateTime expires;
  final DateTime? lastSeen;
  const Session({
    required this.id,
    required this.hash,
    required this.revoke,
    required this.created,
    required this.expires,
    required this.lastSeen
  });

  factory Session.fromProto($session.Session session) {
    return Session(
      id: session.id,
      hash: session.hash,
      revoke: RevokeInfo.fromProto(session.revoke),
      created: session.createdAt.toDateTime(),
      expires: session.expiresAt.toDateTime(),
      lastSeen: session.lastSeen.toDateTime()
    );
  }
}

class RevokeInfo {
  final bool revoked;
  final DateTime at;
  const RevokeInfo({required this.revoked, required this.at});

  factory RevokeInfo.fromProto($session.Session_RevokeInfo revokeInfo) {
    return RevokeInfo(
        revoked: revokeInfo.revoked,
        at: revokeInfo.revokedAt.toDateTime(),
    );
  }
}
