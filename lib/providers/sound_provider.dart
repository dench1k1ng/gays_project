import 'package:flutter/material.dart';
import '../models/sound_button.dart';
import '../services/api_service.dart';

class SoundProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<SoundButton> _buttons = [];
  bool _isLoading = true;

  List<SoundButton> get buttons => _buttons;
  bool get isLoading => _isLoading;

  Future<void> fetchButtons() async {
    try {
      _isLoading = true;
      notifyListeners();
      _buttons = await _apiService.fetchButtons();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
