import 'package:makler_dacha/constans/imports.dart';
import 'package:makler_dacha/makler_home/presentation/pages/dacha_availability.dart';

class MaklerHome extends StatefulWidget {
  const MaklerHome({super.key});

  @override
  State<MaklerHome> createState() => _MaklerHomeState();
}

class _MaklerHomeState extends State<MaklerHome> {
  int _selectedIndex = 0;

  static final List<Widget> _screenList = [
    MaklerHomeBodyPage(),
    DachaAvailability(),
    CreateDachaPage(),
    ProfilePage(),
  ];
  @override
  void initState() {
    super.initState();
    final accessToken = Hive.box('profileBox').get('access_token');
    if (accessToken != null && accessToken.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<ProfileProvider>();
        provider.initProfile();
        provider.profileDachas();
        provider.fetchClientTypes();
        provider.fetchPopularPlaces();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screenList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: List.generate(4, (index) {
          final icons = [
            'assets/icons/li_home.svg',
            'assets/icons/home2.svg',
            'assets/icons/plus2.svg',
            'assets/icons/li_user.svg',
          ];

          final isSelected = _selectedIndex == index;

          return BottomNavigationBarItem(
            label: '',
            icon: Container(
              decoration: isSelected
                  ? BoxDecoration(
                      color: const Color.fromARGB(198, 39, 79, 153),
                      shape: BoxShape.circle,
                    )
                  : null,
              child: SvgPicture.asset(
                icons[index],
                width: 24,
                height: 24,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          );
        }),
      ),
    );
  }
}
