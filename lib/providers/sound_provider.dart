import 'package:flutter/material.dart';
import '../models/sound_card_model.dart';
import '../services/api_service.dart';

class SoundProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<SoundCard> _buttons = [];
  bool _isLoading = true;

  List<SoundCard> get buttons => _buttons;
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
