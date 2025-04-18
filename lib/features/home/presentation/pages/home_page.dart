import '../../../../constans/imports.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> cities = ['Toshkent', 'Chirchiq', 'Xojakent', 'Qoronqul'];
  String selectedCity = 'Toshkent';
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    GroupPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              selectedCity: 'Toshkent',
              cities: ['Toshkent', 'Chirchiq', 'Xojakent', 'Qoronqul'],
              onCityChanged: (newCity) {},
            ),
            const SizedBox(height: 12),
            const CustomSearchContainer(),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                "Yaqin atrofdagi ro'yxatlar",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: const [
                  ListingCard(),
                  ListingCard(),
                  ListingCard(),
                  ListingCard(),
                  ListingCard(),
                  ListingCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
