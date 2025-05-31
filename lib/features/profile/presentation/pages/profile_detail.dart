import '../../../../constans/imports.dart';

class ProfileDetail extends StatelessWidget {
  final DachaModel dacha;
  final ProfileProvider profileProvider;
  const ProfileDetail(
      {Key? key, required this.dacha, required this.profileProvider})
      : super(key: key);

  String getClientTypeName(dynamic id) {
    final clientType = profileProvider.availableClientTypes.firstWhere(
      (type) => type['id']?.toString() == id?.toString(),
      orElse: () => {"name": "Noma'lum tur"},
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

  @override
  Widget build(BuildContext context) {
    final imagePath = getImageUrl(dacha.images);
    final addressOptions = profileProvider.availablePopularPlaces
            ?.map((e) => e['name'] as String)
            .toList() ??
        [];

    // Ma'lumotlar yuklanmagan bo'lsa, loading ko'rsatish
    if (profileProvider.availableClientTypes.isEmpty ||
        profileProvider.availableFacilities.isEmpty ||
        profileProvider.availablePopularPlaces == null ||
        addressOptions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dacha.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.toNamed(Routes.editPage, arguments: dacha);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Dachani o'chirish"),
                    content: const Text(
                        "Siz ushbu dachani o'chirishni xohlaysizmi?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Bekor qilish"),
                      ),
                      TextButton(
                        onPressed: () async {
                          print("Dacha ID: ${dacha.id}");
                          if (dacha.id == null) {
                            print("❌ Dacha ID null!");
                            return;
                          }
                          final success =
                              await profileProvider.deleteDacha(dacha.id!);
                          if (success) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Dacha o'chirishda xatolik yuz berdi."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: const Text("O'chirish"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // Rasm, nomi, "Bo'sh"/"Band" badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error,
                          size: 50, color: Colors.red);
                    },
                  ),
                ),
                // Dacha nomi badge chap yuqorida
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      dacha.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: dacha.isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      dacha.isActive ? "Bo'sh" : "Band",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            // Qulayliklar chipslari
            buildFacilitiesChips(dacha, profileProvider.availableFacilities),
            const Gap(12),
            // Yulduzcha reyting va boshqa info
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
            // Yotoq, zal, вес va кол-во badge'lari
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
            Padding(
              padding: const EdgeInsets.only(left: 200.0),
              child: SizedBox(
                width: 150,
                height: 50,
                child: AppButton(
                  text: "So'rov yuboring",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
