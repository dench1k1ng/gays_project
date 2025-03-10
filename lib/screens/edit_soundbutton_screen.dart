import 'package:flutter/material.dart';
import '../models/sound_button.dart';

class EditButtonScreen extends StatefulWidget {
  final SoundButton button;

  const EditButtonScreen({Key? key, required this.button}) : super(key: key);

  @override
  _EditButtonScreenState createState() => _EditButtonScreenState();
}

class _EditButtonScreenState extends State<EditButtonScreen> {
  late TextEditingController _titleController;
  late TextEditingController _audioController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.button.title);
    _audioController = TextEditingController(text: widget.button.audio);
    _imageController = TextEditingController(text: widget.button.image);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _audioController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Здесь можно добавить логику сохранения изменений в API
    print("Изменения сохранены:");
    print("Название: ${_titleController.text}");
    print("Аудио: ${_audioController.text}");
    print("Изображение: ${_imageController.text}");

    Navigator.pop(context); // Закрываем экран редактирования
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Редактирование кнопки")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Название"),
            ),
            TextField(
              controller: _audioController,
              decoration: InputDecoration(labelText: "Ссылка на аудио"),
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: "Ссылка на изображение"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text("Сохранить"),
            ),
          ],
        ),
      ),
    );
  }
}
