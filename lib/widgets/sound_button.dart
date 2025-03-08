import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound_card_model.dart';

class SoundButtonWidget extends StatefulWidget {
  final SoundCard button;
  const SoundButtonWidget({required this.button, Key? key}) : super(key: key);

  @override
  _SoundButtonWidgetState createState() => _SoundButtonWidgetState();
}

class _SoundButtonWidgetState extends State<SoundButtonWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playSound(String url) async {
    await _audioPlayer.stop(); // Stop any currently playing audio
    await _audioPlayer.play(UrlSource(url)); // Play new audio
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _playSound(widget.button.audioUrl),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Make button circular
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 5, offset: Offset(2, 2))
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: widget.button.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, size: 40),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            widget.button.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
