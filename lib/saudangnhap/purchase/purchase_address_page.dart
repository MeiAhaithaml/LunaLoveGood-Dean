

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lunalovegood/saudangnhap/purchase/add_address.dart';

import '../../model/customer_model.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key,required this.customerAddressList}) : super(key: key);
  final List<CustomerModel> customerAddressList;

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppBarWidget(),
              const SizedBox(height: 20),
              _defaultAddressWidget(),
              const SizedBox(height: 20),
              _newAddressListWidget(),
              InkResponse(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewAddress()),
                  );
                  if (result != null) {
                    setState(() {
                      widget.customerAddressList.add(CustomerModel(
                        customer: result['name'],
                        phone: result['phone'],
                        address: result['address'],
                      ));
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Thêm địa chỉ mới", style: TextStyle(fontSize: 14, color: Color(0xFF2E2E2E)),),
                    SvgPicture.asset("assets/next.svg")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBarWidget(),
    );
  }

  Widget _defaultAddressWidget(){
    if (widget.customerAddressList.isNotEmpty) {
      final defaultAddress = widget.customerAddressList.first;
      return Column(
        children: [
          _addressWidget(defaultAddress, 'Địa chỉ mặc định'),
          const Divider(),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _newAddressListWidget(){
    if (widget.customerAddressList.isNotEmpty) {
      final newAddressList = widget.customerAddressList.sublist(1);

      return Column(
        children: newAddressList.map((address) => _addressWidget(address, 'Địa chỉ mới')).toList(),
      );
    } else {
      return Container();
    }
  }

  Widget _addressWidget(CustomerModel address, String title){
    return Row(
      children: [
        SvgPicture.asset("assets/Address.svg"),
        Column(
          children: [
            Row(
              children: [
                Text('${address.customer}'),
                const Text('|'),
                Text('${address.phone}')
              ],
            ),
            Text('${address.address}')
          ],
        ),
        Text(title, style: const TextStyle(fontSize: 13, color: Color(0xFFD95252)),),
      ],
    );
  }
}
class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: Color(0xFFFF8B8B)),
          child: const Center(
              child: Text(
                "Chọn Địa Chỉ",
                style: TextStyle(fontSize: 14, color: Colors.white),
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
              "Địa chỉ giao hàng",
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