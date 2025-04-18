import 'package:makler_dacha/features/group/presentation/pages/info_page.dart';

import '../../../../constans/imports.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static final List<Widget> _screenList = <Widget>[
    const HomePage(),
    const InfoPage(),
    const ProfilePage(),
  ];

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        fixedColor: Colors.black,
        onTap: onItemTap,
        items: [
          BottomNavigationBarItem(
            label: 'Favourite',
            icon: SvgPicture.asset(
              LocalIcons.heart,
              width: 30,
              theme: SvgTheme(currentColor: AppColors.primaryColor),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Group',
            icon: SvgPicture.asset(
              LocalIcons.human,
              width: 30,
              theme: SvgTheme(currentColor: AppColors.primaryColor),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.person,
              size: 30,
            ),
          ),
        ],
      ),

      // Container(
      //   width: double.infinity,
      //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       IconButton(
      //         onPressed: () {},
      //         icon: SvgPicture.asset(
      //           LocalIcons.heart,
      //           width: 30,
      //           color: AppColors.primaryColor,
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () => Get.toNamed(Routes.groupPage),
      //         child: SvgPicture.asset(
      //           LocalIcons.human,
      //           width: 30,
      //           color: AppColors.primaryColor,
      //         ),
      //       ),
      //       IconButton(
      //         onPressed: () {
      //           Get.toNamed(Routes.profilePage);
      //         },
      //         icon: Icon(
      //           Icons.person,
      //           size: 30,
      //           color: AppColors.primaryColor,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
