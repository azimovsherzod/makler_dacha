import 'dart:convert';
import 'dart:io';
import '../../../../constans/imports.dart';

class ProfileProvider extends ChangeNotifier {
  late Dio dio;

  ProfileProvider() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
    ));
  }

  ProfileModel? profile;
  List<DachaModel> dachas = [];
  List<Map<String, dynamic>> availableFacilities = [];
  List<String> availableRegions = [];
  List<String> availableDistricts = [];
  List<Map<String, dynamic>> availablePopularPlaces = [];
  List<Map<String, dynamic>> availableClientTypes = [];
  String? selectedClientType;
  String? selectedViloyat;
  String? selectedTuman;
  DachaModel? _selectedDacha;

  DachaModel? get selectedDacha => _selectedDacha;

  void setSelectedDacha(DachaModel dacha) {
    _selectedDacha = dacha;
    notifyListeners();
    print("✅ Tanlangan dacha: ${dacha.toJson()}");
  }

  Future<List<String>> imagesToBase64(List<String> imagePaths) async {
    List<String> base64Images = [];
    for (var path in imagePaths) {
      final bytes = await File(path).readAsBytes();
      base64Images.add(base64Encode(bytes));
    }
    return base64Images;
  }

  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> initProfile() async {
    try {
      print("📡 Profilni yuklash jarayoni boshlandi...");
      loadProfile();
      loadDachas();

      final response = await dio.get(
        '/users/',
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${Hive.box('profileBox').get('access_token')}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List && data.isNotEmpty) {
          profile = ProfileModel.fromJson(data.first as Map<String, dynamic>);
          print("✅ Profil yuklandi: ${profile!.toJson()}");
        } else if (data is Map<String, dynamic>) {
          profile = ProfileModel.fromJson(data);
          print("✅ Profil yuklandi: ${profile!.toJson()}");
        } else {
          print("❌ Noto'g'ri formatdagi javob: ${response.data}");
        }
        await fetchDachas();
        print("✅ Profil muvaffaqiyatli yuklandi.");
      } else {
        print("❌ Profilni olishda xatolik: ${response.statusCode}");
        Get.snackbar(
          "Xatolik",
          "Profilni olishda xatolik: ${response.statusCode}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ initProfile funksiyasida xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Profilni yuklashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void saveData<T>(String boxName, String key, T data) {
    try {
      final box = Hive.box(boxName);
      box.put(key, data);
      print("✅ $key ma'lumotlari saqlandi: $data");
    } catch (e) {
      print("❌ $key ma'lumotlarini saqlashda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "$key ma'lumotlarini saqlashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Map<String, dynamic> decodeToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception("❌ Неправильный формат токена");
    }
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return json.decode(payload) as Map<String, dynamic>;
  }

  Future<bool> isTokenValid() async {
    final token = Hive.box('profileBox').get('access_token');
    if (token == null) {
      print("⚠️ Token mavjud emas!");
      Get.snackbar(
        "Xatolik",
        "Token mavjud emas!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    try {
      final decoded = decodeToken(token);
      final expiry = DateTime.fromMillisecondsSinceEpoch(decoded['exp'] * 1000);
      print("🔍 Token amal qilish muddati: $expiry");
      if (DateTime.now().isAfter(expiry)) {
        print("⚠️ Tokenning amal qilish muddati tugagan!");
        Get.snackbar(
          "Xatolik",
          "Tokenning amal qilish muddati tugagan!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
      return true;
    } catch (e) {
      print("❌ Tokenni tekshirishda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Tokenni tekshirishda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<void> checkAndLogout() async {
    if (!await isTokenValid()) {
      print("⚠️ Token amal qilish muddati tugagan. Logout chaqirilmoqda...");
      await logout();
      Get.snackbar(
        "Xatolik",
        "Token muddati tugagan. Qayta login qiling.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      print("✅ Token hali ham amal qiladi.");
    }
  }

  Future<void> refreshToken() async {
    final box = Hive.box('profileBox');
    final refreshToken = box.get('refresh_token');
    if (refreshToken == null) {
      print("⚠️ Refresh токен отсутствует!");
      Get.snackbar(
        "Xatolik",
        "Refresh токен отсутствует!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    try {
      print("📡 Обновляем токен с использованием refresh_token: $refreshToken");
      final response = await ApiService().makePostRequest(
        '/auth/token/refresh/',
        data: {'refresh': refreshToken},
      );
      if (response != null && response['access'] != null) {
        box.put('access_token', response['access']);
        print("✅ Токен успешно обновлен: ${response['access']}");
        Get.snackbar(
          "Muvaffaqiyatli",
          "Token muvaffaqiyatli yangilandi",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else if (response != null && response['detail'] != null) {
        print("❌ Ошибка обновления токена: ${response['detail']}");
        Get.snackbar(
          "Ошибка авторизации",
          response['detail'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print("❌ Неизвестная ошибка при обновлении токена: $response");
        Get.snackbar(
          "Xatolik",
          "Tokenni yangilashda noma'lum xatolik: $response",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      print("❌ Ошибка при обновлении токена: ${e.response?.data ?? e.message}");
      Get.snackbar(
        "Ошибка сети",
        e.response?.data['detail'] ?? e.message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print("❌ Неизвестная ошибка: $e");
      Get.snackbar(
        "Ошибка",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Dacha yaratish: multipart bilan bir nechta rasm yuborish
  Future<void> addDacha(BuildContext context, DachaModel dacha) async {
    try {
      final token = Hive.box('profileBox').get('access_token');

      FormData formData = FormData.fromMap({
        'name': dacha.name,
        'price': dacha.price,
        'description': dacha.description,
        'phone': dacha.phone.toString(),
        'hall_count': dacha.hallCount,
        'beds_count': dacha.bedsCount,
        'transaction_type': dacha.transactionType,
        'facilities': dacha.facilities,
        'popular_place': dacha.popularPlace,
        'client_type': dacha.clientType,
        'property_type': dacha.propertyType,
        'uploaded_images': [
          for (var imgPath in dacha.images)
            await MultipartFile.fromFile(imgPath,
                filename: imgPath.split('/').last),
        ],
        // boshqa maydonlar bo‘lsa, qo‘shing
      });

      final response = await dio.post(
        '/dachas/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ Yangi dacha yaratildi: ${response.data}");
        Get.snackbar(
          "Muvaffaqiyatli",
          "Dacha yaratildi!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchDachas();
        Navigator.pop(context);
      } else {
        print("❌ Xatolik: ${response.data}");
        Get.snackbar(
          "Xatolik",
          'Xatolik: ${response.data}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ addDacha funksiyasida xatolik: $e");
      Get.snackbar(
        "Xatolik",
        'Error: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchDachas() async {
    try {
      final response = await dio.get(
        '/dachas/',
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${Hive.box('profileBox').get('access_token')}',
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        dachas.clear();
        dachas.addAll(data.map((json) => DachaModel.fromJson(json)).toList());
        notifyListeners();
        print("✅ Dachalar muvaffaqiyatli yuklandi: ${dachas.length} ta");
      } else {
        print("❌ Dachalarni olishda xatolik: ${response.statusCode}");
        Get.snackbar(
          "Xatolik",
          "Dachalarni olishda xatolik: ${response.statusCode}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ fetchDachas funksiyasida xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Dachalarni olishda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchFacilities() async {
    try {
      final response = await ApiService().makeGetRequest('/facilities/');
      if (response != null) {
        availableFacilities = List<Map<String, dynamic>>.from(response);
        notifyListeners();
      }
    } catch (e) {
      print("❌ Ошибка загрузки удобств: $e");
      Get.snackbar(
        "Xatolik",
        "Uslublarni yuklashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchRegions() async {
    try {
      final response = await dio.get('/regions/');
      if (response.statusCode == 200) {
        availableRegions = response.data.map<String>((region) {
          if (region is Map<String, dynamic> && region.containsKey('name')) {
            return region['name'] as String;
          } else if (region is String) {
            return region;
          } else {
            print("❌ Noto‘g‘ri formatdagi region: $region");
            return "Noma'lum region";
          }
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      print("❌ Viloyatlarni yuklashda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Viloyatlarni yuklashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchAllData() async {
    print("🔄 Barcha ma'lumotlarni yangilash boshlandi...");
    await Future.wait([
      initProfile(),
      fetchFacilities(),
      fetchRegions(),
      fetchClientTypes(),
      fetchPopularPlaces(selectedTuman),
      if (selectedViloyat != null) fetchDistricts(selectedViloyat!),
    ]);
    print("✅ Barcha ma'lumotlar yangilandi!");
    notifyListeners();
  }

  Future<void> fetchDistricts(String viloyat) async {
    try {
      final response = await ApiService().makeGetRequest('/districts/');
      if (response != null && response is List) {
        availableDistricts =
            response.map((district) => district['name'] as String).toList();
        print("✅ Tumans yuklandi: $availableDistricts");
        notifyListeners();
      } else {
        print("⚠️ Tumans yuklashda xatolik: $response");
        Get.snackbar(
          "Xatolik",
          "Tumans yuklashda xatolik: $response",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Tumans yuklashda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Tumans yuklashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchPopularPlaces([String? district]) async {
    try {
      print("📡 Popular places uchun so'rov yuborilmoqda: $district");
      final response = await ApiService().makeGetRequest(
        '/popularplaces/',
        queryParameters: district != null ? {'district': district} : null,
      );
      print("📡 Ответ от сервера (popular_places): $response");
      if (response != null && response is List) {
        availablePopularPlaces = response.map((e) {
          return {
            "id": int.tryParse(e['id'].toString()) ?? 0,
            "name": e['name'] ?? '',
          };
        }).toList();
        print("✅ Mashhur joylar yuklandi: $availablePopularPlaces");
        notifyListeners();
      } else {
        print("⚠️ Пустой или некорректный ответ для popular-places: $response");
        Get.snackbar(
          "Xatolik",
          "Popular places yuklashda xatolik: $response",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Ошибка при загрузке popular places: $e");
      Get.snackbar(
        "Xatolik",
        "Popular places yuklashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchClientTypes() async {
    try {
      final response = await ApiService().makeGetRequest('/client_types/');
      print("📡 Ответ от сервера (client_types): $response");
      if (response != null && response is List) {
        availableClientTypes = response.map((e) {
          return {
            "id": int.tryParse(e['id'].toString()) ?? 0,
            "name": e['name'] ?? '',
          };
        }).toList();
        print("✅ Типы клиентов загружены: $availableClientTypes");
        notifyListeners();
      } else {
        print("⚠️ Пустой или некорректный ответ для client-types: $response");
        Get.snackbar(
          "Xatolik",
          "Client types yuklashda xatolik: $response",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Ошибка при загрузке client types: $e");
      Get.snackbar(
        "Xatolik",
        "Client types yuklashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout() async {
    try {
      print("📤 Foydalanuvchi chiqmoqda...");
      final profileBox = Hive.box('profileBox');
      final dachaBox = Hive.box('dachaBox');
      await profileBox.clear();
      await dachaBox.clear();
      profile = null;
      dachas.clear();
      notifyListeners();
      print("✅ Foydalanuvchi muvaffaqiyatli chiqdi.");
      Get.snackbar(
        "Muvaffaqiyatli",
        "Foydalanuvchi muvaffaqiyatli chiqdi.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("❌ Logoutda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Logoutda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void saveDachas(List<DachaModel> dachas) {
    try {
      final box = Hive.box('dachaBox');
      box.put('dachas', dachas.map((d) => d.toJson()).toList());
      print("✅ Dachalar saqlandi: ${dachas.length} ta");
    } catch (e) {
      print("❌ Dachalarni saqlashda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Dachalarni saqlashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void saveProfile(ProfileModel profile) {
    try {
      final box = Hive.box('profileBox');
      box.put('profile', profile.toJson());
      print("✅ Profil saqlandi: ${profile.toJson()}");
    } catch (e) {
      print("❌ Profilni saqlashda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Profilni saqlashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateProfile(ProfileModel updatedProfile) async {
    profile = updatedProfile;
    saveProfile(profile!);
    notifyListeners();
    print("✅ Profil yangilandi va saqlandi: ${profile?.toJson()}");
    Get.snackbar(
      "Muvaffaqiyatli",
      "Profil yangilandi va saqlandi.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<bool> deleteDacha(int dachaId) async {
    try {
      print("📡 DELETE uchun dachaId: $dachaId");
      final response =
          await ApiService().makeDeleteRequest('/dachas/$dachaId/');
      print("✅ Ответ сервера: $response");

      // 204 yoki null yoki bo‘sh string bo‘lsa ham muvaffaqiyatli deb hisoblaymiz
      if (response == null ||
          response == "" ||
          (response is Map && response['success'] == true)) {
        print("✅ Dacha muvaffaqiyatli o'chirildi: $dachaId");
        dachas
            .removeWhere((dacha) => dacha.id.toString() == dachaId.toString());
        notifyListeners();
        Get.snackbar(
          "Muvaffaqiyatli",
          "Dacha muvaffaqiyatli o'chirildi.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else if (response is Map && response['detail'] == "Not found.") {
        print("❌ Dacha topilmadi: $dachaId");
        Get.snackbar(
          "Xatolik",
          "Dacha topilmadi.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      } else if (response is Map && response['detail'] != null) {
        print("❌ Dacha o'chirishda xatolik: ${response['detail']}");
        Get.snackbar(
          "Xatolik",
          response['detail'].toString(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      } else {
        print("❌ Dacha o'chirishda xatolik: $response");
        Get.snackbar(
          "Xatolik",
          "Dacha o'chirishda xatolik: $response",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print("❌ Dacha o'chirishda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Dacha o'chirishda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  void loadProfile() {
    try {
      final box = Hive.box('profileBox');
      final savedProfile = box.get('profile');
      if (savedProfile != null) {
        profile =
            ProfileModel.fromJson(Map<String, dynamic>.from(savedProfile));
        print("✅ Profil yuklandi: ${profile?.toJson()}");
      } else {
        print("⚠️ Saqlangan profil topilmadi. Bo'sh profil o'rnatilmoqda...");
        profile = ProfileModel(
          name: '',
          surname: '',
          phone: '',
          dachas: [],
        );
      }
    } catch (e) {
      print("❌ Profilni yuklashda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Profilni yuklashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void loadDachas() {
    try {
      final box = Hive.box('dachaBox');
      final savedDachas = box.get('dachas', defaultValue: []);
      if (savedDachas != null && savedDachas is List) {
        dachas = List<DachaModel>.from(
          savedDachas
              .map((x) => DachaModel.fromJson(Map<String, dynamic>.from(x))),
        );
        print("✅ Dacha ma'lumotlari yuklandi: ${dachas.length} ta");
      } else {
        print("⚠️ Dacha ma'lumotlari mavjud emas.");
      }
    } catch (e) {
      print("❌ Dacha ma'lumotlarini yuklashda xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Dacha ma'lumotlarini yuklashda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
