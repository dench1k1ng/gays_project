import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/sound_button.dart';

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

  // ✅ Function to Assign a Color Based on Category ID
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
        ? categoryColors[
            categoryId - 1] // ✅ Get the correct color from the list
        : Colors.grey; // Default color for unknown categories
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
            color: _getCategoryColor(
                widget.button.categoryId), // ✅ Apply Background Color
            borderRadius:
                BorderRadius.circular(12), // ✅ Rounded edges for better UI
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.button.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
