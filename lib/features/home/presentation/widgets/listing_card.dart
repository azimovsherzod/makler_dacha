import '../../../../constans/imports.dart';

class ListingCard extends StatelessWidget {
  final DachaModel dacha;
  final List<String> addressOptions;

  const ListingCard({
    Key? key,
    required this.dacha,
    required this.addressOptions,
  }) : super(key: key);

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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 50, color: Colors.red);
                  },
                ),
              ),
              // Dacha nomi chap yuqorida badge ko‘rinishida
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dacha.name ?? "Noma'lum nom",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              // "Bosh" yoki "Band" badge o'ng yuqorida
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (dacha.isActive == true)
                        ? Colors.green.withOpacity(0.85)
                        : Colors.red.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (dacha.isActive == true) ? "Bosh" : "Band",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Text(
            "\$${dacha.price}/sutkasi",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Gap(8),
          Text(
            getPopularPlaceName(dacha.popularPlace, addressOptions),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
