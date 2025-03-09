// import 'package:flutter/material.dart';
// import 'package:food_save/widgets/sound_button.dart';
// import '../models/sound_card_model.dart';
//
// class HomeContent extends StatelessWidget {
//   final List<SoundCard> soundCards = [
//     SoundCard(
//       imageUrl: "https://yourserver.com/images/sound1.png",
//       audioUrl: "https://yourserver.com/audio/sound1.mp3",
//       title: "Bird Sound",
//       categoryId: 1,
//     ),
//     SoundCard(
//       imageUrl: "https://yourserver.com/images/sound2.png",
//       audioUrl: "https://yourserver.com/audio/sound2.mp3",
//       title: "Dog Bark",
//       categoryId: 2,
//     ),
//     SoundCard(
//       imageUrl: "https://yourserver.com/images/sound3.png",
//       audioUrl: "https://yourserver.com/audio/sound3.mp3",
//       title: "Cat Meow",
//       categoryId: 3,
//     ),
//     SoundCard(
//       imageUrl: "https://yourserver.com/images/sound4.png",
//       audioUrl: "https://yourserver.com/audio/sound4.mp3",
//       title: "Rain Sound",
//       categoryId: 4,
//     ),
//     SoundCard(
//       imageUrl: "https://yourserver.com/images/sound5.png",
//       audioUrl: "https://yourserver.com/audio/sound5.mp3",
//       title: "Thunder",
//       categoryId: 5,
//     ),
//   ]; // Replace with API data in a real app
//
//   @override
//   Widget build(BuildContext context) {
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//     final crossAxisCount =
//         isPortrait ? 2 : 4; // 2 buttons in portrait, 4 in landscape
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: crossAxisCount, // Dynamically change columns
//           crossAxisSpacing: 15,
//           mainAxisSpacing: 15,
//           childAspectRatio: 0.9,
//         ),
//         itemCount: soundCards.length,
//         itemBuilder: (context, index) {
//           return SoundButtonWidget(button: soundCards[index]);
//         },
//       ),
//     );
//   }
// }
