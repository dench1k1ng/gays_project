import 'package:dio/dio.dart';
import '../models/sound_card_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<SoundCard>> fetchButtons() async {
    final response = await _dio.get('https://example.com/api/buttons');

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((json) => SoundCard.fromJson(json)).toList();
    } else {
      throw Exception("Ошибка загрузки данных");
    }
  }
}
