class ShortcutModel {
  final String slug;
  final String menu;
  final String? deskripsi;
  final String? kategori;
  final String iconClass;
  final String colorHex;
  final String parentMenu;
  final String requiredFilter;

  ShortcutModel({
    required this.slug,
    required this.menu,
    this.deskripsi,
    this.kategori,
    required this.iconClass,
    required this.colorHex,
    required this.parentMenu,
    required this.requiredFilter,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'menu': menu,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'icon_class': iconClass,
      'color_hex': colorHex,
      'parent_menu': parentMenu,
      'required_filter': requiredFilter,
    };
  }

  /// Create from JSON
  factory ShortcutModel.fromJson(Map<String, dynamic> json) {
    return ShortcutModel(
      slug: json['slug'] ?? '',
      menu: json['menu'] ?? '',
      deskripsi: json['deskripsi'],
      kategori: json['kategori'],
      iconClass: json['icon_class'] ?? '',
      colorHex: json['color_hex'] ?? '#14B8A6',
      parentMenu: json['parent_menu'] ?? '',
      requiredFilter: json['required_filter'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShortcutModel && other.slug == slug;
  }

  @override
  int get hashCode => slug.hashCode;
}
