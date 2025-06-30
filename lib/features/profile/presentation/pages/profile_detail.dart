import 'package:auto_size_text/auto_size_text.dart';
import '../../../../constans/imports.dart';

class ProfileDetail extends StatelessWidget {
  final DachaModel dacha;
  const ProfileDetail({Key? key, required this.dacha}) : super(key: key);

  String getClientTypeName(ProfileProvider provider, dynamic id) {
    final clientType = provider.availableClientTypes.firstWhere(
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

    return Wrap(children: chips);
  }

  String getImageUrl(dynamic images) {
    if (images == null || images.isEmpty) {
      return 'https://avatars.mds.yandex.net/i?id=b4801a50e1801125b3173ade9c4a6ffb_l-4948104-images-thumbs&n=13';
    }
    final first = images.first;
    if (first is String) {
      if (first.startsWith('http')) return first;
      if (first.startsWith('/dacha/'))
        return '$domain/images/dacha${first.substring(6)}';
      if (first.startsWith('/images/dacha/')) return '$domain$first';
      if (first.startsWith('/')) return '$domain$first';
      return first;
    }
    if (first is Map && first['image'] != null) {
      final img = first['image'].toString();
      if (img.startsWith('http')) return img;
      if (img.startsWith('/dacha/'))
        return '$domain/images/dacha${img.substring(6)}';
      if (img.startsWith('/images/dacha/')) return '$domain$img';
      if (img.startsWith('/')) return '$domain$img';
      return img;
    }
    return 'https://avatars.mds.yandex.net/i?id=b4801a50e1801125b3173ade9c4a6ffb_l-4948104-images-thumbs&n=13';
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final imagePath = getImageUrl(dacha.images);
    final addressOptions = (profileProvider.availablePopularPlaces ?? [])
        .map((e) => e['name'] as String)
        .toList();

    if (profileProvider.availableClientTypes.isEmpty ||
        profileProvider.availableFacilities.isEmpty ||
        profileProvider.availablePopularPlaces == null ||
        addressOptions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
                builder: (context) => AlertDialog(
                  title: const Text("Dachani o'chirish"),
                  content:
                      const Text("Siz ushbu dachani o'chirishni xohlaysizmi?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Bekor qilish"),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (dacha.id == null) return;
                        final success =
                            await profileProvider.deleteDacha(dacha.id!);
                        if (success) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Dacha o'chirishda xatolik yuz berdi."),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text("O'chirish"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 50, color: Colors.red),
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
                    child: AutoSizeText(
                      dacha.isActive ? "Bo'sh" : "Band",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                  "\$${dacha.price ?? 0}/sutka",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Gap(20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AutoSizeText(
                    getPopularPlaceName(dacha.popularPlace, addressOptions),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoIconWithText(
                      icon: LocalIcons.bed, text: "${dacha.bedsCount ?? 0}"),
                  InfoIconWithText(
                      icon: LocalIcons.bath, text: "${dacha.hallCount ?? 0}"),
                ],
              ),
            ),
            const Gap(20),
            buildFacilitiesChips(dacha, profileProvider.availableFacilities),
            const Gap(20),
            Row(
              children: [
                RatingBar.builder(
                  minRating: 1,
                  direction: Axis.horizontal,
                  ignoreGestures: true,
                  itemCount: 5,
                  itemSize: 22,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (double value) {},
                ),
                const Gap(8),
                const Text('4.5K'),
                const Gap(140),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    getClientTypeName(profileProvider, dacha.clientType),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.only(left: 210.0),
              child: TextButton(
                onPressed: () {
                  Get.toNamed(Routes.commentsPages);
                },
                child: const Text(
                  "Hammasini ko'rish",
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ),
            const Gap(12),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.commentsPages);
              },
              child: Consumer<ProfileProvider>(
                builder: (context, provider, child) {
                  if (provider.comments.isEmpty) {
                    return const Text("Kommentlar yo'q");
                  }
                  return CommentsWidget(comment: provider.comments.first);
                },
              ),
            ),
            const Gap(12),
          ],
        ),
      ),
    );
  }
}
