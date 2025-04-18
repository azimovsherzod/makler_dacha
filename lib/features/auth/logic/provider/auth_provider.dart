import '../../../../constans/imports.dart';

class AuthProvider extends ChangeNotifier {
  Future<bool> login(String phone, String password) async {
    try {
      final response = await ApiService().makePostRequest('/token/', data: {
        'username': phone,
        'password': password,
      });

      if (response != null && response['access'] != null) {
        final box = Hive.box('profileBox');
        box.put('access_token', response['access']); // To'g'ri maydon nomi
        box.put('refresh_token', response['refresh']); // To'g'ri maydon nomi
        print("✅ Tokenlar saqlandi: ${response['access']}");

        // Token orqali user_id ni saqlash
        await ApiService().saveUserIdFromToken();

        return true;
      } else {
        print("❌ Login xatosi: ${response['detail'] ?? 'Noma\'lum xato'}");
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
      print("📩 Ответ от сервера: $response"); // Лог ответа сервера

      if (response != null && response.containsKey('id')) {
        // ✅ Успешная регистрация
        Get.snackbar('✅ Успех', 'Регистрация прошла успешно!',
            backgroundColor: Colors.green);
        Get.offAndToNamed(Routes.home);
      } else if (response != null && response.containsKey('detail')) {
        String errorMsg = response['detail'].toString();

        if (errorMsg.contains('already exists')) {
          Get.snackbar('⚠️ Внимание', 'Этот пользователь уже зарегистрирован!',
              backgroundColor: Colors.orange);
        } else {
          Get.snackbar('❌ Ошибка', errorMsg, backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar('❌ Ошибка', 'Неизвестная ошибка регистрации',
            backgroundColor: Colors.red);
      }
    } catch (e) {
      dismissLoadingAlert();
      print("⚠️ Ошибка регистрации: $e");
      Get.snackbar(
          '❌ Ошибка', 'Не удалось зарегистрироваться. Попробуйте снова.',
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
