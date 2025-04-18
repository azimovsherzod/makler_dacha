import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../constans/imports.dart';

class EditPage extends StatefulWidget {
  final DachaModel dacha;

  const EditPage({Key? key, required this.dacha}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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
  int? selectedAddress;
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
    isActive = widget.dacha.isActive;

    // Hive boxni ochish
    if (!Hive.isBoxOpen('profileBox')) {
      Hive.openBox('profileBox').then((openedBox) {
        setState(() {
          box = openedBox; // To'g'ri turda saqlash
        });
      }).catchError((error) {
        print("❌ Hive box ochishda xatolik: $error");
      });
    } else {
      box = Hive.box('profileBox'); // To'g'ri turda saqlash
    }

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    // Load data from ProfileProvider
    profileProvider.fetchRegions();
    profileProvider.fetchClientTypes();
    profileProvider.fetchFacilities();
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        widget.dacha.images = [pickedImage.path]; // Faqat bitta rasmni saqlash
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать Дачу')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(nameController, 'Название', TextInputType.text),
            const Gap(12),
            _buildTextField(priceController, 'Цена', TextInputType.number),
            const Gap(12),
            _buildTextField(
                descriptionController, 'Описание', TextInputType.text),
            const Gap(12),
            _buildTextField(phoneController, 'Телефон', TextInputType.phone),
            const Gap(12),
            _buildTextField(
                hallCountController, 'Количество залов', TextInputType.number),
            const Gap(12),
            _buildTextField(bedsCountController, 'Количество кроватей',
                TextInputType.number),
            const Gap(12),
            _buildDropdown(
              'Viloyat',
              profileProvider.availableRegions
                  .map((region) => DropdownMenuItem<String>(
                        value: region,
                        child: Text(region),
                      ))
                  .toList(),
              selectedViloyat,
              (String? newValue) {
                setState(() {
                  selectedViloyat = newValue;
                  selectedTuman = null;
                  selectedAddress = null;

                  if (newValue != null) {
                    profileProvider.fetchDistricts(newValue);
                  }
                });
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
                    selectedAddress = null;

                    if (newValue != null) {
                      profileProvider.fetchPopularPlaces(newValue);
                    }
                  });
                },
              ),
              const Gap(12),
              if (selectedTuman != null)
                _buildDropdown(
                  'Popular Place',
                  profileProvider.availablePopularPlaces
                      .map((place) => DropdownMenuItem<int>(
                            value: place['id'], // Backendda kutilayotgan qiymat
                            child: Text(place['name']),
                          ))
                      .toList(),
                  selectedPopularPlace,
                  (int? newValue) {
                    setState(() {
                      selectedPopularPlace = newValue;
                    });
                  },
                ),
            ],
            const Gap(12),
            _buildDropdown(
              'Тип клиента',
              profileProvider.availableClientTypes
                  .map((type) => DropdownMenuItem<int>(
                        value: type['id'] as int,
                        child: Text(type['name'] as String),
                      ))
                  .toList(),
              selectedClientTypeId,
              (int? newValue) {
                setState(() {
                  selectedClientTypeId = newValue;
                });
              },
            ),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Удобства',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Gap(8),
                ...profileProvider.availableFacilities.map((facility) {
                  final facilityId = facility['id'] as int;
                  final facilityName = facility['name'] as String;
                  return CheckboxListTile(
                    title: Text(facilityName),
                    value: selectedFacilities.contains(facilityId),
                    onChanged: (bool? isChecked) {
                      setState(() {
                        if (isChecked == true) {
                          selectedFacilities.add(facilityId);
                        } else {
                          selectedFacilities.remove(facilityId);
                        }
                      });
                    },
                  );
                }).toList(),
              ],
            ),
            const Gap(12),
            SwitchListTile(
              title: const Text('Активно'),
              value: isActive,
              onChanged: (bool value) {
                setState(() {
                  isActive = value;
                });
              },
            ),
            Column(
              children: [
                if (widget.dacha.images != null &&
                    widget.dacha.images!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.file(
                      File(widget.dacha.images!.first),
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  const Text(
                    'No image selected',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                const Gap(16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                  ),
                  onPressed: _pickImage,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.photo_camera, size: 28, color: Colors.white),
                      Gap(8),
                      Text(
                        'Pick Photo',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  onPressed: _saveDacha,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Saqlash',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _saveDacha() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (!Hive.isBoxOpen('profileBox')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Box is not initialized. Please try again.')),
      );
      return;
    }

    final userId = box.get("user_id");
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User ID not found. Please log in again.')),
      );
      return;
    }

    final dacha = DachaModel(
      id: 0,
      name: nameController.text,
      price: int.tryParse(priceController.text) ?? 0,
      description: descriptionController.text,
      phone: phoneController.text,
      hallCount: int.tryParse(hallCountController.text) ?? 0,
      bedsCount: int.tryParse(bedsCountController.text) ?? 0,
      transactionType: transactionTypeController.text,
      isActive: isActive,
      facilities: selectedFacilities,
      images: widget.dacha.images,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: null,
      deleted: false,
      address: selectedAddress?.toString() ?? '',
      propertyType: selectedPropertyType ?? 'dacha',
      popularPlace: selectedPopularPlace?.toString() ?? '',
      clientType: selectedClientTypeId ?? 0,
      user: userId,
    );

    print('Dacha data: ${dacha.toJson()}');

    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.addDacha(dacha);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dacha created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType type = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: type,
      inputFormatters: type == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
    );
  }

  Widget _buildDropdown<T>(String label, List<DropdownMenuItem<T>> items,
      T? selectedValue, ValueChanged<T?> onChanged) {
    return DropdownButtonFormField<T>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
