class OrderModel {
  final String? productName;
  final String? productImage;
  int price;
  final int buyCount;
  String status;
  final String? size;
  final String? bookingDate;
  final String? codeOrders;
  final String? deliveryDate;
  final String? customer;
  final int phone;
  final String? address;
  final String? note;
  final int delivery;




  OrderModel({
    required this.status,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.buyCount,
    required this.size,
    required this.address,
    this.bookingDate,
    required this.codeOrders,
    required this.customer,
    required this.deliveryDate,
    required this.note,
    required this.phone,
    required this.delivery
  });
}
