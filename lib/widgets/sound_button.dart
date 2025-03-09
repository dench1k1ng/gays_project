import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SoundButtonWidget extends StatelessWidget {
  final SoundButton button;
  final AudioPlayer _audioPlayer = AudioPlayer();

  SoundButtonWidget({Key? key, required this.button}) : super(key: key);

  void _playSound() async {
    try {
      await _audioPlayer.play(UrlSource(button.audio));
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
                button.image,
                placeholderBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                button.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
