class WishList {
  final String? productName;
  final String? productImage;
  final String? price;
  final int buyCount;
  final double? averageStar;
  final int likeNumber;
  final int commentCount;
  final int? inventory;
  final List<String>? categoryParentSlideImages;
  WishList({
    this.productName,
    this.productImage,
    required this.price,
    required this.buyCount,
    this.averageStar,
    required this.likeNumber,
    required this.commentCount,
    this.inventory,
    this.categoryParentSlideImages
  });
}
