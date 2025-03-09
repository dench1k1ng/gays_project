import 'package:dio/dio.dart';
import 'dart:developer';
import '../models/sound_button.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<SoundButton>> fetchButtons() async {
    try {
      log("⏳ Отправка запроса к API...");
      final response = await _dio.get('http://10.0.2.2:8000/api/cards/');


      log("✅ Ответ от API: ${response.statusCode}");
      log("📄 Данные: ${response.data}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => SoundButton.fromJson(json)).toList();
      } else {
        throw Exception("Ошибка загрузки данных. Код: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Ошибка запроса: $e");
      throw Exception("Ошибка подключения: $e");
    }
  }
}