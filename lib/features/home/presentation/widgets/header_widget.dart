import 'package:auto_size_text/auto_size_text.dart';

import '../../../../constans/imports.dart';

class HeaderWidget extends StatelessWidget {
  final List<String> popularPlaces;
  final String? selectedPopularPlace;
  final ValueChanged<String?> onPopularPlaceChanged;

  const HeaderWidget({
    super.key,
    required this.popularPlaces,
    required this.selectedPopularPlace,
    required this.onPopularPlaceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(Routes.profilePage),
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
                  child: Image.asset(LocalImages.person,
                      width: 50, height: 50, fit: BoxFit.cover),
                ),
              ),
            ),
            const Gap(10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showPopularPlacePicker(context);
                },
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.place, color: AppColors.primaryColor),
                      const SizedBox(width: 10),
                      const Gap(20),
                      Expanded(
                        child: AutoSizeText(
                          selectedPopularPlace ?? "Mashhur joy",
                          style: TextStyle(
                            fontSize: 18,
                            color: selectedPopularPlace == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(10),
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

  void _showPopularPlacePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  "Mashhur joyni tanlang",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: popularPlaces.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final place = popularPlaces[index];
                      return ListTile(
                        title: Text(place),
                        trailing: place == selectedPopularPlace
                            ? Icon(Icons.check, color: AppColors.primaryColor)
                            : null,
                        onTap: () {
                          onPopularPlaceChanged(place);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
