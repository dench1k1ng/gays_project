import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:soz_alem/widgets/sound_button.dart';
import '../services/api_service.dart';
import '../models/sound_button.dart';
import 'settings_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<SoundButton>> _buttonsFuture;
  List<SoundButton> _queue = [];
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingQueue = false;

  @override
  void initState() {
    super.initState();
    _buttonsFuture = ApiService().fetchButtons();
  }

  void _addToQueue(SoundButton button) {
    setState(() {
      _queue.insert(0, button); // Добавляем в начало очереди
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

    for (int i = 0; i < _queue.length; i++) {
      await _playSound(_queue[i]);
    }

    setState(() {
      _isPlayingQueue = false;
    });
  }
  Future<void> _playSound(SoundButton button) async {
    Completer<void> completer = Completer<void>();

    _audioPlayer.play(UrlSource(button.audio));

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    await completer.future;
  }
  Future<void> _playNext(int index) async {
    if (index >= _queue.length) {
      setState(() {
        _isPlayingQueue = false;
      });
      return;
    }

    await _audioPlayer.play(UrlSource(_queue[index].audio));

    _audioPlayer.onPlayerComplete.listen((_) {
      _playNext(index + 1);
    });
  }


  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final crossAxisCount = isPortrait ? 2 : 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Soz Alem"),
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
      body: _selectedIndex == 0
          ? FutureBuilder<List<SoundButton>>(
        future: _buttonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Нет доступных кнопок"));
          }

          List<SoundButton> validButtons = snapshot.data!.where((btn) => btn.image.isNotEmpty).toList();

          if (validButtons.isEmpty) {
            return const Center(child: Text("Нет кнопок с изображениями"));
          }

          return Column(
            children: [
              // Очередь сверху
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
                    childAspectRatio: 1,
                  ),
                  itemCount: validButtons.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: SoundButtonWidget(
                        button: validButtons[index],
                        onAddToQueue: () => _addToQueue(validButtons[index]),
                      ),
                    );
                  },

                ),
              ),
            ],
          );
        },
      )
          : SettingsScreen(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
          }
        },
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Главная',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}
