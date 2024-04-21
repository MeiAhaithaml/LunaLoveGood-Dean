class Evaluate {
  final String? customerName;
  final String? productImage;
  final String? customerImage;
  final String? commentDate;
  final String? comment;
  final double? averageStar;
  final List<String>? categoryParentSlideImages;

  Evaluate({
    required this.customerName,
    this.productImage,
    required this.commentDate,
    this.comment,
    required this.averageStar,
    required this.customerImage,
    this.categoryParentSlideImages,
  });
}
