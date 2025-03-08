class SoundCard {
  final String imageUrl;
  final String audioUrl;
  final String title;
  final int categoryId;

  SoundCard({
    required this.imageUrl,
    required this.audioUrl,
    required this.title,
    required this.categoryId,
  });

  // Factory constructor to create an instance from JSON
  factory SoundCard.fromJson(Map<String, dynamic> json) {
    return SoundCard(
      imageUrl: json['image'],
      audioUrl: json['audio'],
      title: json['title'],
      categoryId: json['category_id'],
    );
  }
}
