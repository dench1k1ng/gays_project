class SoundButton {
  final String image;
  final String audio;
  final String title;
  final int categoryId; // ✅ Ensure it's an integer

  SoundButton({
    required this.image,
    required this.audio,
    required this.title,
    required this.categoryId,
  });

  factory SoundButton.fromJson(Map<String, dynamic> json) {
    return SoundButton(
      image: json['image'],
      audio: json['audio'],
      title: json['title'],
      categoryId: json['category'],
    );
  }
}
