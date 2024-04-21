class ProductModel {
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

  ProductModel({
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
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    item_id: int.parse(json["item_id"]),
    name: json["name"],
    average: double.parse(json["average"]),
    inventory: int.parse(json["inventory"]),
    tag: json["tag"].toString().split(", "),
    sizes: json["sizes"].toString().split(", "),
    description: json["description"],
    price: double.parse(json["price"]),
    image:json["image"],
    countBuy: int.parse(json["countBuy"]),
  );
}
