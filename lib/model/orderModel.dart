class OrderProductModel {
  int? order_id;
  int? user_id;
  String? selectedProduct;
  String? deliverySystem;
  String? paymentSystem;
  String? note;
  double? totalAmount;
  String? image;
  String? status;
  DateTime? dateTime;
  String? addressUser;
  String? phoneUser;

  OrderProductModel({
    this.order_id,
    this.user_id,
    this.selectedProduct,
    this.deliverySystem,
    this.paymentSystem,
    this.note,
    this.totalAmount,
    this.image,
    this.status,
    this.dateTime,
    this.addressUser,
    this.phoneUser,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      OrderProductModel(
        order_id: int.parse(json["order_id"]),
        user_id: int.parse(json["user_id"]),
        selectedProduct: json["selectedProduct"],
        deliverySystem: json["deliverySystem"],
        paymentSystem: json["paymentSystem"],
        note: json["note"],
        totalAmount: double.parse(json["totalAmount"]),
        image: json["image"],
        status: json["status"],
        dateTime: DateTime.parse(json["dateTime"]),
        addressUser: json["addressUser"],
        phoneUser: json["phoneUser"],
      );

  Map<String, dynamic> toJson(String imageSelectedBase64) => {
        "order_id": order_id.toString(),
        "user_id": user_id.toString(),
        "selectedProduct": selectedProduct,
        "deliverySystem": deliverySystem,
        "paymentSystem": paymentSystem,
        "note": note,
        "totalAmount": totalAmount!.toStringAsFixed(2),
        "image": image,
        "status": status,
        "addressUser": addressUser,
        "phoneUser": phoneUser,
        "imageFile": imageSelectedBase64,
      };
}
