import '../../../../constans/imports.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.listingDetailPage),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: const AutoScrollingImageWidget(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$450/sutkasi",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "4517 Vashington Ave. Manchester, Kentukki 39495",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoIconWithText(
                    icon: LocalIcons.bed,
                    text: "3",
                  ),
                  InfoIconWithText(
                    icon: LocalIcons.bath,
                    text: "2",
                  ),
                  InfoIconWithText(
                    icon: LocalIcons.size,
                    text: "1200 sqft",
                  ),
                  InfoIconWithText(
                    icon: LocalIcons.car,
                    text: "2",
                  ),
                ],
              ),
            ),
            const Gap(12),
          ],
        ),
      ),
    );
  }
}
