import '../../../../constans/imports.dart';

class SearchResultPage extends StatefulWidget {
  final String city;

  const SearchResultPage({super.key, required this.city});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  bool _showMap = false;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${profileProvider.dachas.length} ta dacha topildi",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.filter, arguments: widget.city);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            LocalIcons.filter,
                            height: 20,
                            width: 20,
                            placeholderBuilder: (context) => const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          const Text(
                            "Filter",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(20),
          Expanded(
            child: Stack(
              children: [
                profileProvider.dachas.isEmpty
                    ? const Center(
                        child: Text(
                          "Hozircha hech qanday dacha mavjud emas.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: profileProvider.dachas.length,
                        itemBuilder: (context, index) {
                          final dacha = profileProvider.dachas[index];
                          final addressOptions = profileProvider
                                  .availablePopularPlaces
                                  ?.map((place) {
                                if (place is Map<String, dynamic> &&
                                    place.containsKey('name') &&
                                    place['name'] is String) {
                                  return place['name'] as String;
                                } else {
                                  print(
                                      "❌ Noto'g'ri formatdagi element: $place");
                                  return "Noma'lum joy";
                                }
                              }).toList() ??
                              [];
                          return ListingCard(
                            dacha: dacha,
                            addressOptions: addressOptions,
                          );
                        },
                      ),
                Positioned(
                  bottom: 20,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showMap = !_showMap;
                        print("Show map: $_showMap");
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: AppColors.primaryColor,
                      ),
                      child: SvgPicture.asset(
                        LocalIcons.map,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HorizontalListView extends StatelessWidget {
  const HorizontalListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 250,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          HorizontalListingCard(),
          HorizontalListingCard(),
          HorizontalListingCard(),
          HorizontalListingCard(),
          HorizontalListingCard(),
        ],
      ),
    );
  }
}
