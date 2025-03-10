class SoundButton {
   int id;
   String image;
   String audio;
   String title;
   int categoryId;

  SoundButton({
    required this.id,
    required this.image,
    required this.audio,
    required this.title,
    required this.categoryId,
  });

  factory SoundButton.fromJson(Map<String, dynamic> json) {
    return SoundButton(
      id: json['id'], // ✅ Добавляем ID
      image: json['image'],
      audio: json['audio'],
      title: json['title'],
      categoryId: json['category'],
    );
  }
}
