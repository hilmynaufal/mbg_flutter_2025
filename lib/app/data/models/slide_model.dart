class SlideModel {
  final int idSlide;
  final String name;
  final String? description;
  final String imageUrl;
  final String? link;
  final int status;
  final DateTime createdAt;
  final int siteId;

  SlideModel({
    required this.idSlide,
    required this.name,
    this.description,
    required this.imageUrl,
    this.link,
    required this.status,
    required this.createdAt,
    required this.siteId,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      idSlide: json['id_slide'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String,
      link: json['link'] as String?,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      siteId: json['site_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_slide': idSlide,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'link': link,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'site_id': siteId,
    };
  }
}
