import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _audioPlayer.play(UrlSource(widget.button.audio)),
      onLongPress: widget.onAddToQueue, // Добавляем в очередь при долгом нажатии
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
                  ? Image.file(_imageFile!, height: 200, width: 200, fit: BoxFit.contain)
                  : SvgPicture.network(widget.button.image, placeholderBuilder: (context) => CircularProgressIndicator()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.button.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
            ElevatedButton(
              onPressed: widget.onAddToQueue,
              child: Text("В очередь"),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getCategoryColor(int categoryId) {
  List<Color> categoryColors = [Colors.blueAccent, Colors.greenAccent, Colors.orangeAccent];
  return categoryId > 0 && categoryId <= categoryColors.length ? categoryColors[categoryId - 1] : Colors.grey;
}
