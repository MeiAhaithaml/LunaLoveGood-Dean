class CartProduct {
  int? cart_id;
  int? user_id;
  int? item_id;
  int? quantity;
  String? size;
  String? name;
  double? average;
  int? inventory;
  List<String>? tag;
  List<String>? sizes;
  String? description;
  double? price;
  String? image;
  int? countBuy;

  CartProduct({
    this.cart_id,
    this.user_id,
    this.item_id,
    this.quantity,
    this.size,
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

  factory CartProduct.fromJson(Map<String,dynamic>json) => CartProduct(
    cart_id: int.parse(json['cart_id']),
    user_id: int.parse(json['user_id']),
    item_id: int.parse(json['item_id']),
    quantity: int.parse(json['quantity']),
    size: json['size'],
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
