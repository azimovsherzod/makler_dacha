import 'package:makler_dacha/constans/imports.dart';

class MaklerHomeBodyPage extends StatefulWidget {
  const MaklerHomeBodyPage({super.key});

  @override
  State<MaklerHomeBodyPage> createState() => _MaklerHomeBodyPageState();
}

class _MaklerHomeBodyPageState extends State<MaklerHomeBodyPage> {
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
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;
        final dachas = profileProvider.dachas;

        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final userDachas = dachas
            .where((dacha) =>
                dacha.user != null &&
                profile.id != null &&
                dacha.user.toString() == profile.id.toString())
            .toList();

        final addressOptions =
            profileProvider.availablePopularPlaces.map((place) {
          if (place.containsKey('name') && place['name'] is String) {
            return place['name'] as String;
          } else {
            return "Noma'lum joy";
          }
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: userDachas.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) return Gap(40);
            if (index == 1) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchContainer(),
                  const SizedBox(height: 20),
                  Text(
                    "Bosh dachalar",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }

            final dacha = userDachas[index - 2];
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.editPage, arguments: dacha);
              },
              child: ListingCardProfile(
                dacha: dacha,
                addressOptions: addressOptions,
                profileProvider: profileProvider,
              ),
            );
          },
        );
      },
    );
  }
}
