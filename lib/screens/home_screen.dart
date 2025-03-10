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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final crossAxisCount =
        isPortrait ? 2 : 5; // ✅ 2 buttons in portrait, 5 in landscape

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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
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
      await _audioPlayer.stop();

      if (widget.button.audio.isNotEmpty) {
        await _audioPlayer.setVolume(1.0);
        print("Попытка воспроизведения: ${widget.button.audio}");
        await _audioPlayer.play(UrlSource(widget.button.audio));

        _audioPlayer.onPlayerStateChanged.listen((state) {
          print("Текущее состояние плеера: $state");
        });

        _audioPlayer.onPlayerComplete.listen((_) {
          print("Воспроизведение завершено!");
        });
      } else {
        print("Нет аудиофайла для кнопки");
      }
    } catch (e) {
      print("Ошибка воспроизведения: $e");
    }
  }

  void _editSoundButton() {
    TextEditingController titleController =
        TextEditingController(text: widget.button.title);
    TextEditingController audioController =
        TextEditingController(text: widget.button.audio);
    TextEditingController imageController =
        TextEditingController(text: widget.button.image);

    showModalBottomSheet(
      isScrollControlled: true, // ✅ Ensures modal expands when needed
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final bottomPadding = MediaQuery.of(context)
                .viewInsets
                .bottom; // ✅ Detect keyboard height
            final isPortrait = MediaQuery.of(context).orientation ==
                Orientation.portrait; // ✅ Detect orientation
            final initialSize = isPortrait
                ? 0.4
                : 0.8; // ✅ Set modal height based on orientation
            final maxSize =
                isPortrait ? 0.9 : 1.0; // ✅ Allow full-screen in landscape

            return AnimatedPadding(
              duration: const Duration(
                  milliseconds:
                      300), // ✅ Smooth transition when keyboard appears
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                  bottom:
                      bottomPadding), // ✅ Push modal up when keyboard appears
              child: DraggableScrollableSheet(
                expand: false,
                initialChildSize: initialSize, // ✅ Adjust height dynamically
                minChildSize: 0.4, // ✅ Minimum size when dragged down
                maxChildSize: maxSize, // ✅ Maximum size when fully expanded
                builder: (context, scrollController) {
                  return GestureDetector(
                    onTap: () => FocusScope.of(context)
                        .unfocus(), // ✅ Close keyboard when tapping outside
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Редактировать кнопку",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: titleController,
                              decoration:
                                  const InputDecoration(labelText: "Название"),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: audioController,
                              decoration:
                                  const InputDecoration(labelText: "Аудио URL"),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: imageController,
                              decoration: const InputDecoration(
                                  labelText: "Изображение URL"),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Отмена"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // ✅ API Call to Update Button
                                    await ApiService().updateCard(
                                      widget.button.id,
                                      titleController.text,
                                      audioController.text,
                                      imageController.text,
                                    );

                                    // ✅ Update UI
                                    setState(() {
                                      widget.button.title =
                                          titleController.text;
                                      widget.button.audio =
                                          audioController.text;
                                      widget.button.image =
                                          imageController.text;
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: const Text("Сохранить"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _playSound,
      onLongPress: _editSoundButton, // ✅ Открываем редактор по долгому нажатию
      child: Card(
        color: _getCategoryColor(widget.button.categoryId),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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

Color _getCategoryColor(int categoryId) {
  List<Color> categoryColors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.redAccent,
    Colors.yellowAccent,
    Colors.tealAccent,
    Colors.pinkAccent,
    Colors.indigoAccent,
    Colors.cyanAccent,
    Colors.brown,
    Colors.limeAccent,
    Colors.amberAccent,
    Colors.deepOrangeAccent,
    Colors.lightBlueAccent,
  ];

  return categoryId > 0 && categoryId <= categoryColors.length
      ? categoryColors[categoryId - 1] // ✅ Get the correct color from the list
      : Colors.grey; // Default color for unknown categories
}
