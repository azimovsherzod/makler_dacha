import '../../../../constans/imports.dart';

class ListingCardCustom extends StatelessWidget {
  final DachaModel dacha;

  const ListingCardCustom({Key? key, required this.dacha}) : super(key: key);

  String getImageUrl(dynamic images) {
    if (images == null || images.isEmpty) {
      return 'https://avatars.mds.yandex.net/i?id=b4801a50e1801125b3173ade9c4a6ffb_l-4948104-images-thumbs&n=13';
    }
    final first = images.first;
    if (first is String) {
      if (first.startsWith('http')) return first;
      // Agar "/dacha/" bilan boshlansa, "/images/dacha/" ga almashtiramiz
      if (first.startsWith('/dacha/')) {
        return '$domain/images/dacha${first.substring(6)}';
      }
      if (first.startsWith('/images/dacha/')) {
        return '$domain$first';
      }
      if (first.startsWith('/')) return '$domain$first';
      return first;
    }
    if (first is Map && first['image'] != null) {
      final img = first['image'].toString();
      if (img.startsWith('http')) return img;
      if (img.startsWith('/dacha/')) {
        return '$domain/images/dacha${img.substring(6)}';
      }
      if (img.startsWith('/images/dacha/')) {
        return '$domain$img';
      }
      if (img.startsWith('/')) return '$domain$img';
      return img;
    }
    return 'https://avatars.mds.yandex.net/i?id=b4801a50e1801125b3173ade9c4a6ffb_l-4948104-images-thumbs&n=13';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = getImageUrl(dacha.images);

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
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image,
                              size: 50, color: Colors.red);
                        },
                      )
                    : Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image,
                              size: 50, color: Colors.red);
                        },
                      ),
              ),
            ),
          ),
          Column(
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
        ],
      ),
    );
  }
}
