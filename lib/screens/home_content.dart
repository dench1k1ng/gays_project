import 'package:flutter/material.dart';
import 'package:food_save/widgets/sound_button.dart';
import '../models/sound_card_model.dart';

class HomeContent extends StatefulWidget {
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<SoundCard> soundCards = [
    SoundCard(
      imageUrl: "https://yourserver.com/images/sound1.png",
      audioUrl: "https://yourserver.com/audio/sound1.mp3",
      title: "Bird Sound",
      categoryId: 1,
    ),
    SoundCard(
      imageUrl: "https://yourserver.com/images/sound2.png",
      audioUrl: "https://yourserver.com/audio/sound2.mp3",
      title: "Dog Bark",
      categoryId: 2,
    ),
  ];
  // Replace this with API data in a real app
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 buttons per row
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.9,
        ),
        itemCount: soundCards.length,
        itemBuilder: (context, index) {
          return SoundButtonWidget(button: soundCards[index]);
        },
      ),
    );
  }
}
