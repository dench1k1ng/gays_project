class SoundButton {
  final int id;
  final String text;
  final String imageUrl;
  final String audioUrl;

  SoundButton({required this.id, required this.text, required this.imageUrl, required this.audioUrl});

  factory SoundButton.fromJson(Map<String, dynamic> json) {
    return SoundButton(
      id: json['id'],
      text: json['text'],
      imageUrl: json['image_url'],
      audioUrl: json['audio_url'],
    );
  }
}
