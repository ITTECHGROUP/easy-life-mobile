import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Email-marketing opt-in. The member's choice is written to Firestore `marketing_contacts`
/// (create/update only — members can't read the list; admins see it in the panel) and mirrored
/// locally so the app knows whether it already asked and what the member chose.
class MarketingService {
  static const _storage = FlutterSecureStorage();
  static const _kPrompted = 'marketing_prompted';
  static const _kEmail = 'marketing_email';
  static const _kConsent = 'marketing_consent';

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static bool isValidEmail(String v) => _emailPattern.hasMatch(v.trim()) && v.trim().length <= 254;

  static const _kDeviceId = 'marketing_device_id';

  /// Members use their account uuid; guests get a random id kept on the device, so later
  /// changes (e.g. unsubscribing) update the same record instead of creating a new one.
  static Future<String> _docId(Map user) async {
    final uuid = (user['uuid'] ?? '').toString();
    if (uuid.isNotEmpty) return uuid;
    if (user['id'] != null) return 'account-${user['id']}';
    var id = await _storage.read(key: _kDeviceId);
    if (id == null) {
      final r = Random.secure();
      id = 'guest-${List.generate(20, (_) => r.nextInt(36).toRadixString(36)).join()}';
      await _storage.write(key: _kDeviceId, value: id);
    }
    return id;
  }

  static Future<bool> wasPrompted() async => (await _storage.read(key: _kPrompted)) == 'yes';
  static Future<void> markPrompted() => _storage.write(key: _kPrompted, value: 'yes');
  static Future<String> savedEmail() async => await _storage.read(key: _kEmail) ?? '';
  static Future<bool> savedConsent() async => (await _storage.read(key: _kConsent)) == 'yes';

  static Future<void> save({required Map user, required String email, required bool consent}) async {
    final id = await _docId(user);
    final now = DateTime.now().millisecondsSinceEpoch;
    await FirebaseFirestore.instance.collection('marketing_contacts').doc(id).set({
      'email': email.trim().toLowerCase(),
      'username': (user['username'] ?? '').toString(),
      'accountId': user['id'] is int ? user['id'] : int.tryParse('${user['id']}') ?? 0,
      'consent': consent,
      'source': 'app',
      'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
      'updatedAt': now,
    });
    await _storage.write(key: _kEmail, value: email.trim().toLowerCase());
    await _storage.write(key: _kConsent, value: consent ? 'yes' : 'no');
    await markPrompted();
  }
}
