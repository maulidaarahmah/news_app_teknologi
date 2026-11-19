
import 'package:get/get.dart';

import '../models/article_model.dart';

class DetailController extends GetxController {
  ArticleModel? get article {
    final data = Get.arguments;

    if (data is ArticleModel) {
      return data;
    }

    return null;
  }
}
