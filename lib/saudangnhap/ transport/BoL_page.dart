

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lunalovegood/model/order_model.dart';
import 'package:lunalovegood/saudangnhap/%20transport/details_order_page.dart';

class BillOfLandingPage extends StatefulWidget {
  const BillOfLandingPage({Key? key}) : super(key: key);

  @override
  State<BillOfLandingPage> createState() => _BillOfLandingPageState();
}

class _BillOfLandingPageState extends State<BillOfLandingPage> {
  List<String> searchResults = [
    "HHX1",
    "HHD2",
    "NV2",
    "NV4",
  ];

  void removeItem(int index) {
    setState(() {
      searchResults.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppbarWidget(),
              SizedBox(
                height: 26,
              ),
              TabWidget(select: 1),
            ],
          ),
          ),
        ),
      );

  }
}
class TabWidget extends StatefulWidget {
  const TabWidget({Key? key,required this.select}) : super(key: key);
  final int select;
  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.select;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  List<OrderModel> order = [
    OrderModel(
        status: "Giao hàng thành công",
        productName: "Hoa hong 10 bong",
        productImage: "assets/4.jpg",
        price: 120000,
        buyCount: 2,
        size: "S",
        address: "Yên Nghĩa, Yên Lộ, Hà Đông, Hà Nội, Việt Nam",
        bookingDate: "20/08/2023",
        codeOrders: "HH5",
        customer: "Nguyen Van A",
        deliveryDate: "24/08/2023",
        note: "Giao hàng ngoài giờ hành chính",
        phone: 0123456789,
    delivery: 3),
    OrderModel(
        status: "Đang giao hàng",
        productName: "Hoa hong 10 bong",
        productImage: "assets/4.jpg",
        price: 120000,
        buyCount: 2,
        size: "S",
        address: "Yên Nghĩa, Yên Lộ, Hà Đông, Hà Nội, Việt Nam",
        bookingDate: "20/08/2023",
        codeOrders: "HH5",
        customer: "Nguyen Van A",
        deliveryDate: "24/08/2023",
        note: "Giao hàng ngoài giờ hành chính",
        phone: 0123456789,
    delivery: 2),
    OrderModel(
        status: "Hàng đang được đóng gói",
        productName: "Hoa hong 10 bong",
        productImage: "assets/4.jpg",
        price: 120000,
        buyCount: 2,
        size: "S",
        address: "Yên Nghĩa, Yên Lộ, Hà Đông, Hà Nội, Việt Nam",
        codeOrders: "HH5",
        customer: "Nguyen Van A",
        deliveryDate: "24/08/2023",
        note: "Giao hàng ngoài giờ hành chính",
        phone: 0123456789,delivery: 1),
    OrderModel(
        status: "Giao hàng thành công",
        productName: "Hoa hong 10 bong",
        productImage: "assets/4.jpg",
        price: 120000,
        buyCount: 2,
        size: "S",
        address: "Yên Nghĩa, Yên Lộ, Hà Đông, Hà Nội, Việt Nam",
        bookingDate: "20/08/2023",
        codeOrders: "HH5",
        customer: "Nguyen Van A",
        deliveryDate: "24/08/2023",
        note: "Giao hàng ngoài giờ hành chính",
        phone: 0123456789,
    delivery: 3),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          indicatorColor: const Color(0xFFF76288),
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          labelColor: const Color(0xFF56707A),
          unselectedLabelColor: const Color(0xFF9CAAAF),
          tabs:  const [
            Tab(
              child: Text(
                "Tất cả",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              child: Text(
                "Đang giao",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              child: Text(
                "Thành công",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              child: Text(
                "Huỷ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
          controller: _tabController,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              list(),
              list("Đang giao"),
              list("Thành công"),
              // Center(child: NoOrder()),
            ],
          ),
        ),
      ],
    );
  }

  Widget list([String? statusFilter]) {
    List<OrderModel> filteredOrders = order;
    if (statusFilter != null) {
      filteredOrders = order.where((o) => o.status == statusFilter).toList();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            separatorBuilder: (ctx, idx) {
              return Container(
                width: 18,
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredOrders.length,
            itemBuilder: (ctx, idx) {
              var y = filteredOrders[idx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Mã đơn hàng : ${y.codeOrders}"),
                        Text(y.status),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox.fromSize(
                          size: const Size.fromRadius(20),
                          child: Image.asset(
                            y.productImage ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          children: [
                            Text(
                              y.productName ?? "",
                              style: const TextStyle(
                                color: Color(0xFF595D5F),
                                fontSize: 14,
                              ),
                            ),
                            Text("${y.size} | ${y.buyCount}"),
                            Text("${y.price} VND"),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Ngày mua: ${y.bookingDate}"),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                width: 1,
                                color: const Color(0xFFE8E8E8)
                            ),

                          ),
                          child: const InkResponse(
                            child: Text(
                                "Xem chi tiết"
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(child: Container()),
                 //   const MySeparator(color: Colors.grey),
                    Container(height: 200),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }}
class AppbarWidget extends StatelessWidget {
  const AppbarWidget({Key? key}) : super(key: key);

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

          ],
        ),
      ),
    );
  }
}

