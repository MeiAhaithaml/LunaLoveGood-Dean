import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewAddress extends StatefulWidget {
  const NewAddress({Key? key}) : super(key: key);

  @override
  State<NewAddress> createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
     body: SafeArea(
       child: SingleChildScrollView(
         child: Column(
           children: [
             AppBarWidget(),
             AddressFormPage(),
           ],
         ),
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
              "Thêm địa chỉ giao hàng",
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

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  _AddressFormPageState createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  String? selectedProvince;
  String? selectedCity;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _inputField(nameController, "Họ & tên người nhận"),
            _inputField(phoneController, "Số điện thoại"),
            const Text('Tỉnh/Thành phố'),
            DropdownButton<String>(
              value: selectedCity,
              onChanged: (String? value) {
                setState(() {
                  selectedCity = value;
                });
              },
              items: selectedProvince != null
                  ? <String>[
                      'City 1',
                      'City 2',
                      'City 3',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : [],
            ),
            const Text('Quận/huyện'),
            DropdownButton<String>(
              value: selectedProvince,
              onChanged: (String? value) {
                setState(() {
                  selectedProvince = value;
                });
              },
              items: <String>['Province 1', 'Province 2', 'Province 3']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text('Phường/Xã'),
            DropdownButton<String>(
              value: selectedProvince,
              onChanged: (String? value) {
                setState(() {
                  selectedProvince = value;
                });
              },
              items: <String>[' 1', ' 2', ' 3']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            const SizedBox(height: 16.0),
           _inputField(addController, "Địa chỉ"),
            const SizedBox(height: 16.0),
            bottomBar(),
          ],
        ),
      );
  }
Widget bottomBar(){
  return InkResponse(
    onTap: () {
      Navigator.pop(context, {
      'name': nameController.text,
      'phone': phoneController.text,
      'address': addController.text,
      'province': selectedProvince,
      'city': selectedCity,
      });
    },
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: Color(0xFFFF8B8B)),
        child: const Center(
            child: Text(
              "Xác Nhận",
              style: TextStyle(fontSize: 14, color: Colors.white),
            )),
      ),
    ),
  );
}
  Widget _inputField(
    TextEditingController controller,
      String name,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
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
}
