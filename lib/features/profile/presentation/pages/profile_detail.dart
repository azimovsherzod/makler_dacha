import 'package:auto_size_text/auto_size_text.dart';
import '../../../../constans/imports.dart';

class ProfileDetail extends StatefulWidget {
  final DachaModel dacha;
  const ProfileDetail({Key? key, required this.dacha}) : super(key: key);

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? selectedClientTypeId;

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

  // Controllerlar
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneController = TextEditingController();
  final zakladController = TextEditingController(); // Izoh o‘rniga
  final guestCountController = TextEditingController();
  final extraInfoController = TextEditingController();

  double remainingAmount = 0;

  @override
  void initState() {
    super.initState();
    zakladController.addListener(_calculateRemaining);
  }

  void _calculateRemaining() {
    final price = widget.dacha.price ?? 0;
    final zaklad = double.tryParse(zakladController.text) ?? 0;
    setState(() {
      remainingAmount = price - zaklad;
      if (remainingAmount < 0) remainingAmount = 0;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    zakladController.dispose();
    guestCountController.dispose();
    extraInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final imagePath = getImageUrl(widget.dacha.images);
    final addressOptions = (profileProvider.availablePopularPlaces ?? [])
        .map((e) => e['name'] as String)
        .toList();

    if (profileProvider.availableClientTypes.isEmpty) {
      profileProvider.fetchClientTypes();
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (profileProvider.availableFacilities.isEmpty) {
      profileProvider.fetchFacilities();
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (profileProvider.availablePopularPlaces == null) {
      profileProvider.fetchPopularPlaces();
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dacha.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.toNamed(Routes.editPage, arguments: widget.dacha);
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
                        if (widget.dacha.id == null) return;
                        final success =
                            await profileProvider.deleteDacha(widget.dacha.id!);
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
                      color: widget.dacha.isActive ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AutoSizeText(
                      widget.dacha.isActive ? "Bo'sh" : "Band",
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
                  "\$${widget.dacha.price ?? 0}/sutka",
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
                    getPopularPlaceName(
                        widget.dacha.popularPlace, addressOptions),
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
                      icon: LocalIcons.bed,
                      text: "${widget.dacha.bedsCount ?? 0}"),
                  InfoIconWithText(
                      icon: LocalIcons.bath,
                      text: "${widget.dacha.hallCount ?? 0}"),
                ],
              ),
            ),
            const Gap(20),
            buildFacilitiesChips(
                widget.dacha, profileProvider.availableFacilities),
            // const Gap(20),
            // Container(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 25, vertical: 9),
            //   decoration: BoxDecoration(
            //     color: AppColors.primaryColor,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Text(
            //     getClientTypeName(profileProvider, widget.dacha.clientType),
            //     style: const TextStyle(
            //         color: Colors.white, fontWeight: FontWeight.bold),
            //   ),
            // ),
            const Gap(20),
            // Padding(
            //   padding: const EdgeInsets.only(left: 210.0),
            //   child: TextButton(
            //     onPressed: () {
            //       Get.toNamed(Routes.commentsPages, arguments: widget.dacha);
            //     },
            //     child: const Text(
            //       "Hammasini ko'rish",
            //       style: TextStyle(color: AppColors.primaryColor),
            //     ),
            //   ),
            // ),
            // const Gap(12),
            // GestureDetector(
            //   onTap: () {
            //     Get.toNamed(Routes.commentsPages, arguments: widget.dacha);
            //   },
            //   child: Consumer<ProfileProvider>(
            //     builder: (context, provider, child) {
            //       if (provider.comments.isEmpty) {
            //         return const Text("Kommentlar yo'q");
            //       }
            //       return CommentsWidget(comment: provider.comments.first);
            //     },
            //   ),
            // ),
            // const Gap(12),
            // AppButton(
            //   text: "Komment",
            //   onPressed: () {
            //     final TextEditingController commentController =
            //         TextEditingController();
            //     double rating = 0;
            //     String title = "Komment qo'shish";
            //     String hintText = "Komment yozing...";
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return StatefulBuilder(
            //           builder: (context, setState) => AlertDialog(
            //             title: Text(title),
            //             content: SingleChildScrollView(
            //               child: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   TextField(
            //                     controller: commentController,
            //                     decoration: InputDecoration(
            //                       hintText: hintText,
            //                       border: OutlineInputBorder(
            //                         borderRadius: BorderRadius.circular(16.0),
            //                         borderSide: BorderSide(color: Colors.grey),
            //                       ),
            //                       focusedBorder: OutlineInputBorder(
            //                         borderRadius: BorderRadius.circular(16.0),
            //                         borderSide: BorderSide(
            //                             color: Colors.blue, width: 2.0),
            //                       ),
            //                     ),
            //                     maxLines: 5,
            //                   ),
            //                   const Gap(12),
            //                   Padding(
            //                     padding: const EdgeInsets.only(top: 12.0),
            //                     child: AppButton(
            //                       text: "Yuborish",
            //                       width: 300,
            //                       height: 50,
            //                       color: AppColors.primaryColor,
            //                       onPressed: () async {
            //                         if (commentController.text
            //                                 .trim()
            //                                 .isNotEmpty &&
            //                             rating > 0) {
            //                           await Provider.of<ProfileProvider>(
            //                                   context,
            //                                   listen: false)
            //                               .sendDachaComment(
            //                             dachaId: widget.dacha.id,
            //                             comment: commentController.text.trim(),
            //                             userId: widget.dacha.user ?? '',
            //                           );
            //                           await Provider.of<ProfileProvider>(
            //                                   context,
            //                                   listen: false)
            //                               .sendDachaRating(
            //                             dachaId: widget.dacha.id,
            //                             rating: rating.toInt(),
            //                             userId: widget.dacha.user ?? '',
            //                           );

            //                           await Provider.of<ProfileProvider>(
            //                                   context,
            //                                   listen: false)
            //                               .fetchComments();
            //                           setState(() {});
            //                         }
            //                         Navigator.pop(context);
            //                       },
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
            const Gap(12),
            calendarPreviewProfileWithDialog(context),
            const Gap(16),
            _styledField(
                controller: nameController, label: "Ism", icon: Icons.person),
            const Gap(10),
            _styledField(
                controller: surnameController,
                label: "Familiya",
                icon: Icons.person),
            const Gap(10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: phoneController,
                    label: "Phone Number",
                    prefix: '+998 ',
                    maxLength: 12,
                    keyboardType: TextInputType.phone,
                    validators: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 12) {
                        return 'Phone number must be exactly 12 characters';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                      PhoneNumberInputFormatter(),
                    ],
                  ),
                  const Gap(10),
                  _styledField(
                      controller: zakladController,
                      label: "Zaklad",
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number),
                  const Gap(10),
                  _styledField(
                      controller: guestCountController,
                      label: "Mehmonlar soni",
                      icon: Icons.people,
                      keyboardType: TextInputType.number),
                  const Gap(10),
                  _styledField(
                      controller: extraInfoController,
                      label: "Qo'shimcha ma'lumot",
                      icon: Icons.info_outline,
                      maxLines: 2),
                  const Gap(16),
                  _buildDropdown<int>(
                    "Mijoz turi",
                    profileProvider.availableClientTypes
                        .map((type) => DropdownMenuItem<int>(
                              value: type['id'] as int,
                              child: Text(type['name']),
                            ))
                        .toList(),
                    profileProvider.availableClientTypes
                            .any((type) => type['id'] == selectedClientTypeId)
                        ? selectedClientTypeId
                        : null,
                    (value) {
                      setState(() {
                        selectedClientTypeId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) return "Mijoz turini tanlang";
                      return null;
                    },
                  ),
                  const Gap(16),
                  // Qolgan to'lovni ko'rsatish
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColors.primaryColor, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calculate,
                            color: AppColors.primaryColor),
                        const Gap(10),
                        const Text(
                          "Qolgan to'lov: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${remainingAmount.toStringAsFixed(0)} so'm",
                          style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const Gap(12),
                ],
              ),
            ),
            AppButton(
              text: "Saqlash",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _styledField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        iconColor: AppColors.primaryColor,
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}

Widget calendarPreviewProfileWithDialog(BuildContext context) {
  return Stack(
    children: [
      calendarPreviewProfile(),
      Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
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
                            lastDay:
                                DateTime.now().add(const Duration(days: 60)),
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
                              return freeDates.any((d) =>
                                  d.year == day.year &&
                                  d.month == day.month &&
                                  d.day == day.day);
                            },
                            selectedDayPredicate: (day) =>
                                (rangeStart != null &&
                                    isSameDay(day, rangeStart)) ||
                                (rangeEnd != null && isSameDay(day, rangeEnd)),
                            onRangeSelected: (start, end, focusedDay) {
                              setState(() {
                                rangeStart = start;
                                rangeEnd = end;
                              });
                            },
                            onDaySelected: (selectedDay, focusedDay) {},
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
      ),
    ],
  );
}

Widget calendarPreviewProfile() {
  final DateTime firstDay =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  final DateTime lastDay =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  // 7-14 kunlar band (qizil), qolganlari yashil
  return TableCalendar(
    firstDay: firstDay,
    lastDay: lastDay,
    focusedDay: DateTime.now(),
    calendarFormat: CalendarFormat.month,
    calendarBuilders: CalendarBuilders(
      defaultBuilder: (context, day, focusedDay) {
        if (day.day >= 7 && day.day <= 14) {
          // 7-14 kunlar band (qizil)
          return Container(
            width: 40,
            height: 40,
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
        } else {
          // Qolgan kunlar yashil
          return Container(
            width: 40,
            height: 40,
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

Widget _buildDropdown<T>(
  String label,
  List<DropdownMenuItem<T>> items,
  T? selectedValue,
  ValueChanged<T?> onChanged, {
  String? Function(T?)? validator,
}) {
  return DropdownButtonFormField<T>(
    value: selectedValue,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
      ),
    ),
    items: items,
    onChanged: onChanged,
    validator: validator,
  );
}
