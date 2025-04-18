import '../../../../constans/imports.dart';

class SearchResultPage extends StatefulWidget {
  final String city;

  const SearchResultPage({super.key, required this.city});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  bool _showMap = false;
  // final MapObjectId markerId = MapObjectId('marker');
  // late YandexMapController mapController;

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  "1800 ta dacha topildi ",
                  style: TextStyle(
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
                ListView(
                  children: const [
                    ListingCard(),
                    ListingCard(),
                    ListingCard(),
                  ],
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
