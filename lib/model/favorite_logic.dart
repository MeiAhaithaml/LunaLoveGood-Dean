import 'package:lunalovegood/model/whishlist_model.dart';

import 'best_sell_product_model.dart';

List<WishList> favoriteProducts = [];

void toggleFavorite(BestSell product) {
  if (favoriteProducts.contains(product)) {
    favoriteProducts.remove(product);
  } else {
    favoriteProducts.add(product as WishList);
  }
}
