class NewsModel {
  final int idPost;
  final String title;
  final String description;
  final String imageUrl;
  final String imageSmallUrl;
  final String imageMiddleUrl;
  final String url; // slug for routing
  final String? tags;
  final DateTime createdAt;
  final String? content; // HTML content
  final String? descriptionText; // plain text version

  // Legacy fields for backward compatibility
  final String category;
  final String author;

  NewsModel({
    required this.idPost,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.imageSmallUrl,
    required this.imageMiddleUrl,
    required this.url,
    this.tags,
    required this.createdAt,
    this.content,
    this.descriptionText,
    this.category = '',
    this.author = '',
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      idPost: json['id_post'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      imageSmallUrl: json['image_small_url'] as String,
      imageMiddleUrl: json['image_middle_url'] as String,
      url: json['url'] as String,
      tags: json['tags'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      content: json['content'] as String?,
      descriptionText: _stripHtmlTags(json['description'] as String?),
      category: json['category'] as String? ?? '',
      author: json['author'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_post': idPost,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'image_small_url': imageSmallUrl,
      'image_middle_url': imageMiddleUrl,
      'url': url,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'content': content,
      'category': category,
      'author': author,
    };
  }

  // Helper method to strip HTML tags from description
  static String? _stripHtmlTags(String? htmlString) {
    if (htmlString == null) return null;
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  // Legacy compatibility - get id as String
  String get id => idPost.toString();

  // Legacy compatibility - publishedDate
  DateTime get publishedDate => createdAt;
}
