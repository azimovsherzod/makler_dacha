import 'package:image_picker/image_picker.dart';
import '../../../../constans/imports.dart';

class CreateDachaPage extends StatefulWidget {
  const CreateDachaPage({Key? key}) : super(key: key);

  @override
  _CreateDachaPageState createState() => _CreateDachaPageState();
}

class _CreateDachaPageState extends State<CreateDachaPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController phoneController;
  late TextEditingController hallCountController;
  late TextEditingController bedsCountController;
  late TextEditingController transactionTypeController;
  String? selectedViloyat;
  String? selectedTuman;
  int? selectedPopularPlace;
  int? selectedClientTypeId;
  String? selectedPropertyType;
  List<int> selectedFacilities = [];
  List<String> images = [];
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    phoneController = TextEditingController();
    hallCountController = TextEditingController();
    bedsCountController = TextEditingController();
    transactionTypeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.fetchRegions();
      profileProvider.fetchClientTypes();
      profileProvider.fetchFacilities();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    hallCountController.dispose();
    bedsCountController.dispose();
    transactionTypeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (images.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Siz maksimal 3 ta rasm tanlashingiz mumkin')),
      );
      return;
    }
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        final qoldiq = 3 - images.length;
        images.addAll(pickedImages.take(qoldiq).map((e) => e.path));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rasm tanlanmadi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Yangi dacha yaratish')),
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
              Padding(
                padding: const EdgeInsets.only(right: 180),
                child: Text(
                  "Rasmlar (maksimal 3 ta)",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                ),
              ),
              const Gap(8),
              Padding(
                padding: const EdgeInsets.only(right: 300),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ...(images
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
                                      child: Image.file(
                                        File(imgPath),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          images.remove(imgPath);
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
                      if (images.length < 3)
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
              ),
              const Gap(16),
              _buildDropdown<String>(
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
                    setState(() {});
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
                _buildDropdown<String>(
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
                  _buildDropdown<int>(
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
                  images: images,
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
                await profileProvider.addDacha(context, dacha);
                Get.offAndToNamed(Routes.profilePage);
              }
            },
            text: 'Yaratish',
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
