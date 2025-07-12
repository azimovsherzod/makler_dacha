import '../../../../constans/imports.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    final profileProvider = Provider.of<ProfileProvider>(context);
    String getClientTypeName(dynamic id) {
      final clientType = profileProvider.availableClientTypes.firstWhere(
        (type) => type['id']?.toString() == id?.toString(),
        orElse: () => {"name": "Noma'lum"},
      );
      return clientType['name'] as String? ?? "Noma'lum tur";
    }

    String getPopularPlaceName(dynamic id, List<String> addressOptions) {
      int? index;
      if (id == null) return "Noma'lum joy";
      if (id is int) {
        index = id;
      } else if (id is String) {
        index = int.tryParse(id);
      }
      if (index != null && index > 0 && index <= addressOptions.length) {
        return addressOptions[index - 1];
      }
      return "Noma'lum joy";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              profileProvider.logout().then((_) {
                Get.offAllNamed(Routes.loginPage);
              });
            },
            icon: Icon(Icons.logout_outlined),
            style: ButtonStyle(iconSize: MaterialStateProperty.all(25)),
          )
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final profile = profileProvider.profile;
          final dachas = profileProvider.dachas;

          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // final userDachas = dachas
          //     .where((dacha) =>
          //         dacha.user != null &&
          //         profile.id != null &&
          //         dacha.user.toString() == profile.id.toString())
          //     .toList();

          return ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(LocalImages.person2, height: 150, width: 150),
                    const Text("Makler", style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              const Gap(12),
              ProfileInfoItem(value: profile.name, label: "Name"),
              ProfileInfoItem(value: profile.surname, label: "Surname"),
              ProfileInfoItem(value: profile.phone, label: "Number"),
              const Gap(12),
              Column(
                children: [
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemCount: userDachas.length,
                  //   itemBuilder: (context, index) {
                  //     final dacha = userDachas[index];
                  //     final addressOptions =
                  //         profileProvider.availablePopularPlaces.map((place) {
                  //       if (place is Map<String, dynamic> &&
                  //           place.containsKey('name') &&
                  //           place['name'] is String) {
                  //         return place['name'] as String;
                  //       } else {
                  //         print("❌ Noto'g'ri formatdagi element: $place");
                  //         return "Noma'lum joy";
                  //       }
                  //     }).toList();
                  //     return GestureDetector(
                  //       onTap: () {
                  //         print("✅ Выбрана дача: ${dacha.toJson()}");
                  //         Get.toNamed(Routes.editPage, arguments: dacha);
                  //       },
                  //       child: ListingCardProfile(
                  //         dacha: dacha,
                  //         addressOptions: addressOptions,
                  //         profileProvider: profileProvider,
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
