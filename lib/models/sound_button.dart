class SoundButton {
  final int id;
  final String image;
  final String audio;
  final String title;
  final int category;

  SoundButton({
    required this.id,
    required this.image,
    required this.audio,
    required this.title,
    required this.category,
  });

  factory SoundButton.fromJson(Map<String, dynamic> json) {
    return SoundButton(
      id: json['id'],
      image: json['image'],
      audio: json['audio'],
      title: json['title'],
      category: json['category'],
    );
  }
}
