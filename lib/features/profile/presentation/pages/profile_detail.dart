import '../../../../constans/imports.dart';

final profileProvider = ProfileProvider();

class ProfileDetail extends StatelessWidget {
  final DachaModel dacha;
  const ProfileDetail({Key? key, required this.dacha}) : super(key: key);

  String getClientTypeName(dynamic id) {
    final clientType = profileProvider.availableClientTypes.firstWhere(
      (type) => type['id']?.toString() == id?.toString(),
      orElse: () => {"name": "Noma'lum tur"},
    );
    return clientType['name'] as String? ?? "Noma'lum tur";
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
    final imagePath = getImageUrl(dacha.images);

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
                            Navigator.pop(context); // Dialogni yopish
                            Navigator.pop(context); // Sahifadan chiqish
                          } else {
                            Navigator.pop(context); // Dialogni yopish
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
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 50, color: Colors.red);
                },
              ),
            ),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.yellow),
                    Icon(Icons.star, color: Colors.yellow),
                    Icon(Icons.star, color: Colors.yellow),
                    Icon(Icons.star, color: Colors.yellow),
                    Icon(Icons.star, color: Colors.yellow),
                    Gap(8),
                    Text('4.5K'),
                  ],
                ),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                    getClientTypeName(dacha.clientType),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.only(left: 240.0),
              child: TextButton(
                onPressed: () {
                  Get.toNamed(Routes.commentsPages);
                },
                child: const Text("Hammasini ko'rish"),
              ),
            ),
            const Gap(12),
            const CommentsWidget(),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Billiard', style: TextStyle(fontSize: 20)),
                Switch(
                  activeTrackColor: AppColors.primaryColor,
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.white,
                  value: true,
                  onChanged: (_) {},
                ),
              ],
            ),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Karaoke', style: TextStyle(fontSize: 20)),
                Switch(
                  activeTrackColor: AppColors.primaryColor,
                  activeColor: Colors.white,
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.white,
                  value: true,
                  onChanged: (_) {},
                ),
              ],
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
