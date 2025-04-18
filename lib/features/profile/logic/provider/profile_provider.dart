import 'dart:convert';
import '../../../../constans/imports.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? profile;
  List<DachaModel> dachas = [];
  List<Map<String, dynamic>> availableFacilities = [];
  List<String> availableRegions = [];
  List<String> availableDistricts = [];
  List<Map<String, dynamic>> availablePopularPlaces = [];
  Map<int, String> images = {};
  DachaModel? _selectedDacha;
  List<Map<String, dynamic>> availableClientTypes = [];
  String? selectedClientType;
  String? selectedViloyat;
  String? selectedTuman;

  DachaModel? get selectedDacha => _selectedDacha;

  void setSelectedDacha(DachaModel dacha) {
    _selectedDacha = dacha;
    notifyListeners();
  }

  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> initProfile() async {
    try {
      print("📡 Profilni yuklash jarayoni boshlandi...");
      final box = Hive.box('profileBox');
      final userId = box.get('user_id');

      if (userId == null) {
        print("❌ user_id mavjud emas!");
        return;
      }

      final response = await ApiService().makeGetRequest('/users/$userId/');
      if (response != null) {
        final profileData = Map<String, dynamic>.from(
            response); // Javobni to'g'ri turga aylantirish
        profile = ProfileModel.fromJson(profileData);
        print("✅ Profil muvaffaqiyatli yuklandi: ${profile?.toJson()}");
      } else {
        print("❌ Profilni yuklashda xatolik: response = $response");
      }
    } catch (e, stackTrace) {
      print("❌ initProfile() xatosi: $e\n$stackTrace");
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
    final token = box.read('access_token');
    if (token == null) {
      print("⚠️ Token mavjud emas!");
      return false;
    }

    try {
      final decoded = decodeToken(token);
      final expiry = DateTime.fromMillisecondsSinceEpoch(decoded['exp'] * 1000);
      if (DateTime.now().isAfter(expiry)) {
        print("⚠️ Tokenning amal qilish muddati tugagan!");
        return false;
      }
      return true;
    } catch (e) {
      print("❌ Tokenni tekshirishda xatolik: $e");
      return false;
    }
  }

  Future<void> refreshToken() async {
    final refreshToken = box.read('refresh_token');
    if (refreshToken == null) {
      print("⚠️ Refresh токен отсутствует!");
      return;
    }

    try {
      print("📡 Обновляем токен с использованием refresh_token: $refreshToken");

      final response = await ApiService().makePostRequest(
        '/auth/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response != null && response['access'] != null) {
        box.write('access_token', response['access']);
        print("✅ Токен успешно обновлен: ${response['access']}");
      } else if (response != null && response['detail'] != null) {
        print("❌ Ошибка обновления токена: ${response['detail']}");
        Get.snackbar(
          "Ошибка авторизации",
          response['detail'],
          backgroundColor: Colors.red,
        );
      } else {
        print("❌ Неизвестная ошибка при обновлении токена: $response");
      }
    } on DioException catch (e) {
      print("❌ Ошибка при обновлении токена: ${e.response?.data ?? e.message}");
      Get.snackbar(
        "Ошибка сети",
        e.response?.data['detail'] ?? e.message,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      print("❌ Неизвестная ошибка: $e");
      Get.snackbar(
        "Ошибка",
        e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> addDacha(DachaModel dacha) async {
    if (!await isConnected()) {
      print("❌ Интернет отсутствует!");
      Get.snackbar("Ошибка", "Нет подключения к интернету",
          backgroundColor: Colors.red);
      return;
    }
    try {
      print("📡 [POST] Запрос: /dachas/");
      print("📦 Данные перед отправкой: ${dacha.toJson()}");

      final response = await ApiService().makePostRequest(
        '/dachas/',
        data: dacha.toJson(),
      );

      if (response != null) {
        if (response['id'] != null) {
          final newDacha = DachaModel.fromJson(response);
          dachas.add(newDacha);
          saveDachas();
          notifyListeners();
          print("✅ Новая дача создана: ${newDacha.toJson()}");
        } else if (response['detail'] != null) {
          print("❌ Ошибка: ${response['detail']}");
          Get.snackbar("Ошибка", response['detail'],
              backgroundColor: Colors.red);
        } else {
          print("❌ Ошибка: сервер вернул некорректный ответ: $response");
        }
      } else {
        print("❌ Ошибка: сервер вернул null");
        Get.snackbar("Ошибка", "Сервер вернул пустой ответ",
            backgroundColor: Colors.red);
      }
    } on DioException catch (e) {
      print("❌ Ошибка в addDacha: ${e.response?.statusCode}");
      print("❌ Ответ сервера: ${e.response?.data}");
      Get.snackbar(
        "Ошибка",
        e.response?.data?['detail'] ?? e.message,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      print("❌ Неизвестная ошибка в addDacha: $e");
      Get.snackbar("Ошибка", e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> uploadDachaImage(int dachaId) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        images[dachaId] = pickedFile.path;
        notifyListeners();

        print("📤 Rasmni yuklash boshlandi: ${pickedFile.path}");

        // Rasmni backendga yuborish
        final formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(pickedFile.path,
              filename: 'dacha_image.jpg'),
        });

        final response = await Dio().post(
          '/dachas/upload_images', // Backend URL
          data: formData,
          options: Options(
            headers: {
              'Authorization':
                  'Bearer ${box.read("access_token")}', // Tokenni qo'shish
            },
          ),
        );

        if (response.statusCode == 200) {
          print('✅ Image uploaded successfully for dacha $dachaId');
          final imageUrl = response.data['imageUrl'];
          images[dachaId] = imageUrl; // Backenddan qaytgan URL-ni saqlash
          notifyListeners();
        } else {
          print('❌ Failed to upload image: ${response.statusCode}');
        }
      } else {
        print("⚠️ Rasm tanlanmadi");
      }
    } catch (e) {
      print('❌ Error uploading image: $e');
    }
  }

  void updateDacha(DachaModel updatedDacha) {
    if (updatedDacha.id == 0) {
      print("❌ Ошибка: Невозможно обновить дачу с id 0");
      return;
    }

    final index = dachas.indexWhere((d) => d.id == updatedDacha.id);
    if (index != -1) {
      dachas[index] = updatedDacha;
      saveDachas();
      notifyListeners();
      print("✅ Дача обновлена: ${updatedDacha.toJson()}");
    } else {
      print("❌ Ошибка: Дача с id ${updatedDacha.id} не найдена");
    }
  }

  void deleteDacha(int id) {
    dachas.removeWhere((d) => d.id == id);
    saveDachas();
    notifyListeners();
  }

  void saveDachas() {
    final box = Hive.box('dachaBox');
    box.put('dachas', dachas.map((d) => d.toJson()).toList());
    print("✅ Dacha ma'lumotlari saqlandi");
  }

  void saveProfile(ProfileModel profile) {
    final box = Hive.box('profileBox');
    box.put('profile', profile.toJson());
    print("✅ Profil saqlandi: ${profile.toJson()}");
  }

  void loadProfile() {
    final box = Hive.box('profileBox');
    final savedProfile = box.get('profile');
    if (savedProfile != null) {
      profile = ProfileModel.fromJson(savedProfile);
      print("✅ Profil yuklandi: ${profile?.toJson()}");
    } else {
      print("⚠️ Saqlangan profil topilmadi");
    }
  }

  void loadDachas() {
    final box = Hive.box('dachaBox');
    final savedDachas = box.get('dachas');
    if (savedDachas != null) {
      dachas = List<DachaModel>.from(
        savedDachas.map((e) => DachaModel.fromJson(e)),
      );
      print("✅ Dacha ma'lumotlari yuklandi: ${dachas.length} ta");
    } else {
      print("⚠️ Saqlangan dacha ma'lumotlari topilmadi");
    }
  }

  Future<void> fetchFacilities() async {
    try {
      final response = await ApiService().makeGetRequest('/facilities/');
      if (response != null) {
        availableFacilities = List<Map<String, dynamic>>.from(response);
        box.write('facilities', availableFacilities);
        notifyListeners();
      }
    } catch (e) {
      print("❌ Ошибка загрузки удобств: $e");
    }
  }

  Future<void> fetchRegions() async {
    try {
      final response = await ApiService().makeGetRequest('/regions/');
      print("📡 Ответ от сервера (regions): $response");
      if (response != null) {
        availableRegions = List<String>.from(response.map((e) => e['name']));
        notifyListeners();
      }
    } catch (e) {
      print('❌ Ошибка загрузки регионов: $e');
    }
  }

  Future<void> fetchDistricts(String region) async {
    try {
      print("📡 Запрашиваем районы для региона: $region");
      final response =
          await ApiService().makeGetRequest('/districts/?region=$region');

      if (response != null && response is List) {
        availableDistricts = List<String>.from(response.map((e) => e['name']));
        notifyListeners();
        print("✅ Районы загружены: $availableDistricts");
      } else {
        print("⚠️ Пустой или некорректный ответ для районов: $response");
      }
    } catch (e) {
      print('❌ Ошибка загрузки районов: $e');
    }
  }

  Future<void> fetchPopularPlaces(String district) async {
    try {
      print("📡 Запрашиваем популярные места для района: $district");
      final response = await ApiService()
          .makeGetRequest('/popularplaces/?district=$district');

      if (response != null && response is List) {
        availablePopularPlaces = List<Map<String, dynamic>>.from(response);
        print("✅ Популярные места загружены: $availablePopularPlaces");
        notifyListeners();
      } else {
        print(
            "⚠️ Пустой или некорректный ответ для популярных мест: $response");
      }
    } catch (e) {
      print('❌ Ошибка загрузки популярных мест: $e');
    }
  }

  Future<void> fetchClientTypes() async {
    try {
      final response = await ApiService().makeGetRequest('/client_types/');
      print("📡 Ответ от сервера (client_ыtypes): $response");
      if (response != null && response is List) {
        availableClientTypes = response.map((e) {
          print("🔍 Обработка элемента: $e"); // Логирование каждого элемента
          return {
            "id": int.tryParse(e['id'].toString()) ?? 0,
            "name": e['name'] ?? '',
          };
        }).toList();
        print("✅ Типы клиентов загружены: $availableClientTypes");
        notifyListeners();
      } else {
        print("⚠️ Пустой или некорректный ответ для client-types: $response");
      }
    } catch (e) {
      print("❌ Ошибка при загрузке client types: $e");
    }
  }

  Future<void> logout() async {
    try {
      print("📤 Foydalanuvchi chiqmoqda...");
      final profileBox = Hive.box('profileBox');
      final dachaBox = Hive.box('dachaBox');
      await profileBox.clear(); // Profil ma'lumotlarini o'chirish
      await dachaBox.clear(); // Dacha ma'lumotlarini o'chirish
      profile = null;
      dachas.clear();
      notifyListeners();
      print("✅ Foydalanuvchi muvaffaqiyatli chiqdi.");
    } catch (e) {
      print("❌ Logoutda xatolik: $e");
    }
  }
}
