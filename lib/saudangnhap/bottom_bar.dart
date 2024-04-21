import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/saudangnhap/purchase/order_fragment.dart';
import 'package:lunalovegood/user_preferences/current_user.dart';

import 'Account/Profile_page.dart';
import 'Favorite/whishlist.dart';
import 'home_page_second.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({
    super.key,
  });

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  bool _showBottomNavigationBar = true;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomePage(),
      const FavouriteScreen(),
      OrderFragmentScreen(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          _rememberCurrentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: _widgetOptions[_selectedIndex],
                ),
                if (_showBottomNavigationBar)
                  BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    unselectedItemColor: Colors.grey,
                    type: BottomNavigationBarType.fixed,
                    unselectedLabelStyle: const TextStyle(color: Colors.grey),
                    items: const [
                      BottomNavigationBarItem(
                        icon: _IconWidget(icon: 'assets/home.svg'),
                        activeIcon: _IconWidget(icon: 'assets/d_home.svg'),
                        label: 'Trang chủ',
                      ),
                      BottomNavigationBarItem(
                        activeIcon: _IconWidget(icon: 'assets/d_heart.svg'),
                        icon: _IconWidget(icon: 'assets/heart.svg'),
                        label: 'Yêu thích',
                      ),
                      BottomNavigationBarItem(
                        activeIcon: _IconWidget(icon: 'assets/d_shop.svg'),
                        icon: _IconWidget(icon: 'assets/shop.svg'),
                        label: 'Đơn hàng',
                      ),
                      BottomNavigationBarItem(
                        activeIcon: _IconWidget(icon: 'assets/d_account.svg'),
                        icon: _IconWidget(icon: 'assets/account.svg'),
                        label: 'Tài khoản',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: const Color(0xFF000000),
                    selectedFontSize: 15,
                    unselectedFontSize: 15,
                    onTap: _onItemTapped,
                  ),
              ],
            ),
          );
        });
  }
}

class _IconWidget extends StatelessWidget {
  const _IconWidget({Key? key, required this.icon}) : super(key: key);
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 5,
        ),
        SvgPicture.asset(
          icon,
          width: 25,
          height: 25,
        ),
      ],
    );
  }
}
