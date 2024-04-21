import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lunalovegood/model/order_model.dart';
import 'package:lunalovegood/saudangnhap/home_page_second.dart';

class DetailsOrderPage extends StatefulWidget {
  const DetailsOrderPage({Key? key, required this.orderModel})
      : super(key: key);
  final OrderModel orderModel;

  @override
  State<DetailsOrderPage> createState() => _DetailsOrderPageState();
}

class _DetailsOrderPageState extends State<DetailsOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              children: [
                detailsWidget(),
                customer(),
                const Delivery(),
                note(),
                productOrder(),
                billWidget(),
              ],
          ),
        ),
      ),
      bottomNavigationBar: widget.orderModel.delivery == 1 ? bottomBar() : bottomBar2(),
    );
  }

  Widget detailsWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black12, width: 1),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/Document.svg"),
                Text(
                  "Mã đơn hàng : ${widget.orderModel.codeOrders}",
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Text(
              "Ngày đặt hàng: ${widget.orderModel.bookingDate}",
              style: const TextStyle(fontSize: 13, color: Color(0xFF595D5F)),
            ),
            Text(
              widget.orderModel.status,
              style: const TextStyle(fontSize: 13, color: Color(0xFFF21D1D)),
            ),
          ],
        ),
      ),
    );
  }

  Widget customer() {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset("assets/Location.svg"),
            Text(
              "${widget.orderModel.customer}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            const Text(
              "|",
              style: TextStyle(fontSize: 13, color: Color(0xFF595D5F)),
            ),
            Text(
              "${widget.orderModel.phone}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Text(
          "${widget.orderModel.address}",
          style: const TextStyle(fontSize: 13, color: Color(0xFF595D5F)),
        ),
      ],
    );
  }

  Widget note() {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset("assets/note.svg"),
            const Text(
              "Ghi chú nhận hàng",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Text(
          "${widget.orderModel.note}",
          style: const TextStyle(fontSize: 13, color: Color(0xFF595D5F)),
        ),
      ],
    );
  }

  Widget productOrder() {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(widget.orderModel.productImage ?? ''),
            Text(
              "${widget.orderModel.productName}",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Text(
                  "Size: ${widget.orderModel.size} ",
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF595D5F)),
                ),
                const Text("|"),
                Text(
                  "số lượng: ${widget.orderModel.buyCount} |",
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF595D5F)),
                ),
                Text(
                  " ${widget.orderModel.price} VNĐ",
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF595D5F)),
                )
              ],
            ),
          ],
        ),
        if (widget.orderModel.delivery == 3)
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                border: Border.all(width: 1, color: const Color(0xFFE57D7D))),
            child: const Center(
                child: Text(
              "Gửi đánh giá",
              style: TextStyle(fontSize: 13, color: Color(0xFFFF8D8D)),
            )),
          )
      ],
    );
  }

  Widget billWidget() {
    int fee = 18000;
    int total = widget.orderModel.price + fee;
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Giá tạm tính",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "$total VNĐ",
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              "Phí vận chuyển",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "$fee VNĐ",
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF51BE9C),
                  fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    );
  }

  Widget bottomBar() {
    return InkResponse(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Xác nhận hủy đơn hàng"),
              content:
                  const Text("Bạn có chắc chắn muốn hủy đơn hàng này không?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(3)),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFFDA243A),
                          ),
                          color: const Color(0xFFF8E4E4)),
                      child: const Text(
                        "Hủy",
                        style:
                            TextStyle(fontSize: 14, color: Colors.black),
                      )),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        color: Color(0xFFDA243A),
                      ),
                      child: const Text(
                        "Xác nhận",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      )),
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: Color(0xFFDA243A),
          ),
          child: const Center(
              child: Text(
            "Hủy đơn hàng",
            style: TextStyle(fontSize: 14, color: Colors.white),
          )),
        ),
      ),
    );
  }

  Widget bottomBar2() {
    String message = '';
    if (widget.orderModel.delivery == 2) {
      message = 'Đơn hàng đang được giao';
    } else if (widget.orderModel.delivery == 3) {
      message = 'Cảm ơn quý khách đã mua hàng';
    }
    return InkResponse(
      onTap: () {
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const HomePage(),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              border: Border.all(
                width: 1,
                color: const Color(0xFFDA243A),
              ),
              color: const Color(0xFFF8E4E4)),
          child: Center(
              child: Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          )),
        ),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFE0BABA),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkResponse(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset("assets/back.svg")),
            const Text(
              "Thông tin đơn hàng",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF595D5F),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class Delivery extends StatelessWidget {
  const Delivery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset("assets/delivery.svg"),
            const Text(
              "Được vận chuyển bởi J&T",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/Wallet.svg"),
                const Text(
                  "Hình thức thanh toán",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            const Text(
              "Thanh toán tiền mặt (COD)",
              style: TextStyle(fontSize: 13, color: Color(0xFF595D5F)),
            ),
          ],
        )
      ],
    );
  }
}
