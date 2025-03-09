import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/api_service.dart';
import '../models/sound_button.dart';
import 'settings_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<SoundButton>> _buttonsFuture;

  @override
  void initState() {
    super.initState();
    _buttonsFuture = ApiService().fetchButtons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Soz Alem")),
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

                // Фильтруем кнопки без изображения
                List<SoundButton> validButtons = snapshot.data!
                    .where((btn) => btn.image.isNotEmpty)
                    .toList();

                if (validButtons.isEmpty) {
                  return const Center(
                      child: Text("Нет кнопок с изображениями"));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: validButtons.length,
                  itemBuilder: (context, index) {
                    return SoundButtonWidget(button: validButtons[index]);
                  },
                );
              },
            )
          : SettingsScreen(),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 1) {
            // ✅ Navigate to SettingsScreen as a separate page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
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

class SoundButtonWidget extends StatefulWidget {
  final SoundButton button;

  const SoundButtonWidget({Key? key, required this.button}) : super(key: key);

  @override
  _SoundButtonWidgetState createState() => _SoundButtonWidgetState();
}

class _SoundButtonWidgetState extends State<SoundButtonWidget> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSound() async {
    try {
      await _audioPlayer.stop(); // Stop any currently playing audio

      if (widget.button.audio.isNotEmpty) {
        await _audioPlayer.play(UrlSource(widget.button.audio));
      } else {
        print("Нет аудиофайла для кнопки");
      }
    } catch (e) {
      print("Ошибка воспроизведения: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _playSound,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SvgPicture.network(
                widget.button.image,
                placeholderBuilder: (context) =>
                    const CircularProgressIndicator(),
                height: 200,
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.button.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
