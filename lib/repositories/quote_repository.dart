import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/quote.dart';

class QuoteRepository {
  final Dio _dio = Dio();
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static const _apiKey = String.fromEnvironment('KALIMAT_API_KEY');
  static const _quoteKey = 'kalimat_daily_quote';
  static const _savedAtKey = 'kalimat_daily_quote_saved_at';

  Future<Quote> fetchTodayQuote() async {
    final savedJson = await _prefs.getString(_quoteKey);
    final savedAt = await _prefs.getInt(_savedAtKey);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (savedJson != null &&
        savedAt != null &&
        now - savedAt < const Duration(hours: 24).inMilliseconds) {
      return Quote.fromJson(jsonDecode(savedJson) as Map<String, dynamic>);
    }

    try {
      if (_apiKey.isEmpty) {
        throw StateError('مفتاح KalimatAPI غير موجود');
      }

      final response = await _dio.get(
        'https://kalimatapi.com/api/v1/quotes/today',
        queryParameters: {'token': _apiKey},
      );

      final body = response.data as Map<String, dynamic>;
      final quote = Quote.fromJson(body['data'] as Map<String, dynamic>);

      await _prefs.setString(_quoteKey, jsonEncode(quote.toJson()));
      await _prefs.setInt(_savedAtKey, now);

      return quote;
    } catch (error) {
      if (error is DioException) {
        debugPrint('Quote API status: ${error.response?.statusCode}');
      } else {
        debugPrint('Quote error: $error');
      }

      if (savedJson != null) {
        return Quote.fromJson(jsonDecode(savedJson) as Map<String, dynamic>);
      }

      rethrow;
    }
  }
}
