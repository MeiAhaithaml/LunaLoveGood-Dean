class BestSell {
  final String? productName;
  final String? productImage;
  final num price;
  final int buyCount;
  final double? averageStar;
  final int likeNumber;
  final int commentCount;
  final int? inventory;
  final List<String>? categoryParentSlideImages;
  BestSell({
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
