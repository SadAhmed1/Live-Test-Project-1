class PhotoModel {
  final dynamic id;
  final String title;
  final String imageUrl;
  final String size;
  final String date;
  final bool isFavorite;

  PhotoModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.size,
    required this.date,
    this.isFavorite = false,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    String formattedDate = 'Today';
    if (json['createdAt'] != null) {
      formattedDate = json['createdAt'].toString().split('T').first;
    } else if (json['created_at'] != null) {
      formattedDate = json['created_at'].toString().split('T').first;
    } else if (json['date'] != null) {
      formattedDate = json['date'].toString();
    }

    return PhotoModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? json['name'] ?? json['filename'] ?? 'Photo',
      imageUrl: json['imageUrl'] ??
          json['photoUrl'] ??
          json['url'] ??
          json['image'] ??
          '',
      size: json['size'] ?? json['fileSize'] ?? '3.2 MB',
      date: formattedDate,
      isFavorite: json['isFavorite'] ?? json['favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'size': size,
      'date': date,
      'isFavorite': isFavorite,
    };
  }
}
