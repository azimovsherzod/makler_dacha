import 'package:auto_size_text/auto_size_text.dart';
import '../../../../constans/imports.dart';

class ListingDetailPage extends StatelessWidget {
  final DachaModel? dacha;

  const ListingDetailPage({super.key, required this.dacha});

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
        title: AutoSizeText(
          dacha?.name ?? "Dacha ma'lumoti",
          overflow: TextOverflow.ellipsis,
        ),
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
                    const AutoSizeText(
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
                      allowHalfRating: false,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (double value) {
                        Provider.of<ProfileProvider>(context, listen: false)
                            .sendDachaRating(
                          dachaId: dacha!.id,
                          rating: value.toInt(),
                          userId: dacha?.user ?? '',
                        );
                      },
                    ),
                    const Gap(8),
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
                      child: AutoSizeText(
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
                  if (dacha != null) {
                    Get.toNamed(Routes.commentsPages, arguments: dacha);
                  }
                },
                child: const Text("Hammasini ko'rish"),
              ),
            ),
            const Gap(12),
            GestureDetector(
              onTap: () {
                if (dacha != null) {
                  Get.toNamed(Routes.commentsPages, arguments: dacha);
                }
              },
              child: Consumer<ProfileProvider>(
                builder: (context, provider, child) {
                  final comments = provider.comments
                      .where((c) => c.dacha.toString() == dacha?.id.toString())
                      .toList();
                  if (comments.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("Kommentlar yo'q"),
                    );
                  }
                  // Faqat birinchi kommentni ko‘rsatamiz
                  final comment = comments.first;
                  return CommentsWidget(comment: comment);
                },
              ),
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.only(left: 200.0),
              child: AppButton(
                text: "So'rov yuboring",
                onPressed: () {
                  print("Dacha: $dacha");
                  if (dacha != null) {
                    Navigator.pop(context);
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
    padding: const EdgeInsets.fromLTRB(12, 0, 12, 22),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildDialogButton(
            context,
            "Komment",
            "Komment",
            "Komment",
            dacha,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDialogButton(BuildContext context, String buttonText, String title,
    String hintText, DachaModel? dacha) {
  final commentController = TextEditingController();
  double rating = 0;

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
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                      maxLines: 5,
                    ),
                    const Gap(12),
                    RatingBar.builder(
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      allowHalfRating: true,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (double value) {
                        setState(() {
                          rating = value;
                        });
                      },
                    ),
                    const Gap(12),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: AppButton(
                        text: "Yuborish",
                        width: 300,
                        height: 50,
                        color: AppColors.primaryColor,
                        onPressed: () async {
                          if (dacha != null &&
                              commentController.text.trim().isNotEmpty &&
                              rating > 0) {
                            await Provider.of<ProfileProvider>(context,
                                    listen: false)
                                .sendDachaComment(
                              dachaId: dacha.id,
                              comment: commentController.text.trim(),
                              userId: dacha.user ?? '',
                            );
                            await Provider.of<ProfileProvider>(context,
                                    listen: false)
                                .sendDachaRating(
                              dachaId: dacha.id,
                              rating: rating.toInt(),
                              userId: dacha.user ?? '',
                            );
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
