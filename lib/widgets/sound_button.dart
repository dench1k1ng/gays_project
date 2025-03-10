import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import '../models/sound_button.dart';
import '../services/api_service.dart';

class SoundButtonWidget extends StatefulWidget {
  final SoundButton button;

  const SoundButtonWidget({Key? key, required this.button}) : super(key: key);

  @override
  _SoundButtonWidgetState createState() => _SoundButtonWidgetState();
}

class _SoundButtonWidgetState extends State<SoundButtonWidget> {
  late AudioPlayer _audioPlayer;
  final Dio _dio = Dio();

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

  void _editSoundButton() {
    TextEditingController titleController =
        TextEditingController(text: widget.button.title);
    TextEditingController audioController =
        TextEditingController(text: widget.button.audio);
    TextEditingController imageController =
        TextEditingController(text: widget.button.image);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Редактировать кнопку"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Название"),
              ),
              TextField(
                controller: audioController,
                decoration: const InputDecoration(labelText: "Аудио URL"),
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: "Изображение URL"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Вызываем API для обновления карточки
                await ApiService().updateCard(
                  widget.button.id,
                  titleController.text,
                  audioController.text,
                  imageController.text,
                );

                // Обновляем UI после сохранения
                setState(() {
                  widget.button.title = titleController.text;
                  widget.button.audio = audioController.text;
                  widget.button.image = imageController.text;
                });

                Navigator.pop(context);
              },
              child: const Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }

  void _playSound() async {
    try {
      await _audioPlayer.stop();
      if (widget.button.audio.isNotEmpty) {
        await _audioPlayer.play(UrlSource(widget.button.audio));
      } else {
        print("Нет аудиофайла для кнопки");
      }
    } catch (e) {
      print("Ошибка воспроизведения: $e");
    }
  }

  Future<void> _updateButton() async {
    try {
      final response =
          await _dio.put('http://10.0.2.2:8000/api/cards/${widget.button.id}');
      if (response.statusCode == 200) {
        print("✅ Карточка ${widget.button.id} обновлена");
      } else {
        print("⚠️ Ошибка обновления карточки: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Ошибка при обновлении: $e");
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
        ? categoryColors[categoryId - 1]
        : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _playSound,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            color: _getCategoryColor(widget.button.categoryId),
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
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              GestureDetector(
                onTap: _updateButton,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.button.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
