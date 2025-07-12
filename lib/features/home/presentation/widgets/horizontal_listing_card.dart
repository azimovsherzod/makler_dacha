import '../../../../constans/imports.dart';

class HorizontalListingCard extends StatelessWidget {
  const HorizontalListingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                LocalImages.dachaImg,
                width: 120,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 100),
              ),
            ),
            const Gap(12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$450/sutkasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Gap(8),
                  Text(
                    "4517 Vashington Ave. Manchester, Kentukki 39495",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InfoIconWithText(
                        icon: LocalIcons.bed,
                        text: "3",
                      ),
                      Gap(8),
                      InfoIconWithText(
                        icon: LocalIcons.bath,
                        text: "2",
                      ),
                      Gap(8),
                      InfoIconWithText(
                        icon: LocalIcons.size,
                        text: "1200 sqft",
                      ),
                      Gap(8),
                      InfoIconWithText(
                        icon: LocalIcons.car,
                        text: "2",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
