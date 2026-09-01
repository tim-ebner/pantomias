import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ImageShowHistoryRepository {
  ImageShowHistoryRepository({required SharedPreferences preferences})
    : _preferences = preferences;

  static const _showCountsKey = 'imageDeck.showCounts';

  final SharedPreferences _preferences;

  Map<String, int> loadShowCounts() {
    final raw = _preferences.getString(_showCountsKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  Future<void> recordShown(String promptId) async {
    final counts = loadShowCounts();
    counts[promptId] = (counts[promptId] ?? 0) + 1;
    await _preferences.setString(_showCountsKey, jsonEncode(counts));
  }
}
