import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:soz_alem/providers/queue_provider.dart';
import '../models/sound_button.dart';
import '../services/api_service.dart';

class SoundButtonWidget extends StatefulWidget {
  final SoundButton button;
  final VoidCallback onAddToQueue; // Добавляем коллбэк

  const SoundButtonWidget({
    Key? key,
    required this.button,
    required this.onAddToQueue,
  }) : super(key: key);

  @override
  _SoundButtonWidgetState createState() => _SoundButtonWidgetState();
}

class _SoundButtonWidgetState extends State<SoundButtonWidget> {
  late AudioPlayer _audioPlayer;
  File? _audioFile;
  File? _imageFile;
  Color _selectedColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _selectedColor = _getCategoryColor(widget.button.categoryId);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() => _audioFile = File(result.files.single.path!));
    }
  }

  Future<void> _pickColor() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Выберите цвет"),
        content: BlockPicker(
          pickerColor: _selectedColor,
          onColorChanged: (color) => setState(() => _selectedColor = color),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
        ],
      ),
    );
  }

  void _editSoundButton() {
    TextEditingController titleController =
        TextEditingController(text: widget.button.title);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Редактировать кнопку",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: "Название")),
                ElevatedButton(
                    onPressed: _pickImage, child: Text("Выбрать изображение")),
                ElevatedButton(
                    onPressed: _pickAudio, child: Text("Выбрать аудио")),
                ElevatedButton(
                    onPressed: _pickColor, child: Text("Выбрать цвет")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Отмена")),
                    ElevatedButton(
                      onPressed: () async {
                        await ApiService().updateCard(
                          widget.button.id,
                          titleController.text,
                          _audioFile?.path ?? widget.button.audio,
                          _imageFile?.path ?? widget.button.image,
                        );
                        setState(() {
                          widget.button.title = titleController.text;
                          widget.button.audio =
                              _audioFile?.path ?? widget.button.audio;
                          widget.button.image =
                              _imageFile?.path ?? widget.button.image;
                          widget.button.categoryId = _selectedColor.value;
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Сохранить"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _audioPlayer.play(UrlSource(widget.button.audio)),
      onLongPress: _editSoundButton, // Добавляем в очередь при долгом нажатии
      child: Card(
        color: _selectedColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _imageFile != null
                  ? Image.file(_imageFile!,
                      height: 200, width: 200, fit: BoxFit.contain)
                  : SvgPicture.network(widget.button.image,
                      placeholderBuilder: (context) =>
                          CircularProgressIndicator()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.button.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<QueueProvider>().addToQueue(widget.button);
              },
              child: Text("В очередь"),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getCategoryColor(int categoryId) {
  List<Color> categoryColors = [
    Color(0xFF1976D2), // Strong Blue
    Color(0xFF388E3C), // Deep Green
    Color(0xFFF57C00), // Rich Orange
    Color(0xFFD32F2F), // Bright Red
    Color(0xFF7B1FA2), // Dark Purple
    Color(0xFF00796B), // Deep Teal
    Color(0xFFFFA000), // Warm Amber
    Color(0xFFC2185B), // Deep Pink
    Color(0xFF303F9F), // Strong Indigo
    Color(0xFF0097A7), // Vibrant Cyan
    Color(0xFFAFB42B), // Muted Lime
    Color(0xFFE64A19), // Deep Orange
    Color(0xFF5E35B1), // Royal Purple
    Color(0xFF0288D1), // Medium Blue
    Color(0xFF689F38), // Olive Green
  ];

  return categoryId > 0 && categoryId <= categoryColors.length
      ? categoryColors[categoryId - 1]
      : Colors.grey;
}
