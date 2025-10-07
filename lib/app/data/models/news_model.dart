class NewsModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final DateTime publishedDate;
  final String author;
  final String? content;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.publishedDate,
    required this.author,
    this.content,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      author: json['author'] as String,
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'publishedDate': publishedDate.toIso8601String(),
      'author': author,
      'content': content,
    };
  }
}
