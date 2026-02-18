import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_colors.dart';
import 'mock_data.dart';

class ContactStore {
  static const String _storageKey = 'payflow_saved_contacts_v1';
  static final ValueNotifier<int> changes = ValueNotifier<int>(0);
  static final List<Contact> _savedContacts = [];

  static List<Contact> get savedContacts =>
      List<Contact>.unmodifiable(_savedContacts);

  static bool isSavedContact(String name) {
    final normalized = name.trim().toLowerCase();
    return _savedContacts.any(
      (contact) => contact.name.trim().toLowerCase() == normalized,
    );
  }

  static Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_storageKey);

    _savedContacts
      ..clear()
      ..addAll(_decode(raw));
    changes.value = changes.value + 1;
  }

  static Future<void> addReceiverIfMissing({
    required String name,
    String? upiId,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return;
    }

    final normalized = trimmedName.toLowerCase();

    final existsInMock = MockData.contacts.any(
      (contact) => contact.name.trim().toLowerCase() == normalized,
    );
    final existsInSaved = _savedContacts.any(
      (contact) => contact.name.trim().toLowerCase() == normalized,
    );

    if (existsInMock || existsInSaved) {
      return;
    }

    _savedContacts.insert(
      0,
      Contact(
        name: trimmedName,
        upiId: upiId?.trim().isEmpty == true ? null : upiId?.trim(),
        gradient: AppColors.gradientRahul,
      ),
    );

    await _save();
    changes.value = changes.value + 1;
  }

  static Future<void> removeSavedContact(String name) async {
    final normalized = name.trim().toLowerCase();
    final before = _savedContacts.length;
    _savedContacts.removeWhere(
      (contact) => contact.name.trim().toLowerCase() == normalized,
    );

    if (_savedContacts.length == before) {
      return;
    }

    await _save();
    changes.value = changes.value + 1;
  }

  static Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    final payload = jsonEncode(
      _savedContacts
          .map(
            (contact) => {
              'name': contact.name,
              'upiId': contact.upiId,
            },
          )
          .toList(growable: false),
    );
    await preferences.setString(_storageKey, payload);
  }

  static List<Contact> _decode(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return [];
      }

      return decoded.whereType<Map>().map((item) {
        final map = item.map((key, value) => MapEntry(key.toString(), value));
        return Contact(
          name: (map['name'] as String?) ?? '',
          upiId: map['upiId'] as String?,
          gradient: AppColors.gradientRahul,
        );
      }).where((contact) => contact.name.trim().isNotEmpty).toList(growable: true);
    } catch (_) {
      return [];
    }
  }
}