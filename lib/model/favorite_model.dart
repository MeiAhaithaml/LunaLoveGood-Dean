class FavoriteProductModel {
  int? favorite_id;
  int? user_id;
  int? item_id;
  String? name;
  double? average;
  int? inventory;
  List<String>? tag;
  List<String>? sizes;
  String? description;
  double? price;
  String? image;
  int? countBuy;

  FavoriteProductModel({
    this.favorite_id,
    this.user_id,
    this.item_id,
    this.name,
    this.average,
    this.inventory,
    this.tag,
    this.sizes,
    this.description,
    this.price,
    this.image,
    this.countBuy
  });

  factory FavoriteProductModel.fromJson(Map<String,dynamic>json) => FavoriteProductModel(
    favorite_id: int.parse(json['favorite_id']),
    user_id: int.parse(json['user_id']),
    item_id: int.parse(json['item_id']),
    name: json['name'],
    average: double.parse(json['average']),
    inventory: int.parse(json['inventory']),
    tag: json['tag'].toString().split(', '),
    sizes: json['sizes'].toString().split(', '),
    description: json['description'],
    price: double.parse(json['price']),
    image: json['image'],
    countBuy: int.parse(json['countBuy']),

  );

}
