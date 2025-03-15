import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:soz_alem/models/category_model.dart';
import '../models/sound_button.dart';
import '../services/api_service.dart';
import '../widgets/sound_button.dart';
import 'dart:async';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<SoundButton>> _buttonsFuture;
  List<SoundButton> _queue = [];
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingQueue = false;

  @override
  void initState() {
    super.initState();
    _buttonsFuture = ApiService().fetchButtonsByCategory(widget.category.id);
  }

  void _addToQueue(SoundButton button) {
    setState(() {
      _queue.add(button);
    });
  }

  void _clearQueue() {
    setState(() {
      _queue.clear();
    });
  }

  Future<void> _playQueue() async {
    if (_queue.isEmpty || _isPlayingQueue) return;

    setState(() {
      _isPlayingQueue = true;
    });

    for (var button in List.from(_queue)) {
      await _playSound(button);
    }

    setState(() {
      _isPlayingQueue = false;
    });
  }

  Future<void> _playSound(SoundButton button) async {
    Completer<void> completer = Completer<void>();

    _audioPlayer.play(UrlSource(button.audio));
    _audioPlayer.onPlayerComplete.first.then((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    await completer.future;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final crossAxisCount = isPortrait ? 2 : 5;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getCategoryTitle(widget.category.id)), // Dynamic title
        actions: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: _playQueue,
            tooltip: "Играть очередь",
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearQueue,
            tooltip: "Очистить очередь",
          ),
        ],
      ),
      body: FutureBuilder<List<SoundButton>>(
        future: _buttonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Нет звуков в этой категории"));
          }

          List<SoundButton> soundButtons = snapshot.data!;

          return Column(
            children: [
              if (_queue.isNotEmpty)
                Container(
                  height: 100,
                  padding: EdgeInsets.all(8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _queue.map((btn) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Chip(label: Text(btn.title)),
                      );
                    }).toList(),
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8, // Adjusted for images
                  ),
                  itemCount: soundButtons.length,
                  itemBuilder: (context, index) {
                    return SoundButtonWidget(
                      button: soundButtons[index],
                      onAddToQueue: () => _addToQueue(soundButtons[index]),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // **Switch-Case Function for Dynamic AppBar Title**
  String _getCategoryTitle(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'Еда';
      case 2:
        return 'Одежда';
      case 3:
        return 'Транспорт';
      case 4:
        return 'Животные';
      case 5:
        return 'Мебель';
      case 7:
        return 'Канцелярия';
      case 8:
        return 'Звёзды';
      case 10:
        return 'Деятельность';
      case 11:
        return 'Места';
      case 12:
        return 'Эмоции';
      case 13:
        return 'Боль';
      case 14:
        return 'Вещи';
      default:
        return widget.category.name; // Use original category name if no match
    }
  }
}
