import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/model/product_model.dart';
import 'package:lunalovegood/saudangnhap/home_page_second.dart';


import '../../api_connection/api_connection.dart';
import '../../model/cart_product_model.dart';
import '../../user_preferences/current_user.dart';
import '../Product Detail/Controllers/cart_controller.dart';
import 'package:http/http.dart' as http;

import '../bottom_bar.dart';
import '../purchase/purchase_information_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final currentOnlineUser = Get.put(CurrentUser());
  final cartController = Get.put(CartController());

  getCurrentUserCartList() async {
    List<CartProduct> cartListOfCurrenUser = [];
    try {
      var res = await http.post(Uri.parse(API.getCart), body: {
        "currentOnlineUserID": currentOnlineUser.user.user_id.toString()
      });
      if (res.statusCode == 200) {
        var resBodyOfGetCurrentUserCartProduct = jsonDecode(res.body);
        if (resBodyOfGetCurrentUserCartProduct['success'] == true) {
          (resBodyOfGetCurrentUserCartProduct['currentUserCartRecord'] as List)
              .forEach((eachCurrent) {
            cartListOfCurrenUser.add(CartProduct.fromJson(eachCurrent));
          });
        } else {
          Fluttertoast.showToast(msg: "Trich xuat khong thanh cong");
        }
        cartController.setList(cartListOfCurrenUser);
      } else {
        Fluttertoast.showToast(msg: "Khong hien status 200");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error::" + e.toString());
    }
    calculateTotalAmount();
  }

  calculateTotalAmount() {
    cartController.setTotal(0);
    if (cartController.isSelectProduct.isNotEmpty) {
      cartController.cartList.forEach((productInCart) {
        if (cartController.isSelectProduct.contains(productInCart.cart_id)) {
          double totalAmount = (productInCart.price!) *
              (double.parse(productInCart.quantity.toString()));
          cartController.setTotal(cartController.total + totalAmount);

          // In ra các giá trị để kiểm tra
          print('Price: ${productInCart.price}');
          print('Quantity: ${productInCart.quantity}');
          print('Total amount for this product: $totalAmount');
          print('Current total: ${cartController.total}');
        }
      });
    }
  }

  deleteSelectedProduct(int cartId) async {
    try {

      var res = await http.post(Uri.parse(API.deleteCart), body: {
        "cart_id": cartId.toString(),

      });

      if (res.statusCode == 200)
      {
        var resBodyFromDelete = jsonDecode(res.body);
        if (resBodyFromDelete['success'] == true) {
          getCurrentUserCartList();
        } else {
          Fluttertoast.showToast(
              msg:
              "Error, not 200");
        }
      }
    } catch (e) {
      print('Error :: ${3.toString()}');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  updateQuantityInCart(int cartID,int updateQuantity) async {
    try{
      var res = await http.post(Uri.parse(API.updateCart), body: {
        "cart_id": cartID.toString(),
        "quantity": updateQuantity.toString(),
      }
      );
      if (res.statusCode == 200)
      {
        var resBodyFromUpdateCartQuantity = jsonDecode(res.body);
        if (resBodyFromUpdateCartQuantity['success'] == true) {
          getCurrentUserCartList();
        } else {
          Fluttertoast.showToast(
              msg:
              "Error, not 200");
        }}}
    catch (e) {
      print('Error :: ${3.toString()}');
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  List<Map<String,dynamic>> getSelectedCartListInformation(){
    List<Map<String,dynamic>> selectedCartListInformation = [];
    if(cartController.isSelectProduct.length > 0){
      cartController.cartList.forEach((selectedCart) {
        if(cartController.isSelectProduct.contains(selectedCart.cart_id))
          {
            Map<String,dynamic> itemInformation = {
              "item_id":selectedCart.item_id,
              "name":selectedCart.name,
              "size":selectedCart.size,
              "quantity":selectedCart.quantity,
              "totalAmount":selectedCart.price! * selectedCart.quantity!,
              "price":selectedCart.price!,
              "image":selectedCart.image,
            };

            selectedCartListInformation.add(itemInformation);
          }
      });
    }
    return selectedCartListInformation;
  }
  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              const AppBarWidget(),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.black12,
              ),
              Obx(() => IconButton(
                  onPressed: () {
                    cartController.setIsSelectedAll();
                    cartController.clearAllSelectedItems();
                    if(cartController.isSelectAll){
                      cartController.cartList.forEach((eachProduct) {
                        cartController.addSelectedProduct(eachProduct.cart_id!);
                      });
                    }
                    calculateTotalAmount();
                  },
                  icon: Icon(
                    cartController.isSelectAll
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: cartController.isSelectAll
                        ? const Color(0xFF12A9CA)
                        : Colors.grey,
                  ))),
              const SizedBox(
                height: 8,
              ),

              const SizedBox(
                height: 8,
              ),
              Obx(() => cartController.cartList.isNotEmpty
                  ? Expanded(
                child: ListView.builder(
                    itemCount: cartController.cartList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, idx) {
                      CartProduct cartProduct = cartController.cartList[idx];
                      ProductModel productModel = ProductModel(
                          item_id: cartProduct.item_id,
                          image: cartProduct.image,
                          name: cartProduct.name,
                          price: cartProduct.price,
                          average: cartProduct.average,
                          sizes: cartProduct.sizes,
                          description: cartProduct.description,
                          tag: cartProduct.tag,
                          inventory: cartProduct.inventory);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GetBuilder(
                                init: CartController(),
                                builder: (c) {
                                  return IconButton(
                                    onPressed: () {
                                      if(cartController.isSelectProduct.contains(cartProduct.cart_id)){
                                        cartController.deleteSelectedProduct(cartProduct.cart_id!);
                                      }
                                      else{
                                        cartController.addSelectedProduct(cartProduct.cart_id!);
                                      }
                                      cartController.addSelectedProduct(cartProduct.cart_id!);
                                      calculateTotalAmount();
                                    },
                                    icon: Icon(
                                      cartController.isSelectProduct
                                          .contains(cartProduct.cart_id)
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      color: cartController.isSelectAll
                                          ? const Color(0xFF12A9CA)
                                          : Colors.grey,
                                    ),
                                  );
                                }),
                            SizedBox(
                              width: 110,
                              height: 90,
                              child: Image.network(
                                cartProduct.image ?? '',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                "${productModel.name} ${cartProduct.size!.replaceAll('[', '').replaceAll(']', '')}",
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF252525)),
                              ),
                              Text(
                                "${productModel.price} VNĐ",
                                style:
                                const TextStyle(fontSize: 13, color: Color(0xFF797979)),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                  "Size: ${cartProduct.size!.replaceAll('[', '').replaceAll(']', '')}",
                                  style: const TextStyle(
                                      fontSize: 13, color: Color(0xFF797979))),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: const Color(0xFFE8E8E8))),
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: ()
                                        {
                                          if(cartProduct.quantity! - 1 >= 1){
                                            updateQuantityInCart(
                                              cartProduct.cart_id!,
                                              cartProduct.quantity! -1,
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.minimize_outlined,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: const Color(0xFFE8E8E8))),
                                    child: Center(
                                      child: Text(
                                        cartProduct.quantity.toString(),
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: const Color(0xFFE8E8E8))),
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: ()
                                        {
                                          updateQuantityInCart(
                                            cartProduct.cart_id!,
                                            cartProduct.quantity! +1,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              ),
                            ]),
                            Container(
                              width: 37,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 0.5, color: const Color(0xFF797979))),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                color: const Color(0xFFE29797),
                                icon: const Icon(Icons.close),
                                onPressed: () async{
                                  var responseFromDialogBox = await Get.dialog(
                                      AlertDialog(
                                        backgroundColor: Colors.grey,
                                        title: const Text("Xóa "),
                                        content: const Text("Bạn có chắc muốn xóa sản phẩm khỏi giỏ hàng không?"),
                                        actions: [
                                          TextButton(onPressed: (){
                                            Get.back();
                                          }, child: const Text("Không"),),
                                          TextButton(onPressed: (){
                                            Get.back(result: "Xóa");
                                          }, child: const Text("Có"),),
                                        ],
                                      ));
                                  if(responseFromDialogBox == "Xóa"){
                                    cartController.isSelectProduct.forEach((eachSelectedProduct) {
                                      deleteSelectedProduct(eachSelectedProduct);
                                    });
                                    calculateTotalAmount();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              )
                  : const NoProduct()),
            ],
          )),
      bottomNavigationBar: GetBuilder(
        init: CartController(),
        builder: (c) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Giá tạm tính",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF545454),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(() => Text(
                      "${cartController.total.toStringAsFixed(3)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    color: cartController.isSelectProduct.isNotEmpty
                        ? const Color(0xFFFF8B8B)
                        : Colors.grey,
                  ),
                  child: InkWell(
                    onTap: () {
                      cartController.isSelectProduct.length > 0 ? Get.to(PurchasePage(
                        selectedCartListProduct: getSelectedCartListInformation(),
                        totalAmount: cartController.total,
                        cartIDList: cartController.isSelectProduct,
                      )) : null;
                    },
                    child: const Center(
                      child: Text(
                        "Mua Ngay",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget bottomBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Giá tạm tính",
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF545454),
                  fontWeight: FontWeight.w500),
            ),
            Obx(() => Text(
                  " ${cartController.total.toStringAsFixed(3)} VNĐ",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 1,
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                color: cartController.isSelectProduct.isNotEmpty
                    ? const Color(0xFFFF8B8B)
                    : Colors.grey),
            child: InkWell(
              onTap: () {},
              child: const Center(
                  child: Text(
                "Mua Ngay",
                style: TextStyle(fontSize: 14, color: Colors.white),
              )),
            ),
          ),
        ),
      ],
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
            const Text("Giỏ hàng",
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
            "Chưa có sản phẩm nào !",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF595D5F)),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "LunaLoveGood còn rất nhiều sản phẩm dành cho bạn,hãy dành thêm thời gian để chọn sản phẩm nhé",
            style: TextStyle(fontSize: 14, color: Color(0xFF595D5F)),
          ),
          const SizedBox(
            height: 20,
          ),
          InkResponse(
            onTap: () {
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const NavigationMenu(),
                  ),
                );
              }
            },
            child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: const Color(0xFFFF8B8B)),
              child: const Center(
                child: Text(
                  "Tiếp tục mua sắm",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


