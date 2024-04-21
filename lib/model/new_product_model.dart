class NewProduct {
  final String? productName;
  final String? productImage;
  final String? price;
  final int buyCount;
  final double? averageStar;
  final int? likeNumber;
  final int? commentCount;
  final int? inventory;
  final List<String>? categoryParentSlideImages;
  NewProduct({
    this.productName,
    this.productImage,
    required this.price,
    required this.buyCount,
    required this.averageStar,
     this.likeNumber,
     this.commentCount,
     this.inventory,
    this.categoryParentSlideImages
  });
}
