import '../../../../constans/imports.dart';

class ListingCardProfile extends StatelessWidget {
  final DachaModel dacha;
  final List<String> addressOptions;
  final ProfileProvider profileProvider;

  const ListingCardProfile({
    super.key,
    required this.dacha,
    required this.addressOptions,
    required this.profileProvider,
  });

  String getImageUrl(dynamic images) {
    if (images == null || images.isEmpty) {
      return 'https://avatars.mds.yandex.net/i?id=b4801a50e1801125b3173ade9c4a6ffb_l-4948104-images-thumbs&n=13';
    }
    final first = images.first;
    if (first is String) {
      if (first.startsWith('http')) return first;
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

  Widget buildFacilitiesChips(
      DachaModel dacha, List<Map<String, dynamic>> availableFacilities) {
    final dachaFacilities =
        dacha.facilities?.map((e) => e.toString()).toSet() ?? {};

    final chips = availableFacilities
        .where(
            (facility) => dachaFacilities.contains(facility['id'].toString()))
        .map((facility) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Chip(
                label: Text(facility['name'] ?? ''),
                backgroundColor: Colors.blue.shade50,
                labelStyle: const TextStyle(color: Colors.black),
              ),
            ))
        .toList();

    if (chips.isEmpty) {
      return const Text("Qulayliklar yo'q");
    }

    return Wrap(
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name = dacha.name.isNotEmpty ? dacha.name : "Noma'lum dacha";
    final bool isActive = dacha.isActive;
    final String image = (dacha.images != null && dacha.images.isNotEmpty)
        ? dacha.images.first
        : LocalImages.errorImage;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          print("Card tapped: $name");
          Get.toNamed(Routes.profileDetail, arguments: dacha);
        },
        child: Container(
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
                      getImageUrl(dacha.images),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          LocalImages.errorImage,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  // Dacha nomi badge chap yuqorida
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // "Bo'sh"/"Band" badge o'ng yuqorida
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isActive ? "Bo'sh" : "Band",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Narx va joy badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${dacha.price ?? 0}/sutka",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      getPopularPlaceName(dacha.popularPlace, addressOptions),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              // Client type badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  getClientTypeName(dacha.clientType),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(12),

              Row(
                children: [
                  RatingBar.builder(
                    minRating: 1,
                    direction: Axis.horizontal,
                    ignoreGestures: true,
                    itemCount: 5,
                    itemSize: 22,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (double value) {},
                  ),
                  const Gap(8),
                  const Text('4.5K'),
                ],
              ),
              const Gap(12),
              // Yotoq va zal soni
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InfoIconWithText(
                      icon: LocalIcons.bed,
                      text: "${dacha.bedsCount ?? 0}",
                    ),
                    InfoIconWithText(
                      icon: LocalIcons.bath,
                      text: "${dacha.hallCount ?? 0}",
                    ),
                  ],
                ),
              ),
              const Gap(12),
            ],
          ),
        ),
      ),
    );
  }
}
