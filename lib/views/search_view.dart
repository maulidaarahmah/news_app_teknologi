
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/article_model.dart';
import '../routes/app_routes.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';

class SearchView extends StatefulWidget {
  final String keyword;

  const SearchView({
    super.key,
    required this.keyword,
  });

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final NewsApiService _service = NewsApiService();

  late Future<List<ArticleModel>> _futureSearch;

  @override
  void initState() {
    super.initState();
    _futureSearch = _service.searchNews(widget.keyword);
  }

  void _cobaLagi() {
    setState(() {
      _futureSearch = _service.searchNews(widget.keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil: ${widget.keyword}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ArticleModel>>(
        future: _futureSearch,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: snapshot.error.toString(),
              onRetry: _cobaLagi,
            );
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return const Center(
              child: Text('Tidak ada hasil pencarian.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];

              return ArticleCard(
                article: article,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.detail,
                    arguments: article,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
