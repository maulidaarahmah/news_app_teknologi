import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/article_model.dart';
import '../routes/app_routes.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/article_card.dart';
import '../widgets/error_view.dart';
import 'search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NewsApiService _service = NewsApiService();

  // Cache berita untuk setiap kategori
  final Map<String, Future<List<ArticleModel>>> _categoryCache = {};

  // Daftar kategori berita
  static const Map<String, String> _categories = {
    'technology': 'Teknologi',
    'science': 'Sains',
    'business': 'Bisnis',
    'general': 'Utama',
    'nation': 'Nasional',
    'world': 'Dunia',
    'sports': 'Olahraga',
    'health': 'Kesehatan',
  };

  String _selectedCategory = 'technology';

  late Future<List<ArticleModel>> _futureNews;

  // Mengambil berita dari cache atau API
  Future<List<ArticleModel>> _ambilDenganCache(String category) {
    return _categoryCache.putIfAbsent(
      category,
      () => _service.getTopHeadlines(category: category),
    );
  }

  @override
  void initState() {
    super.initState();
    _futureNews = _ambilDenganCache(_selectedCategory);
  }

  // Membuka dialog pencarian berita
  Future<void> _bukaPencarian() async {
    final input = TextEditingController();

    final keyword = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cari Berita Teknologi'),
        content: TextField(
          controller: input,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Contoh: AI, Samsung, Apple',
          ),
          onSubmitted: (value) {
            Navigator.pop(dialogContext, value.trim());
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext, input.text.trim());
            },
            child: const Text('Cari'),
          ),
        ],
      ),
    );

    if (!mounted) {
      input.dispose();
      return;
    }

    // Menunda pembersihan controller sampai dialog selesai ditutup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      input.dispose();
    });

    if (keyword == null || keyword.isEmpty) {
      return;
    }

    Get.to(() => SearchView(keyword: keyword));
  }

  // Memuat ulang berita
  void _muatUlang({bool paksaRefresh = false}) {
    if (paksaRefresh) {
      _categoryCache.remove(_selectedCategory);
    }

    setState(() {
      _futureNews = _ambilDenganCache(_selectedCategory);
    });
  }

  // Mengganti kategori berita
  
void _gantiKategori(String category) {
  if (category == _selectedCategory) {
    return;
  }

  setState(() {
    _selectedCategory = category;
    _futureNews = _ambilDenganCache(category);
  });
}


  // Pull-to-refresh untuk mengambil data terbaru
  Future<void> _onRefresh() async {
    _muatUlang(paksaRefresh: true);

    try {
      await _futureNews;
    } catch (_) {
      // Error akan ditampilkan oleh FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App Teknologi Indonesia'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Cari berita',
            onPressed: _bukaPencarian,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: FutureBuilder<List<ArticleModel>>(
              future: _futureNews,
              builder: (context, snapshot) {
                // State 1: Loading
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // State 2: Error
                if (snapshot.hasError) {
                  return ErrorView(
                    message: snapshot.error.toString(),
                    onRetry: () => _muatUlang(paksaRefresh: true),
                  );
                }

                final articles = snapshot.data ?? [];

                // State 3: Data kosong
                if (articles.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada berita untuk kategori ini.',
                    ),
                  );
                }

                // State 4: Data berhasil dimuat
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan pilihan kategori
  Widget _buildCategoryChips() {
    return Container(
      height: 56,
      color: AppColors.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories.keys.elementAt(index);

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 8,
            ),
            child: ChoiceChip(
              label: Text(_categories[category]!),
              selected: category == _selectedCategory,
              
onSelected: (selected) {
  debugPrint('KATEGORI DIKLIK: $category, selected: $selected');
  _gantiKategori(category);
},

            ),
          );
        },
      ),
    );
  }
}
