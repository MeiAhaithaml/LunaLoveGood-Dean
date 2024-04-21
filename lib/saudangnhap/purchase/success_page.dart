import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lunalovegood/saudangnhap/bottom_bar.dart';
import 'package:lunalovegood/saudangnhap/home_page_second.dart';


class SuccessPage extends StatelessWidget {
  const SuccessPage({Key? key, this.orderId,}) : super(key: key);
  final int? orderId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/illustration.svg"),
            const SizedBox(height: 30,),
                const SizedBox(height: 30,),
                const Center(
                  child: Text("Đơn hàng đã được tiếp nhận.",style:TextStyle(fontSize: 16,color: Color(0xFF595D5F))
                  ),
                ),
                const Center(
                  child: Text("Cảm ơn quý khách hàng đã tin tưởng dịch vụ của chúng tôi.",style:TextStyle(fontSize: 16,color: Color(0xFF595D5F))
                  ),
                ),
                const Text(
                    "Bạn có thể tiếp tục mua sắm hoặc theo dõi đơn hàng của mình.", textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Color(0xFF595D5F)),),
                const SizedBox(height: 30,),
                const BottomBarWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:  InkResponse(
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
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: const Color(0xFFFF8B8B)),
                child: const Center(
                    child: Text(
                  'Tiếp tục mua sắm ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ))),
          ),
        ),
      ],
    );
  }
}
