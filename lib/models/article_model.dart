
class ArticleModel {
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String publishedAt;
  final String? author;
  final String? content;

  ArticleModel({
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    required this.publishedAt,
    this.author,
    this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'];

    return ArticleModel(
      author: source is Map ? source['name'] as String? : null,
      title: json['title'] as String? ?? 'Tanpa Judul',
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['image'] as String?,
      publishedAt: json['publishedAt'] as String? ?? '',
      content: _rapikanContent(json['content'] as String?),
    );
  }

  // Merapikan isi artikel dari GNews versi gratis
  static String? _rapikanContent(String? content) {
    if (content == null) return null;

    return content.replaceAll(
      RegExp(r'\s*\[\d+ chars\]$'),
      '...',
    );
  }
}
