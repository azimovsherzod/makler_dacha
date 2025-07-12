import 'dart:convert';

import '../../../../constans/imports.dart';

class AuthProvider extends ChangeNotifier {
  Future<bool> login(String phone, String password) async {
    try {
      final response = await ApiService().makePostRequest('/token/', data: {
        'username': phone,
        'password': password,
      });

      if (response != null &&
          response['access'] != null &&
          response['refresh'] != null) {
        Hive.box('profileBox').put('access_token', response['access']);
        Hive.box('profileBox').put('refresh_token', response['refresh']);
        Hive.box('profileBox').put('isLoggedIn', true);
        return true;
      } else {
        print("❌ Login xatosi: ${response?['detail'] ?? 'Noma\'lum xato'}");
        return false;
      }
    } catch (e) {
      print("❌ Login jarayonida xatolik: $e");
      return false;
    }
  }

  Future<void> register(
      String username,
      String name,
      String phone,
      String surname,
      String firstName,
      String lastName,
      String password) async {
    try {
      showLoadingAlert();

      final response = await ApiService().makePostRequest('/users/', data: {
        'username': phone,
        'name': name,
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'surname': surname,
      });

      dismissLoadingAlert();
      print("📩 Serverda javobi: $response");

      if (response != null && response.containsKey('id')) {
        final box = Hive.box('profileBox');
        box.put('profile_${response['id']}', response);
        box.put('isLoggedIn', true);
        box.put('user_id', response['id']);

        if (response.containsKey('access')) {
          box.put('access_token', response['access']);
        }
        if (response.containsKey('refresh')) {
          box.put('refresh_token', response['refresh']);
        }

        print("✅ Profil va tokenlar saqlandi: $response");

        Get.snackbar(
            '✅ Muvaffaqiyatli', 'Ro‘yxatdan o‘tish muvaffaqiyatli yakunlandi!',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAndToNamed(Routes.maklerHome);
      } else if (response != null && response.containsKey('detail')) {
        String errorMsg = response['detail'].toString();

        if (errorMsg.contains('already exists')) {
          Get.snackbar(
              '⚠️ Diqqat', 'Bu foydalanuvchi allaqachon ro‘yxatdan o‘tgan!',
              backgroundColor: Colors.orange);
        } else {
          Get.snackbar('❌ Xato', errorMsg, backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar('❌ Xato', "Noma'lum xato", backgroundColor: Colors.red);
      }
    } catch (e) {
      dismissLoadingAlert();
      print("⚠️ Ro'yxatdan o'tish jarayonida xatolik: $e");
      Get.snackbar('❌ Xato',
          'Ro‘yxatdan o‘tish amalga oshmadi. Iltimos, qaytadan urinib ko‘ring.',
          backgroundColor: Colors.red);
    }
  }

  void showErrorDialog(String message) {
    Get.defaultDialog(
      title: "Error",
      middleText: message,
      backgroundColor: Colors.red,
      titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      middleTextStyle: TextStyle(color: Colors.white),
      textConfirm: "ОК",
      confirmTextColor: Colors.white,
      buttonColor: Colors.black,
      onConfirm: () {
        Get.back();
      },
    );
  }
}

// JWT tokenni decode qilish uchun yordamchi funksiya
Map<String, dynamic> decodeToken(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw Exception('Invalid token');
  final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
  return json.decode(payload) as Map<String, dynamic>;
}
