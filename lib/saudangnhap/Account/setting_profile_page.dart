import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lunalovegood/model/customer_model.dart';

import 'User_profile_page.dart';

class SettingPageWidget extends StatefulWidget {
  const SettingPageWidget({Key? key,}) : super(key: key);
  @override
  State<SettingPageWidget> createState() => _SettingPageWidgetState();
}
CustomerModel information = CustomerModel(
    customer: "Nguyen Van A",
    phone:033247829,
    address:"16 ngõ 169 Hoàng Mai",
    avatar:"assets/Luxiem.png",
    email: "vana@gmail.com"
);
class _SettingPageWidgetState extends State<SettingPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SafeArea(
         child: SingleChildScrollView(
           child: Padding(
             padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
             child: Column(
               children: [
                 const AppBarWidget(),
                 const SizedBox(height: 16,),
                 AccountInformation(customerModel: information,),
               ],
             ),
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
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Row(
          children: [
            InkResponse(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset("assets/back.svg")),
            const SizedBox(width: 16,),
            const Text(
              "Cài đặt tài khoản",
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
class AccountInformation extends StatelessWidget {
  const AccountInformation({Key? key,required this.customerModel}) : super(key: key);
  final CustomerModel customerModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 1,
                color: Color(0xFFEFEFEF)
              )
            )
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset("assets/account.svg",width: 30,height: 30,), const SizedBox(width: 16,),
                    const Text("Thông tin cá nhân",style: TextStyle(fontSize: 14,color: Color(0xFF5A5A5A)),)
                  ],
                ),
                InkResponse(
                    onTap: () {
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => UserProfilePageWidget(customer: customerModel,),
                          ),
                        );
                      }
                    },
                    child: SvgPicture.asset("assets/next.svg")),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16,),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            width: 1,
                            color: Color(0xFFEFEFEF)
                        )
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset("assets/bell.svg",width: 20,height: 20,), const SizedBox(width: 16,),
                          const Text("Cài đặt thông báo",style: TextStyle(fontSize: 14,color: Color(0xFF5A5A5A)),)
                        ],
                      ),
                    const SwitchExample(),
                    ],
                  ),
                ),
              ),
              Container(
                height: 7,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFFEFEFEF),
              ),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset("assets/bangzhu.svg",width: 20,height: 20,),
                      const SizedBox(width: 16,),
                      const Text("App version",style: TextStyle(fontSize: 14,color: Color(0xFF5A5A5A)),)
                    ],
                  ),
                  const Text("1.0.0",style: TextStyle(fontSize: 14,color: Color(0xFF5A5A5A)),),
                ],
              ),
              const SizedBox(height: 8,),
              Container(
                height: 7,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFFEFEFEF),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light1 = true;

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF1288CA);
        }
        return null;
      },
    );
    return Switch(
      thumbIcon: thumbIcon,
      value: light1,
        trackColor: trackColor,
      onChanged: (bool value) {
        setState(() {
          light1 = value;
        });
      },
    );
  }
}
