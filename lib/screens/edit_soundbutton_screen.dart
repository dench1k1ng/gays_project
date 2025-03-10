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
    print("Изменения сохранены:");
    print("Название: ${_titleController.text}");
    print("Аудио: ${_audioController.text}");
    print("Изображение: ${_imageController.text}");

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ✅ Close keyboard on tap
      child: Scaffold(
        resizeToAvoidBottomInset: true, // ✅ Prevents overflow
        appBar: AppBar(title: Text("Редактировать кнопку")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Название"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _audioController,
                  decoration: InputDecoration(labelText: "Аудио URL"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: "Изображение URL"),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Отмена"),
                    ),
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Text("Сохранить"),
                    ),
                  ],
                ),
                SizedBox(
                    height: MediaQuery.of(context)
                        .viewInsets
                        .bottom), // ✅ Fix for bottom spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
