import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lunalovegood/model/orderModel.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';

class OrderDetails extends StatefulWidget {
  final OrderProductModel? clickedOrderInfo;

  const OrderDetails({super.key, this.clickedOrderInfo});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  RxString _status = "new".obs;
  String get status => _status.value;
  updateParcelStatus(String parcelReceived) {
    _status.value = parcelReceived;
  }

  showDialogForParcelConfirmation() async {
    if(widget.clickedOrderInfo!.status == "new")
    {
      var response = await Get.dialog(AlertDialog(
        title: const Text("Confirmation"),
        content: const Text(
          "Đơn hàng đã được giao đến bạn?",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Không",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: "yesConfirmed");
            },
            child: const Text(
              "Có",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ));
      if (response == "yesConfirmed") {
        updateStatusValue();
      }
    }
  }
  updateStatusValue() async
  {
    try
    {
      var response = await http.post(
          Uri.parse(API.updateOrderProduct),
          body:
          {
            "order_id": widget.clickedOrderInfo!.order_id.toString(),
          }
      );

      if(response.statusCode == 200)
      {
        var responseBodyOfUpdateStatus = jsonDecode(response.body);

        if(responseBodyOfUpdateStatus["success"] == true)
        {
          updateParcelStatus("arrived");
        }
      }
    }
    catch(e)
    {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateParcelStatus(widget.clickedOrderInfo!.status.toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appbarWidget(),
                displayOrderProductFromCart(),
                Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFFD9D9D9),
                ),
                const SizedBox(
                  height: 16,
                ),
                costumerWidget(),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFF9D9D9D),
                ),
                const SizedBox(
                  height: 8,
                ),
                deliveryWidget(),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFF9D9D9D),
                ),
                const SizedBox(
                  height: 8,
                ),
                paymentWidget(),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFF9D9D9D),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Hóa đơn thanh toán ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: FadeInImage(
                    height: 300,
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/1.jpg'),
                    image: NetworkImage(
                        API.hostImages + widget.clickedOrderInfo!.image!),
                    imageErrorBuilder: (context, error, stackTraceError) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget costumerWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset("assets/delivery.svg"),
        SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mã đơn hàng ${widget.clickedOrderInfo!.order_id!}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Text("|",
                    style: TextStyle(fontSize: 16, color: Color(0xFF595D5F))),
                Text(
                  widget.clickedOrderInfo!.phoneUser!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Container(
              width: 200,
              child: Text(
                " Địa chỉ giao hàng: ${widget.clickedOrderInfo!.addressUser!}",
                style: const TextStyle(fontSize: 16, color: Color(0xFF595D5F)),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget appbarWidget() {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Text(
                    DateFormat("dd MMMM,yyyy - hh:mm a")
                        .format(widget.clickedOrderInfo!.dateTime!),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF595D5F),
                        fontWeight: FontWeight.w600)),
                InkWell(
                  onTap: () {
                    print(status);
                    showDialogForParcelConfirmation();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          "Đã nhận ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Obx(() => status == "new"
                            ? const Icon(
                                Icons.help_outline,
                                color: Colors.redAccent,
                              )
                            : const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFF595D5F),
          )
        ],
      ),
    );
  }

  Widget deliveryWidget() {
    List<Widget> columnChildren = [
      const Text(
        "Hình thức giao hàng",
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      SizedBox(
        height: 16,
      ),
    ];
    if (widget.clickedOrderInfo!.deliverySystem == "J&T") {
      Widget jtRow = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset("assets/JT.svg"),
              const Text(
                "24000 VNĐ",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Được giao bởi ${widget.clickedOrderInfo!.deliverySystem}",
            style: const TextStyle(fontSize: 14, color: Color(0xFF595D5F)),
          )
        ],
      );
      columnChildren.add(jtRow);
    } else {
      Widget jt2Row = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset("assets/Post1.svg",width: 30,height: 30,),
              const Text(
                "24000 VNĐ",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Được giao bởi ${widget.clickedOrderInfo!.deliverySystem}",
            style: const TextStyle(fontSize: 14, color: Color(0xFF595D5F)),
          )
        ],
      );
      columnChildren.add(jt2Row);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnChildren,
    );
  }

  displayOrderProductFromCart() {
    List<String> clickedOrderProduct =
        widget.clickedOrderInfo!.selectedProduct!.split("||");

    return Column(
        children: List.generate(clickedOrderProduct.length, (index) {
      Map<String, dynamic> eachSelectedProduct =
          jsonDecode(clickedOrderProduct[index]);
      return Container(
        margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
            index == clickedOrderProduct.length - 1 ? 16 : 8),
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
                "SL: ${eachSelectedProduct["quantity"]}",
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

  Widget paymentWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Hình thức thanh toán",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        Text(
          "Thanh toán bằng ${widget.clickedOrderInfo!.paymentSystem}",
          style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF595D5F),
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
