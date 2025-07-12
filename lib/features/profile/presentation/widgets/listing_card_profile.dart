import '../../../../constans/imports.dart';

class ListingCardProfile extends StatefulWidget {
  final DachaModel dacha;
  final List<String> addressOptions;
  final ProfileProvider profileProvider;

  const ListingCardProfile({
    super.key,
    required this.dacha,
    required this.addressOptions,
    required this.profileProvider,
  });

  @override
  State<ListingCardProfile> createState() => _ListingCardProfileState();
}

class _ListingCardProfileState extends State<ListingCardProfile> {
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
    final clientType = widget.profileProvider.availableClientTypes.firstWhere(
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
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final updatedDacha = widget.profileProvider.dachas.firstWhere(
            (e) => e.id == widget.dacha.id,
            orElse: () => widget.dacha);

        final String name =
            updatedDacha.name.isNotEmpty ? updatedDacha.name : "Noma'lum dacha";
        final bool isActive = updatedDacha.isActive;

        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              print("Card tapped: $name");
              Get.toNamed(Routes.profileDetail, arguments: updatedDacha);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 9),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          getImageUrl(updatedDacha.images),
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
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${updatedDacha.price ?? 0}/sutka",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Gap(12),
                  Text(
                    updatedDacha.description.isNotEmpty
                        ? updatedDacha.description
                        : "Noma'lum dacha",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      InfoIconWithText(
                        icon: LocalIcons.bed,
                        text: "${updatedDacha.bedsCount ?? 0}",
                      ),
                      const Gap(24),
                      InfoIconWithText(
                        icon: LocalIcons.bath,
                        text: "${updatedDacha.hallCount ?? 0}",
                      ),
                    ],
                  ),
                  const Gap(12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
