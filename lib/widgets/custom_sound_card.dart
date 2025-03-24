import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../models/sound_button.dart';
import '../providers/queue_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSoundCard extends StatelessWidget {
  final SoundButton button;

  const CustomSoundCard({Key? key, required this.button}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioPlayer _audioPlayer = AudioPlayer();

    return Card(
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SvgPicture.network(
              button.image,
              placeholderBuilder: (context) => CircularProgressIndicator(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              button.title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () => _audioPlayer.play(UrlSource(button.audio)),
              ),
              IconButton(
                icon: Icon(Icons.queue_music, color: Colors.white),
                onPressed: () {
                  context.read<QueueProvider>().addToQueue(button);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
