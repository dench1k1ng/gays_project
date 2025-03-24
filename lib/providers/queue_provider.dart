// lib/providers/queue_provider.dart
import 'package:flutter/material.dart';
import '../models/sound_button.dart';

class QueueProvider with ChangeNotifier {
  final List<SoundButton> _queue = [];

  List<SoundButton> get queue => _queue;

  void addToQueue(SoundButton button) {
    _queue.add(button);
    notifyListeners();
  }

  void removeFromQueue(SoundButton button) {
    _queue.remove(button);
    notifyListeners();
  }

  void clearQueue() {
    _queue.clear();
    notifyListeners();
  }
}
