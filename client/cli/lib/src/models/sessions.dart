import 'package:secureguard_cli/src/api/xyz/secureguard/v1/sessions/v1/domain.pb.dart'
    as $session;

class Session {
  final String id;
  final String hash;
  final RevokeInfo? revoke;
  final DateTime? created;
  final DateTime? expires;
  final DateTime? lastSeen;
  const Session({
    required this.id,
    required this.hash,
    required this.revoke,
    required this.created,
    required this.expires,
    required this.lastSeen,
  });

  static Session? tryFromProto($session.Session session) {
    if (!session.hasId() || !session.hasHash()) {
      return null;
    }

    return Session(
      id: session.id,
      hash: session.hash,
      revoke: session.hasRevoke() ? RevokeInfo.fromProto(session.revoke) : null,
      created: session.hasCreatedAt() ? session.createdAt.toDateTime() : null,
      expires: session.hasExpiresAt() ? session.expiresAt.toDateTime() : null,
      lastSeen: session.hasLastSeen() ? session.lastSeen.toDateTime() : null,
    );
  }

  factory Session.fromProto($session.Session session) {
    final mapped = tryFromProto(session);
    if (mapped == null) {
      throw StateError('Session payload is missing required identity fields');
    }
    return mapped;
  }
}

class RevokeInfo {
  final bool revoked;
  final DateTime? at;
  const RevokeInfo({required this.revoked, required this.at});

  factory RevokeInfo.fromProto($session.Session_RevokeInfo revokeInfo) {
    return RevokeInfo(
      revoked: revokeInfo.revoked,
      at: revokeInfo.hasRevokedAt() ? revokeInfo.revokedAt.toDateTime() : null,
    );
  }
}
