import 'dart:convert';
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
  List<DachaModel> profileDacha = [];
  List<CommentsModel> comments = [];
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
      print("📡 Profilni yuklash boshlandi...");
      loadProfile();
      loadDachas();

      // TOKENNI TEKSHIRISH VA YANGILASH
      if (!await isTokenValid()) {
        await refreshToken();
      }

      final token = Hive.box('profileBox').get('access_token');
      if (token == null) {
        print("⚠️ Token yo‘q, profil yuklanmaydi.");
        return;
      }

      final response = await dio.get(
        '/me/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print("📡 Profil uchun so‘rov yuborildi: $response");

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
      }
    } catch (e) {
      print("❌ initProfile funksiyasida xatolik: $e");
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
      return false;
    }
    try {
      final decoded = decodeToken(token);
      final expiry = DateTime.fromMillisecondsSinceEpoch(decoded['exp'] * 1000);
      if (DateTime.now().isAfter(expiry)) {
        print("⚠️ Token muddati tugagan!");
        return false;
      }
      return true;
    } catch (e) {
      print("❌ Tokenni tekshirishda xatolik: $e");
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

  Future<Map<String, dynamic>?> refreshToken() async {
    final box = Hive.box('profileBox');
    final refreshToken = box.get('refresh_token');
    if (refreshToken == null) {
      print("⚠️ Refresh token yo‘q, yangilash o‘tkazib yuborildi.");
      return null; // <-- to'g'ri javob
    }
    try {
      print("📡 Refresh token bilan token yangilanmoqda: $refreshToken");
      final response = await ApiService().makePostRequest(
        '/token/refresh/',
        data: {'refresh': refreshToken},
      );
      if (response != null && response['access'] != null) {
        box.put('access_token', response['access']);
        print("✅ Token muvaffaqiyatli yangilandi: ${response['access']}");
      } else if (response != null && response['detail'] != null) {
        print("❌ Token yangilashda xatolik: ${response['detail']}");
      } else {
        print("❌ Token yangilashda noma'lum xatolik: $response");
      }
      return response;
    } on DioException catch (e) {
      print(
          "❌ Token yangilashda DioException: ${e.response?.data ?? e.message}");
      return null;
    } catch (e) {
      print("❌ Token yangilashda xatolik: $e");
      return null;
    }
  }

  Future<void> addDacha(BuildContext context, DachaModel dacha) async {
    try {
      if (!await isTokenValid()) {
        await refreshToken();
      }

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
        'is_active': dacha.isActive,
        'user': dacha.user,
        'uploaded_images': [
          for (var imgPath in dacha.images)
            await MultipartFile.fromFile(imgPath,
                filename: imgPath.split('/').last),
        ],
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

  Future<void> profileDachas() async {
    try {
      // TOKENNI TEKSHIRISH VA YANGILASH
      if (!await isTokenValid()) {
        await refreshToken();
      }

      final token = Hive.box('profileBox').get('access_token');
      final response = await dio.get(
        '/user_dachas/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        profileDacha.clear();
        profileDacha
            .addAll(data.map((json) => DachaModel.fromJson(json)).toList());
        notifyListeners();
        print("✅ Foydalanuvchi dachalari yuklandi: ${profileDacha.length} ta");
      }
    } catch (e) {
      print("❌ profileDachas funksiyasida xatolik: $e");
    }
  }

  Future<void> fetchDachas() async {
    try {
      // TOKENNI TEKSHIRISH VA YANGILASH
      if (!await isTokenValid()) {
        await refreshToken();
      }

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
      profile = null;
      dachas.clear();

      // Hive boxdagi login flag va tokenlarni tozalash
      final box = Hive.box('profileBox');
      box.put('isLoggedIn', false); // <-- MUHIM!
      box.delete('access_token');
      box.delete('refresh_token');
      box.delete('user_id');

      notifyListeners();
      print("✅ Foydalanuvchi muvaffaqiyatli chiqdi.");
      Get.snackbar(
        "Muvaffaqiyatli",
        "Foydalanuvchi muvaffaqiyatli chiqdi.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Logoutdan so‘ng login/register sahifaga yo‘naltirish
      Get.offAllNamed(Routes.registerPage);
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
      // Masalan, username orqali
      box.put('profile_${profile.name}', profile.toJson());
      box.put('last_user_id', profile.name);
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

  Future<void> updateDacha(BuildContext context, DachaModel dacha) async {
    try {
      final token = Hive.box('profileBox').get('access_token');

      final List<String> newImages = (dacha.images ?? [])
          .where((img) => !img.toString().startsWith('/'))
          .cast<String>()
          .toList();

      final List<String> existingImages = (dacha.images ?? [])
          .where((img) => img.toString().startsWith('/'))
          .cast<String>()
          .toList();

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
        'is_active': dacha.isActive,
        'user': dacha.user,
        'existing_images': existingImages,
        'uploaded_images': [
          for (var imgPath in newImages)
            await MultipartFile.fromFile(imgPath,
                filename: imgPath.split('/').last),
        ],
      });

      final response = await dio.patch(
        '/dachas/${dacha.id}/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final updatedDacha = DachaModel.fromJson(response.data);

        // provider orqali UI yangilanishi
        final provider = Provider.of<ProfileProvider>(context, listen: false);

        print("✅ Dacha yangilandi: ${response.data}");
        Get.snackbar("Muvaffaqiyatli", "Dacha yangilandi!",
            backgroundColor: Colors.green);

        Navigator.pop(context); // sahifani yopish
      } else {
        print("❌ Xatolik: ${response.data}");
        Get.snackbar("Xatolik", 'Xatolik: ${response.data}',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      print("❌ updateDacha funksiyasida xatolik: $e");
      Get.snackbar("Xatolik", 'Error: $e', backgroundColor: Colors.red);
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

  Future<void> sendDachaRating({
    required int dachaId,
    required int rating,
    required int userId,
  }) async {
    try {
      final token = Hive.box('profileBox').get('access_token');

      print(
          "Yuborilayotgan so‘rov: dacha: $dachaId, rating: $rating, user: $userId, token: $token");
      final response = await dio.post(
        '/dacha_ratings/',
        data: {
          'rating': rating,
          'dacha': dachaId,
          'user': userId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print("Javob: ${response.statusCode} ${response.data}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ Reyting yuborildi: ${response.data}");
        Get.snackbar(
          "Muvaffaqiyatli",
          "Reyting yuborildi!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print("❌ Reyting yuborishda xatolik: ${response.data}");
        Get.snackbar(
          "Xatolik",
          "Reyting yuborishda xatolik: ${response.data}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        print("❌ Backend javobi: ${e.response?.data}");
      }
      print("❌ sendDachaRating funksiyasida xatolik: $e");
      Get.snackbar(
        "Xatolik",
        "Reyting yuborishda xatolik: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> sendDachaComment({
    required int dachaId,
    required String comment,
    required int userId,
  }) async {
    try {
      final token = Hive.box('profileBox').get('access_token');

      print(
          "Yuborilayotgan komment: dacha: $dachaId, comment: $comment, user: $userId, token: $token");
      if (userId == null) {
        Get.snackbar(
            "Xatolik", "Foydalanuvchi ID topilmadi. Qayta login qiling.",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      final response = await dio.post(
        '/dacha_comments/',
        data: {
          'comment': comment,
          'dacha': dachaId,
          'user': userId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print("Komment javobi: ${response.statusCode} ${response.data}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          "Muvaffaqiyatli",
          "Komment yuborildi!",
        );
        await fetchComments();
        notifyListeners();
      } else {
        Get.snackbar("Xatolik", "Komment yuborilmadi!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        print("❌ Backend javobi: ${e.response?.data}");
      }
      print("❌ sendDachaComment funksiyasida xatolik: $e");
      Get.snackbar("Xatolik", "Komment yuborishda xatolik: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchComments() async {
    final token = Hive.box('profileBox').get('access_token');
    final response = await dio.get(
      '/dacha_comments/',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      comments = (response.data as List)
          .map((e) => CommentsModel.fromJson(e))
          .toList();
      notifyListeners();
    }
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
    final box = Hive.box('profileBox');
    final userId = box.get('user_id');
    final savedProfile = box.get('profile_$userId');
    if (savedProfile != null) {
      profile = ProfileModel.fromJson(Map<String, dynamic>.from(savedProfile));
      notifyListeners();
    }
  }

  List<DachaModel> loadDachas() {
    try {
      final box = Hive.box('dachaBox');
      final savedDachas = box.get('dachas', defaultValue: []);
      if (savedDachas != null && savedDachas is List) {
        final loadedDachas = savedDachas
            .map((json) => DachaModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
        print("✅ Dacha ma'lumotlari yuklandi: ${loadedDachas.length} ta");
        return loadedDachas;
      } else {
        print("⚠️ Dacha ma'lumotlari mavjud emas.");
        return [];
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
      return [];
    }
  }
}
