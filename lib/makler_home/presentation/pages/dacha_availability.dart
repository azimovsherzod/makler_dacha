import 'package:makler_dacha/constans/imports.dart';

class DachaAvailability extends StatefulWidget {
  const DachaAvailability({super.key});

  @override
  State<DachaAvailability> createState() => _DachaAvailabilityState();
}

class _DachaAvailabilityState extends State<DachaAvailability> {
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
      final availableDachas =
          dachas.where((dacha) => dacha.isActive == true).toList();
      final bookedDachas =
          dachas.where((dacha) => dacha.isActive == false).toList();
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
      return DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(24),
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 16),
              child: Text(
                'Dachalar',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const Gap(12),

            // TabBar
            const TabBar(
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryColor,
              tabs: [
                Tab(text: 'Bo‘sh joylar'),
                Tab(text: 'Band joylar'),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  availableDachas.isEmpty
                      ? Center(
                          child: Text('Hozircha bo‘sh dacha yo‘q'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: availableDachas.length,
                          itemBuilder: (context, index) {
                            final dacha = availableDachas[index];
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
                        ),
                  Center(
                    child: Text('Hozircha band dacha yo‘q'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
