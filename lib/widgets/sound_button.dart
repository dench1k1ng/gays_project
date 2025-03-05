import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound_button.dart';

class SoundButtonWidget extends StatelessWidget {
  final SoundButton button;
  SoundButtonWidget({required this.button});

  void _playSound(String url) async {
    final player = AudioPlayer();
    await player.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(imageUrl: button.imageUrl, width: 50, height: 50),
      title: Text(button.text),
      onTap: () => _playSound(button.audioUrl),
    );
  }
}
