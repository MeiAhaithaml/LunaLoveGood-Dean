import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lunalovegood/model/orderModel.dart';
import 'package:http/http.dart' as http;
import 'package:lunalovegood/saudangnhap/purchase/order_details.dart';
import 'package:lunalovegood/user_preferences/current_user.dart';

import '../../api_connection/api_connection.dart';


class AdminGetAllOrderScreen extends StatelessWidget {
  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<OrderProductModel>> getAllOrderList() async {
    List<OrderProductModel> orderList = [];
    try {
      var res = await http.post(Uri.parse(API.adminReadOrder), body: {

      });
      if (res.statusCode == 200) {
        var resBodyOfGetCurrentUserOrderProduct = jsonDecode(res.body);
        if (resBodyOfGetCurrentUserOrderProduct['success'] == true) {
          (resBodyOfGetCurrentUserOrderProduct['allOrderData']
          as List)
              .forEach((eachCurrent) {
            orderList.add(OrderProductModel.fromJson(eachCurrent));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Khong hien status 200");
      }
    } catch (e) {
      print("Error: $e");
      Fluttertoast.showToast(msg: "Có lỗi xảy ra khi tải danh sách");
    }
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const AppBarWidget(),
            const SizedBox(height: 16,),
            Expanded(child: listOrder(context))
          ],
        ),
      ),
    );
  }

  Row buildRatingStars(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        stars.add(const Icon(
          Icons.star,
          color: Color(0xFFFF8159),
          size: 10,
        ));
      } else {
        stars.add(const Icon(
          Icons.star,
          color: Colors.grey,
          size: 10,
        ));
      }
    }
    return Row(children: stars);
  }

  Widget listOrder(context) {
    return FutureBuilder(
        future: getAllOrderList(),
        builder:
            (context, AsyncSnapshot<List<OrderProductModel>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: NoProduct(),
            );
          }
          if (dataSnapShot.data!.isNotEmpty) {
            List<OrderProductModel> orderList = dataSnapShot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  thickness: 1,
                );
              },
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                OrderProductModel eachOrderData = orderList[index];

                return Card(
                  color: Colors.white12,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ListTile(
                      onTap: () {
                        Get.to(OrderDetails(
                          clickedOrderInfo:eachOrderData,
                        ));
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mã đơn hàng # ${eachOrderData.order_id}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Tổng tiền: ${eachOrderData.totalAmount}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //date
                          //time
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //date
                              Text(
                                DateFormat(
                                    "dd MMMM, yyyy"
                                ).format(eachOrderData.dateTime!),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat(
                                    "hh:mm a"
                                ).format(eachOrderData.dateTime!),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 6),

                          const Icon(
                            Icons.navigate_next,
                            color: Color(0xFFF27F71),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Nothing to show...",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
        });
  }
}

class NoProduct extends StatelessWidget {
  const NoProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/Cart.png"),
          const SizedBox(
            height: 80,
          ),
          const Text(
            "Chưa có đơn đặt hàng nào !",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF595D5F)),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
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
            const Text("Đơn hàng",
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