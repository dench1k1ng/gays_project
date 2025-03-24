import 'package:dio/dio.dart';
import 'package:soz_alem/models/category_model.dart';
import 'dart:developer';
import '../models/sound_button.dart';

class ApiService {
  final Dio _dio = Dio();
  List<SoundButton> _cachedButtons = []; // Cache to avoid multiple API calls

  // ✅ Fetch all sound buttons
  Future<List<SoundButton>> fetchButtons() async {
    try {
      log("⏳ Fetching all sound buttons...");
      final response = await _dio.get('http://10.0.2.2:8000/api/cards/');

      log("✅ API Response: ${response.statusCode}");
      log("📄 Data: ${response.data}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        _cachedButtons =
            data.map((json) => SoundButton.fromJson(json)).toList();
        print(data);
        return _cachedButtons;
      } else {
        throw Exception("Ошибка загрузки данных. Код: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Ошибка запроса: $e");
      throw Exception("Ошибка подключения: $e");
    }
  }

  // ✅ Generate categories dynamically by watching `categoryId`
  Future<List<Category>> fetchCategoriesFromButtons() async {
    await fetchButtons(); // Ensure we have data

    Set<int> categoryIds =
        _cachedButtons.map((button) => button.categoryId).toSet();
    List<Category> categories = categoryIds
        .map((id) => Category(
            id: id, name: "Category $id")) // Generate names dynamically
        .toList();

    return categories;
  }

  // ✅ Fetch sound buttons by category
  Future<List<SoundButton>> fetchButtonsByCategory(int categoryId) async {
    if (_cachedButtons.isEmpty) {
      await fetchButtons(); // Ensure data is loaded
    }
    return _cachedButtons
        .where((button) => button.categoryId == categoryId)
        .toList();
  }

  // ✅ Update sound button
  Future<void> updateCard(
      int id, String title, String audio, String image) async {
    try {
      log("⏳ Updating sound button $id...");

      final response = await _dio.put(
        'http://10.0.2.2:8000/api/cards/$id/',
        data: {
          "title": title,
          "audio": audio,
          "image": image,
        },
      );

      if (response.statusCode == 200) {
        log("✅ Sound button $id successfully updated");
      } else {
        log("⚠️ Error updating sound button $id: ${response.statusCode}");
      }
    } catch (e) {
      log("❌ Error updating sound button $id: $e");
    }
  }
}
