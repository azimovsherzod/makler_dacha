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

  Widget calendarPreview() {
    // Example implementation: show all days as available (green)
    final DateTime firstDay =
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    final DateTime lastDay =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.red),
      ),
      enabledDayPredicate: (_) => true,
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
        actions: [],
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
            Text("Bo'sh kunlar:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black)),
            const Gap(8),
            calendarPreview(),
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
                onPressed: () async {
                  final List<DateTime> freeDates = [
                    DateTime(2025, 7, 12),
                    DateTime(2025, 7, 13),
                    DateTime(2025, 7, 15),
                    DateTime(2025, 7, 16),
                    DateTime(2025, 7, 17),
                    DateTime(2025, 7, 18),
                  ];
                  final List<DateTime> busyDates = [
                    DateTime(2025, 7, 14),
                    DateTime(2025, 7, 19),
                  ];

                  DateTime? rangeStart;
                  DateTime? rangeEnd;

                  await showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: const Text("Bo'sh kunlarni tanlang"),
                            content: SizedBox(
                              width: 500,
                              height: 400,
                              child: TableCalendar(
                                firstDay: DateTime.now(),
                                lastDay: DateTime.now()
                                    .add(const Duration(days: 60)),
                                focusedDay: rangeStart ?? DateTime.now(),
                                calendarFormat: CalendarFormat.month,
                                rangeStartDay: rangeStart,
                                rangeEndDay: rangeEnd,
                                availableCalendarFormats: const {
                                  CalendarFormat.month: 'Oy'
                                },
                                calendarStyle: CalendarStyle(
                                  rangeStartDecoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  rangeEndDecoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  withinRangeDecoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  disabledTextStyle:
                                      const TextStyle(color: Colors.red),
                                  todayDecoration: BoxDecoration(
                                    color: Colors.blue.shade200,
                                    shape: BoxShape.circle,
                                  ),
                                  selectedDecoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  outsideDaysVisible: false,
                                ),
                                enabledDayPredicate: (day) {
                                  // Faqat freeDates ichida bo‘lsa tanlanadi
                                  return freeDates.any((d) =>
                                      d.year == day.year &&
                                      d.month == day.month &&
                                      d.day == day.day);
                                },
                                selectedDayPredicate: (day) =>
                                    (rangeStart != null &&
                                        isSameDay(day, rangeStart)) ||
                                    (rangeEnd != null &&
                                        isSameDay(day, rangeEnd)),
                                onRangeSelected: (start, end, focusedDay) {
                                  setState(() {
                                    rangeStart = start;
                                    rangeEnd = end;
                                  });
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  // Faqat range tanlash uchun ishlatilmaydi
                                },
                                rangeSelectionMode: RangeSelectionMode.enforced,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Bekor qilish"),
                              ),
                              AppButton(
                                  onPressed:
                                      (rangeStart != null && rangeEnd != null)
                                          ? () {
                                              print(
                                                  "Tanlangan oraliq: $rangeStart - $rangeEnd");
                                              Navigator.pop(context);
                                            }
                                          : null,
                                  text: "Tasdiqlash"),
                            ],
                          );
                        },
                      );
                    },
                  );
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

Widget calendarPreview() {
  final DateTime firstDay =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  final DateTime lastDay =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  final List<DateTime> freeDates = [
    DateTime(DateTime.now().year, DateTime.now().month, 5),
    DateTime(DateTime.now().year, DateTime.now().month, 8),
    DateTime(DateTime.now().year, DateTime.now().month, 12),
    DateTime(DateTime.now().year, DateTime.now().month, 15),
    DateTime(DateTime.now().year, DateTime.now().month, 18),
  ];
  final List<DateTime> busyDates = [
    DateTime(DateTime.now().year, DateTime.now().month, 7),
    DateTime(DateTime.now().year, DateTime.now().month, 9),
    DateTime(DateTime.now().year, DateTime.now().month, 14),
    DateTime(DateTime.now().year, DateTime.now().month, 19),
  ];

  return TableCalendar(
    firstDay: firstDay,
    lastDay: lastDay,
    focusedDay: DateTime.now(),
    calendarFormat: CalendarFormat.month,
    calendarBuilders: CalendarBuilders(
      defaultBuilder: (context, day, focusedDay) {
        final isFree = freeDates.any((d) =>
            d.year == day.year && d.month == day.month && d.day == day.day);
        final isBusy = busyDates.any((d) =>
            d.year == day.year && d.month == day.month && d.day == day.day);
        if (isBusy) {
          return Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          );
        }
        if (isFree) {
          return Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          );
        }
        return null;
      },
    ),
    headerStyle: const HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
    ),
    daysOfWeekStyle: const DaysOfWeekStyle(
      weekendStyle: TextStyle(color: Colors.red),
    ),
  );
}
