import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../constans/imports.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    // Ma'lumotlarni birinchi yuklash
    Future.microtask(() =>
        Provider.of<ProfileProvider>(context, listen: false).fetchAllData());
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
      body: SafeArea(
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: () async {
            await profileProvider.fetchAllData();
            _refreshController.refreshCompleted();
          },
          header: WaterDropHeader(
            waterDropColor: AppColors.primaryColor,
            complete: Icon(Icons.check, color: AppColors.primaryColor),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              HeaderWidget(
                selectedCity: 'Toshkent',
                cities: ['Toshkent', 'Chirchiq', 'Xojakent', 'Qoronqul'],
                onCityChanged: (newCity) {},
              ),
              const Gap(12),
              const CustomSearchContainer(),
              const Gap(12),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  "Yaqin atrofdagi ro'yxatlar",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const Gap(8),
              (profileProvider.dachas.isEmpty ||
                      profileProvider.availablePopularPlaces == null)
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileProvider.dachas.length,
                      itemBuilder: (context, index) {
                        final dacha = profileProvider.dachas[index];
                        final places =
                            profileProvider.availablePopularPlaces ?? [];

                        String popularPlaceName = "Noma'lum joy";
                        if (dacha.popularPlace != null &&
                            dacha.popularPlace is int &&
                            dacha.popularPlace > 0 &&
                            dacha.popularPlace <= places.length) {
                          final place = places[dacha.popularPlace - 1];
                          if (place is Map<String, dynamic> &&
                              place['name'] is String) {
                            popularPlaceName = place['name'] as String;
                          }
                        }

                        String clientTypeText =
                            getClientTypeName(dacha.clientType);

                        final addressOptions = [
                          "$popularPlaceName • $clientTypeText"
                        ];

                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.listingDetailPage,
                                arguments: dacha);
                          },
                          child: ListingCard(
                            dacha: dacha,
                            addressOptions: addressOptions,
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
