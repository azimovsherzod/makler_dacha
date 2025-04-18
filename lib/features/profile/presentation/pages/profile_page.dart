import '../../../../constans/imports.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Box box;

  @override
  void initState() {
    super.initState();

    // Box ochilganligini tekshirish va ochish
    if (!Hive.isBoxOpen('profileBox')) {
      Hive.openBox('profileBox').then((openedBox) {
        setState(() {
          box = openedBox;
        });
        print("📦 Данные в box: ${box.get('access_token')}");
        print("📦 user_id из box: ${box.get('user_id')}");
        Provider.of<ProfileProvider>(context, listen: false).initProfile();
      }).catchError((error) {
        print("❌ Hive box ochishda xatolik: $error");
      });
    } else {
      box = Hive.box('profileBox');
      print("📦 Данные в box: ${box.get('access_token')}");
      print("📦 user_id из box: ${box.get('user_id')}");
      Provider.of<ProfileProvider>(context, listen: false).initProfile();
    }
  }

  void _logout() {
    box.delete('access_token');
    box.delete('user_id');

    Get.offAllNamed(Routes.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    if (!Hive.isBoxOpen('profileBox')) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final profile = profileProvider.profile;
          final dachas = profileProvider.dachas;

          return profile == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(12.0),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset(LocalImages.person2,
                              height: 150, width: 150),
                          const Text("Makler", style: TextStyle(fontSize: 24)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProfileInfoItem(value: profile.name, label: "Name"),
                    ProfileInfoItem(value: profile.surname, label: "Surname"),
                    ProfileInfoItem(value: profile.phone, label: "Number"),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Dachalar ro'yxati",
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                Get.toNamed(Routes.editPage);
                              },
                            ),
                          ],
                        ),
                        ...dachas
                            .map((dacha) => GestureDetector(
                                  onTap: () {
                                    final profileProvider =
                                        Provider.of<ProfileProvider>(context,
                                            listen: false);
                                    profileProvider.setSelectedDacha(dacha);
                                    print("✅ Выбрана дача: ${dacha.toJson()}");
                                    Get.toNamed(Routes.editPage,
                                        arguments: dacha);
                                  },
                                  child: ListingCardProfile(
                                      dacha: dacha, addressOptions: []),
                                ))
                            .toList(),
                      ],
                    ),
                    const Gap(12),
                    AppButton(
                      text: "Logout",
                      onPressed: _logout,
                    ),
                  ],
                );
        },
      ),
    );
  }
}
