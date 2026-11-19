
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/article_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import '../widgets/news_image.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ArticleModel? article = Get.arguments is ArticleModel
        ? Get.arguments as ArticleModel
        : null;

    if (article == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Berita')),
        body: const Center(
          child: Text('Artikel tidak ditemukan.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: NewsImage(
                  url: article.urlToImage!,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              article.author ?? 'Sumber tidak diketahui',
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormatter.formatDate(article.publishedAt),
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const Divider(height: 32),
            Text(
              article.description ?? 'Tidak ada deskripsi.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              article.content ?? 'Isi berita tidak tersedia.',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
