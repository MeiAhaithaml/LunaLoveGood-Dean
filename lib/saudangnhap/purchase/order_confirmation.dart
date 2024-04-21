import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lunalovegood/saudangnhap/purchase/success_page.dart';
import 'package:path/path.dart' as path;
import '../../api_connection/api_connection.dart';
import '../../model/orderModel.dart';
import '../../user_preferences/current_user.dart';
import 'package:http/http.dart' as http;

class ConfirmationPage extends StatelessWidget {
  final List<int>? selectedCartId;
  final List<Map<String, dynamic>>? selectedCartProduct;
  final double? totalAmount;
  final String? deliverySystem;
  final String? paymentSystem;
  final String? phoneNumber;
  final String? addressUser;
  final String? noteUser;

  ConfirmationPage(
      {super.key, this.totalAmount,
      this.addressUser,
      this.deliverySystem,
      this.noteUser,
      this.paymentSystem,
      this.phoneNumber,
      this.selectedCartId,
      this.selectedCartProduct});

  final RxList<int> _imageSelectedByte = <int>[].obs;

  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);

  final RxString _imageSelectedName = "".obs;

  String get imageSelectedName => _imageSelectedName.value;

  final ImagePicker _picker = ImagePicker();

  CurrentUser currentUser = Get.put(CurrentUser());

  setSelectedImage(Uint8List selectedImage) {
    _imageSelectedByte.value = selectedImage;
  }

  setSelectedImageName(String selectedImageName) {
    _imageSelectedName.value = selectedImageName;
  }

  chooseImageFromGallery() async {
    final pickedImageXFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImageXFile != null) {
      final bytesOfImage = await pickedImageXFile.readAsBytes();

      setSelectedImage(bytesOfImage);

      setSelectedImageName(path.basename(pickedImageXFile.path));
    }
  }

  saveNewOrderInfo() async {
    String selectedItemsString = selectedCartProduct!
        .map((eachSelectedItem) => jsonEncode(eachSelectedItem))
        .toList()
        .join("||");

    OrderProductModel order = OrderProductModel(
      order_id: 1,
      user_id: currentUser.user.user_id,
      selectedProduct: selectedItemsString,
      deliverySystem: deliverySystem,
      paymentSystem: paymentSystem,
      note: noteUser,
      totalAmount: totalAmount,
      image: DateTime.now().millisecondsSinceEpoch.toString() +
          "-" +
          imageSelectedName,
      status: "new",
      dateTime: DateTime.now(),
      addressUser: addressUser,
      phoneUser: phoneNumber,
    );

    try {
      var res = await http.post(
        Uri.parse(API.addOrderProduct),
        body: order.toJson(base64Encode(imageSelectedByte)),
      );

      if (res.statusCode == 200) {
        var responseBodyOfAddNewOrder = jsonDecode(res.body);

        if (responseBodyOfAddNewOrder["success"] == true) {
          selectedCartId!.forEach((eachSelectedItemCartID) {
            deleteSelectedProduct(eachSelectedItemCartID);
          });
        } else {
          Fluttertoast.showToast(msg: "Lỗi thanh toán");
        }
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error: " + errorMsg.toString());
    }
  }

  deleteSelectedProduct(int cartId) async {
    try {
      var res = await http.post(Uri.parse(API.deleteCart), body: {
        "cart_id": cartId.toString(),
      });

      if (res.statusCode == 200) {
        var resBodyFromDelete = jsonDecode(res.body);
        if (resBodyFromDelete['success'] == true) {
          Fluttertoast.showToast(
              msg: "Don hang cua ban duoc cap nhat thanh cong");
          Get.to(  SuccessPage(
            orderId: resBodyFromDelete['order_id'],
          ));
        } else {
          Fluttertoast.showToast(msg: "Error, not 200");
        }
      }
    } catch (e) {
      print('Error :: ${3.toString()}');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              qrCode(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 8,
                color: const Color(0xFFF4F4F4),
              ),
              const SizedBox(
                height: 4,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Sau khi thanh toán vui lòng xuất chứng minh giao dịch",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Material(
                elevation: 8,
                color: const Color(0xFFFBE8E8),
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    chooseImageFromGallery();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    child: Text(
                      "Chọn ảnh ",
                      style: TextStyle(
                        color: Color(0xFFCE5A5A),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                      maxHeight: MediaQuery.of(context).size.width * 0.6,
                    ),
                    child: imageSelectedByte.isNotEmpty
                        ? Image.memory(
                            imageSelectedByte,
                            fit: BoxFit.contain,
                          )
                        : const Placeholder(
                            color: Colors.white60,
                          ),
                  )),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkResponse(
                  onTap: () {
                    {
                      if (imageSelectedByte.isNotEmpty) {
                        saveNewOrderInfo();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Vui long gui thong tin thanh toan");
                      }
                    }
                  },
                  child: Container(
                    width: 197,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(3)),
                        color: imageSelectedByte.isNotEmpty
                            ? const Color(0xFFFF8B8B)
                            : const Color(0xFFFF8B8B)),
                    child: const Center(
                        child: Text(
                          "Đặt Hàng",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget qrCode() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text("Vui lòng quét mã dưới đây để thanh toán",
              style: TextStyle(fontSize: 18, color: Colors.black)),
          const SizedBox(height: 16,),
          Center(child: SvgPicture.asset("assets/qrcode.svg")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Tổng đơn hàng",
                  style: TextStyle(fontSize: 18, color: Colors.black)),
              Text("$totalAmount VNĐ",
                  style: const TextStyle(fontSize: 18, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset("assets/back.svg"),
            ),
            const SizedBox(
              width: 16,
            ),
            const Text("Thanh toán",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF595D5F),
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
