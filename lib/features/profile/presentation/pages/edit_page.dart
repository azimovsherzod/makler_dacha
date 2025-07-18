import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:makler_dacha/constans/imports.dart';

class EditPage extends StatefulWidget {
  final DachaModel dacha;

  const EditPage({Key? key, required this.dacha}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController phoneController;
  late TextEditingController hallCountController;
  late TextEditingController bedsCountController;
  late TextEditingController transactionTypeController;
  late Box<dynamic> box;
  String? selectedViloyat;
  String? selectedTuman;
  int? selectedPopularPlace;
  int? selectedClientTypeId;
  String? selectedPropertyType;
  List<int> selectedFacilities = [];
  late bool isActive;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.dacha.name);
    priceController = TextEditingController(
        text: widget.dacha.price != null && widget.dacha.price != 0
            ? widget.dacha.price.toString()
            : '');
    descriptionController =
        TextEditingController(text: widget.dacha.description);
    phoneController = TextEditingController(text: widget.dacha.phone);
    hallCountController = TextEditingController(
        text: widget.dacha.hallCount != null && widget.dacha.hallCount != 0
            ? widget.dacha.hallCount.toString()
            : '');
    bedsCountController = TextEditingController(
        text: widget.dacha.bedsCount != null && widget.dacha.bedsCount != 0
            ? widget.dacha.bedsCount.toString()
            : '');
    transactionTypeController =
        TextEditingController(text: widget.dacha.transactionType);

    selectedFacilities = List<int>.from(widget.dacha.facilities ?? []);

    isActive = widget.dacha.isActive;

    selectedPopularPlace =
        int.tryParse(widget.dacha.popularPlace?.toString() ?? '');
    selectedClientTypeId = widget.dacha.clientType is int
        ? widget.dacha.clientType
        : int.tryParse(widget.dacha.clientType?.toString() ?? '');

    selectedPropertyType = widget.dacha.propertyType;

    if (!Hive.isBoxOpen('profileBox')) {
      Hive.openBox('profileBox').then((openedBox) {
        setState(() {
          box = openedBox;
        });
      }).catchError((error) {
        print("❌ Hive box ochishda xatolik: $error");
      });
    } else {
      box = Hive.box('profileBox');
    }

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    profileProvider.fetchRegions();
    profileProvider.fetchClientTypes();
    profileProvider.fetchFacilities();
  }

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        widget.dacha.images ??= [];
        final qoldiq = 3 - widget.dacha.images!.length;
        widget.dacha.images!.addAll(
          pickedImages.take(qoldiq).map((e) => e.path),
        );
      });
    } else {
      Get.snackbar(
        "Xatolik",
        'Xatolik: #rasmlar tanlanmadi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Dachani tahrirlash')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                nameController,
                'Dacha nomi',
                TextInputType.text,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Dacha nomini kiriting';
                  }
                  return null;
                },
              ),
              const Gap(12),
              _buildTextField(
                priceController,
                'Narxi',
                TextInputType.number,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Narxni kiriting';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Faqat raqam kiriting';
                  }
                  return null;
                },
              ),
              const Gap(12),
              _buildTextField(
                descriptionController,
                'Tavsif',
                TextInputType.text,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tavsifni kiriting';
                  }
                  return null;
                },
              ),
              const Gap(12),
              _buildTextField(
                phoneController,
                'Telefon raqami',
                TextInputType.phone,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telefon raqamini kiriting';
                  }
                  if (value.replaceAll(' ', '').length != 9) {
                    return 'To‘liq telefon raqamini kiriting';
                  }
                  return null;
                },
                '+998 ',
                12,
                [PhoneNumberInputFormatter()],
              ),
              const Gap(12),
              _buildTextField(
                hallCountController,
                'Zallar soni',
                TextInputType.number,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Zallar sonini kiriting';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Faqat raqam kiriting';
                  }
                  return null;
                },
              ),
              const Gap(12),
              _buildTextField(
                bedsCountController,
                'Yotoq soni',
                TextInputType.number,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yotoq sonini kiriting';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Faqat raqam kiriting';
                  }
                  return null;
                },
              ),
              const Gap(12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Qulayliklar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Gap(8),
              if (profileProvider.availableFacilities.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: profileProvider.availableFacilities
                      .map<Widget>((facility) {
                    final id = facility['id'] as int;
                    final name = facility['name'] as String;
                    return FilterChip(
                      label: Text(name),
                      selected: selectedFacilities.contains(id),
                      selectedColor: AppColors.primaryColor.withOpacity(0.2),
                      checkmarkColor: AppColors.primaryColor,
                      side: BorderSide(
                        color: selectedFacilities.contains(id)
                            ? AppColors.primaryColor
                            : Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: selectedFacilities.contains(id)
                            ? AppColors.primaryColor
                            : Colors.black,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedFacilities.add(id);
                          } else {
                            selectedFacilities.remove(id);
                          }
                        });
                      },
                    );
                  }).toList(),
                )
              else
                const Text("Qulayliklar ro'yxati yo'q"),
              const Gap(16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Rasmlar (maksimal 3 ta)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Gap(8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...((widget.dacha.images ?? [])
                        .where(
                            (imgPath) => imgPath.isNotEmpty && imgPath != '/')
                        .map((imgPath) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.primaryColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: imgPath.startsWith('/')
                                        ? Image.network(
                                            '$domain$imgPath',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(imgPath),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.dacha.images!.remove(imgPath);
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                    if ((widget.dacha.images
                                ?.where((img) => img.isNotEmpty && img != '/')
                                .length ??
                            0) <
                        3)
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.primaryColor, width: 2),
                          ),
                          child: const Icon(Icons.add_a_photo,
                              size: 32, color: Colors.grey),
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(16),
              _buildDropdown(
                'Viloyat',
                profileProvider.availableRegions
                    .map((region) => DropdownMenuItem<String>(
                          value: region,
                          child: Text(region),
                        ))
                    .toList(),
                selectedViloyat,
                (String? newValue) async {
                  setState(() {
                    selectedViloyat = newValue;
                    selectedTuman = null;
                    selectedPopularPlace = null;
                  });
                  if (newValue != null) {
                    await profileProvider.fetchDistricts(newValue);
                    setState(() {}); // districtlar yangilansin
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Viloyatni tanlang';
                  }
                  return null;
                },
              ),
              const Gap(12),
              if (selectedViloyat != null) ...[
                _buildDropdown(
                  'Tuman',
                  profileProvider.availableDistricts
                      .map((district) => DropdownMenuItem<String>(
                            value: district,
                            child: Text(district),
                          ))
                      .toList(),
                  selectedTuman,
                  (String? newValue) {
                    setState(() {
                      selectedTuman = newValue;
                      selectedPopularPlace = null;
                      if (newValue != null) {
                        profileProvider.fetchPopularPlaces(newValue);
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tumanni tanlang';
                    }
                    return null;
                  },
                ),
                const Gap(12),
                if (selectedTuman != null)
                  _buildDropdown(
                    'Mashhur joy',
                    profileProvider.availablePopularPlaces
                        .map((place) => DropdownMenuItem<int>(
                              value: place['id'],
                              child: Text(place['name']),
                            ))
                        .toList(),
                    selectedPopularPlace,
                    (int? newValue) {
                      setState(() {
                        selectedPopularPlace = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Mashhur joyni tanlang';
                      }
                      return null;
                    },
                  ),
              ],
              const Gap(12),
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
              Row(
                children: [
                  const Text(
                    "Holati:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Gap(16),
                  Expanded(
                    child: RadioListTile<bool>(
                      activeColor: AppColors.primaryColor,
                      title: const Text("Bo'sh"),
                      value: true,
                      groupValue: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Band'),
                      value: false,
                      activeColor: AppColors.primaryColor,
                      groupValue: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final profileProvider =
                    Provider.of<ProfileProvider>(context, listen: false);
                final userId = profileProvider.profile?.id;
                final dacha = DachaModel(
                  name: nameController.text,
                  price: int.tryParse(priceController.text) ?? 0,
                  description: descriptionController.text,
                  phone: phoneController.text.replaceAll(' ', ''),
                  hallCount: int.tryParse(hallCountController.text) ?? 0,
                  bedsCount: int.tryParse(bedsCountController.text) ?? 0,
                  transactionType: "rent",
                  isActive: isActive,
                  facilities: selectedFacilities,
                  images: (widget.dacha.images ?? [])
                      .where((img) => img.isNotEmpty && img != '/')
                      .toList(),
                  propertyType: "dacha",
                  popularPlace: selectedPopularPlace?.toString() ?? '',
                  clientType: selectedClientTypeId ?? 0,
                  user: userId,
                  id: 0,
                  createdAt: null,
                  updatedAt: null,
                  deletedAt: null,
                  deleted: false,
                  address: '',
                );
                await profileProvider.updateDacha(context, dacha);
                Get.snackbar(
                  "Muvaffaqiyatli",
                  "Dacha O'zgartirildi!",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                print("✅ Dacha yangilandi: ${dacha.toJson()}");
                Navigator.pop(context);
              }
            },
            text: 'Saqlash',
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, [
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
    String? prefixText,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  ]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixText: prefixText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
        ),
      ),
      keyboardType: type,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLength: maxLength,
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
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xatolik'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
