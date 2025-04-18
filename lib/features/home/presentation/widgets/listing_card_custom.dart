import '../../../../constans/imports.dart';

class ListingCardCustom extends StatelessWidget {
  final DachaModel dacha;

  const ListingCardCustom({Key? key, required this.dacha}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (dacha.images.isNotEmpty) {
                Get.toNamed(Routes.imageViewerPage, arguments: dacha.images);
              } else {
                print("❌ Нет изображений для отображения");
              }
            },
            child: SizedBox(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: dacha.images.isNotEmpty
                    ? Image.network(
                        dacha.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(LocalImages.error_image,
                              fit: BoxFit.cover);
                        },
                      )
                    : Image.asset(LocalImages.error_image, fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dacha.price != null ? "\$${dacha.price}" : "Цена не указана",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  dacha.address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
