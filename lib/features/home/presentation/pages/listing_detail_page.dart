import '../../../../constans/imports.dart';

class ListingDetailPage extends StatelessWidget {
  final DachaModel? dacha;

  const ListingDetailPage({super.key, required this.dacha});

  // Qulayliklarni faqat borlarini chiqarish uchun widget
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
                label: Text(
                  facility['name'] ?? '',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.primaryColor,
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
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          dacha?.name ?? "Dacha ma'lumoti",
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Get.toNamed(
                Routes.editPage,
                arguments: dacha,
              );
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
                          print("Dacha ID: ${dacha?.id}");
                          if (dacha?.id == null) {
                            print("❌ Dacha ID null!");
                            return;
                          }

                          final success =
                              await profileProvider.deleteDacha(dacha!.id!);
                          if (success) {
                            Navigator.pop(context); // Dialogni yopish
                            Navigator.pop(context); // Sahifadan chiqish
                          } else {
                            Navigator.pop(context); // Dialogni yopish
                            Get.snackbar(
                              "Xatolik",
                              "Dacha o'chirishda xatolik yuz berdi.",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
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
          physics: BouncingScrollPhysics(),
          children: [
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                if (dacha == null) {
                  return const Center(child: Text("Dacha ma'lumotlari yo'q"));
                }
                return ListingCardCustom(
                  dacha: dacha!,
                );
              },
            ),
            const Gap(12),
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                if (dacha == null) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Qulayliklar:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Gap(4),
                    buildFacilitiesChips(
                        dacha!, profileProvider.availableFacilities),
                  ],
                );
              },
            ),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    RatingBar.builder(
                      minRating: 1,
                      direction: Axis.horizontal,
                      ignoreGestures: true,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
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
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        (profileProvider.availableClientTypes.isNotEmpty &&
                                dacha != null)
                            ? (profileProvider.availableClientTypes.firstWhere(
                                (type) =>
                                    type['id'].toString() ==
                                    dacha?.clientType.toString(),
                                orElse: () => {'name': 'Standart'},
                              )['name'] as String)
                            : 'Noma\'lum',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                child: const Text("Hammasini ko'rish"),
              ),
            ),
            const Gap(12),
            CommentsWidget(),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.only(left: 200.0),
              child: AppButton(
                text: "So'rov yuboring",
                onPressed: () {
                  print("Dacha: $dacha");
                  if (dacha != null) {
                    Navigator.pushNamed(
                      context,
                      Routes.profileDetail,
                      arguments: dacha,
                    );
                  } else {
                    print("Dacha ma'lumotlari mavjud emas.");
                  }
                },
              ),
            ),
            const Gap(50),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(context, dacha),
    );
  }
}

Widget _buildBottomButtons(BuildContext context, DachaModel? dacha) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: _buildDialogButton(
            context,
            "Komment",
            "Komment",
            "Komment",
            dacha, // `dacha`ni uzatish
          ),
        ),
        const Gap(12),
        Flexible(
          flex: 1,
          child: _buildDialogButton(
            context,
            "Shikoyat",
            "Shikoyat",
            "Shikoyat",
            dacha, // `dacha`ni uzatish
          ),
        ),
      ],
    ),
  );
}

Widget _buildDialogButton(BuildContext context, String buttonText, String title,
    String hintText, DachaModel? dacha) {
  return AppButton(
    text: buttonText,
    width: 180,
    height: 50,
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          actions: [
            TextField(
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              maxLines: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: AppButton(
                text: "Yuborish",
                width: 300,
                height: 50,
                color: AppColors.primaryColor,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.profileDetail,
                    arguments: dacha, // `dacha`ni uzatish
                  );
                },
              ),
            )
          ],
        ),
      );
    },
  );
}
