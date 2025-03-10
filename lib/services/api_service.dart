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

  // ✅ Метод для обновления карточки
  Future<void> updateCard(int id, String title, String audio, String image) async {
    try {
      log("⏳ Отправка PUT-запроса для обновления карточки $id...");

      final response = await _dio.put(
        'http://10.0.2.2:8000/api/cards/$id/',
        data: {
          "title": title,
          "audio": audio,
          "image": image,
        },
      );

      if (response.statusCode == 200) {
        log("✅ Карточка $id успешно обновлена");
      } else {
        log("⚠️ Ошибка обновления карточки $id: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Ошибка при обновлении карточки $id: $e");
    }
  }

}
