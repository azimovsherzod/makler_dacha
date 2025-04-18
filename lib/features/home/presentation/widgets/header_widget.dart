import '../../../../constans/imports.dart';

class HeaderWidget extends StatelessWidget {
  final String selectedCity;
  final List<String> cities;
  final ValueChanged<String> onCityChanged;

  const HeaderWidget({
    super.key,
    required this.selectedCity,
    required this.cities,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.profilePage);
              },
              child: Image.asset(
                LocalImages.person,
                height: 40,
                width: 40,
              ),
            ),
            const Gap(20),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showCityPicker(context);
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        LocalIcons.location,
                        height: 24,
                        width: 24,
                        color: Colors.blue,
                      ),
                      Gap(10),
                      Expanded(
                        child: Text(
                          selectedCity,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {},
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 24,
                      ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(15),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.notificationPage),
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(LocalIcons.notification),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCityPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: cities.length,
          itemBuilder: (context, index) {
            String city = cities[index];
            return ListTile(
              title: Text(city),
              onTap: () {
                onCityChanged(city);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
