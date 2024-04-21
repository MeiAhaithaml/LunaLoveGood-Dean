
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/saudangnhap/purchase/order_confirmation.dart';
import 'package:lunalovegood/user_preferences/current_user.dart';
import '../Product Detail/Controllers/oder_now_Controller.dart';

class PurchasePage extends StatefulWidget {
  PurchasePage(
      {Key? key,
      this.cartIDList,
      this.totalAmount,
      this.selectedCartListProduct})
      : super(key: key);
  final List<Map<String, dynamic>>? selectedCartListProduct;
  final double? totalAmount;
  final List<int>? cartIDList;

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  OderNowController orderNowController = Get.put(OderNowController());

  CurrentUser currentUser = Get.put(CurrentUser());
  CurrentUser currentUserController = Get.find<CurrentUser>();
  List<String> deliverySystemList = ["J&T", "Bưu điện Việt Nam"];

  List<String> paymentSystemList = ["VN Pay", "MoMo"];

  TextEditingController phoneController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController noteController = TextEditingController();

  void initState() {
    super.initState();
    phoneController.text = currentUserController.user.user_phone;
    addressController.text = currentUserController.user.user_address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBarWidget(),
                const SizedBox(
                  height: 16,
                ),
                const Text(" Sản phẩm: ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                displaySelectedProductFromCart(),
                //  costumerWidget(),
                const Text("Giao hàng: ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                delivery(),
                const SizedBox(
                  height: 16,
                ),
                const Text(" Phương thức thanh toán: ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                payment(),
                const SizedBox(
                  height: 16,
                ),
                const Text(" Số điện thoại: ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                _inputField_2(phoneController, "Số điện thoại"),
                const SizedBox(
                  height: 16,
                ),
                const Text(" Địa chỉ: ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                _inputField_2(addressController,'Địa chỉ giao hàng'),
                const SizedBox(
                  height: 16,
                ),
                const Text("Ghi chú ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                _inputField("Vui lòng nhập ghi chú...", noteController),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tổng tiền",
                    style: TextStyle(fontSize: 13, color: Color(0xFF545454)),
                  ),
                  Text(
                    "${widget.totalAmount!.toStringAsFixed(2)}  VNĐ",
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFFF27F71)),
                  )
                ],
              ),
              InkResponse(
                onTap: () {
                  {
                      if(phoneController.text == " " && addressController ==" " )
                        {

                          Fluttertoast.showToast(msg: "Vui long dien thong tin");
                        }
                      else{
                        Get.to(ConfirmationPage(
                          selectedCartId: widget.cartIDList,
                          selectedCartProduct: widget.selectedCartListProduct,
                          totalAmount: widget.totalAmount,
                          deliverySystem: orderNowController.deliverySys,
                          paymentSystem: orderNowController.paymentSys,
                          phoneNumber: phoneController.text,
                          addressUser: addressController.text,
                          noteUser: noteController.text,
                        ));
                      }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 197,
                    height: 50,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: Color(0xFFFF8B8B)),
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
  Widget _inputField_2(
      TextEditingController controller,
      String name,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,style: const TextStyle(fontSize: 16,color: Color(0xFF595D5F)),),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextField(
                  style: const TextStyle(color: Color(0XFF262626)),
                  controller: controller,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.black12,
                    ),
                  ))),
        ],
      ),
    );
  }

  Widget delivery() {
    return Column(
      children: deliverySystemList.map((deliverySystemName) {
        return Obx(() => RadioListTile<String>(
              tileColor: Colors.white,
              dense: true,
              activeColor: const Color(0xFFFF8B8B),
              title: Text(
                deliverySystemName,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              value: deliverySystemName,
              groupValue: orderNowController.deliverySys,
              onChanged: (newDeliverySystemValue) {
                orderNowController.setDelivery(newDeliverySystemValue!);
              },
            ));
      }).toList(),
    );
  }

  Widget payment() {
    return Column(
      children: paymentSystemList.map((paymentSystemName) {
        return Obx(() => RadioListTile<String>(
              dense: true,
              activeColor: const Color(0xFFFF8B8B),
              title: Text(
                paymentSystemName,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              value: paymentSystemName,
              groupValue: orderNowController.paymentSys,
              onChanged: (newPaymentNameSystemValue) {
                orderNowController.setPayment(newPaymentNameSystemValue!);
              },
            ));
      }).toList(),
    );
  }

  Widget noteToSeller() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Ghi chú",
          style: TextStyle(fontSize: 14, color: Color(0xFF595D5F)),
        ),
        Container(
          width: 500,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
              border: Border.all(width: 1, color: const Color(0xFFFF8B8B))),
          child: TextFormField(
            maxLines: 1,
            onChanged: (value) {
              print(value);
            },
          ),
        ),
      ],
    );
  }

  Widget phoneToSeller() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Số điện thoại",
          style: TextStyle(fontSize: 14, color: Color(0xFF595D5F)),
        ),
        Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
              border: Border.all(width: 1, color: const Color(0xFFFF8B8B))),
          child: TextFormField(
            maxLines: 1,
            onChanged: (value) {
              print(value);
            },
          ),
        ),
      ],
    );
  }

  Widget addressToSeller() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Địa chỉ ",
          style: TextStyle(fontSize: 14, color: Color(0xFF595D5F)),
        ),
        Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
              border: Border.all(width: 1, color: const Color(0xFFFF8B8B))),
          child: TextFormField(
            maxLines: 1,
            onChanged: (value) {
              print(value);
            },
          ),
        ),
      ],
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
     ) {
    return Container(
      width: 298,
      height: 60,
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
              color: Color(0xFFCBD5E1),
              width: 1,
            )),
      ),
      child: TextField(
        style: const TextStyle(color: Color(0XFF262626)),
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black12,
          ),
      ),
    ));
  }

  displaySelectedProductFromCart() {
    return Column(
        children: List.generate(widget.selectedCartListProduct!.length, (index) {
      Map<String, dynamic> eachSelectedProduct =
          widget.selectedCartListProduct![index];
      return Container(
        margin: EdgeInsets.fromLTRB(16,
            index == 0 ? 16 : 8,
            16,
            index == widget.selectedCartListProduct!.length - 1 ? 16 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFECECEC),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 6,
              color: Colors.black26,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              child: FadeInImage(
                height: 100,
                width: 110,
                fit: BoxFit.cover,
                placeholder: const AssetImage('assets/1.jpg'),
                image: NetworkImage(eachSelectedProduct["image"]),
                imageErrorBuilder: (context, error, stackTraceError) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //name
                    Text(
                      eachSelectedProduct["name"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    //size + color
                    Text(
                      eachSelectedProduct["size"]
                          .replaceAll("[", "")
                          .replaceAll("]", ""),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    //price
                    Text(
                      eachSelectedProduct["totalAmount"].toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFFF27F71),
                        fontWeight: FontWeight.bold,
                      ),
                    ),


                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "SL: " + eachSelectedProduct["quantity"].toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: Row(
        children: [
          InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset("assets/back.svg")),
          const SizedBox(
            width: 16,
          ),
          const Text(
            "Xác nhận đơn hàng",
            style: TextStyle(
                fontSize: 18,
                color: Color(0xFF595D5F),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget(
      {Key? key, required this.price, required this.image, required this.name})
      : super(key: key);
  final String image;
  final String name;
  final int price;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
            shape: const CircleBorder(),
            visualDensity: VisualDensity.compact,
            fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return const Color(0xFFFF8B8B);
              }
              return Colors.grey;
            }),
          ),
          Column(
            children: [
              SvgPicture.asset(widget.image),
              Text("Được giao bởi ${widget.name}"),
            ],
          ),
          Text("${widget.price} VNĐ"),
        ],
      ),
    );
  }
}
