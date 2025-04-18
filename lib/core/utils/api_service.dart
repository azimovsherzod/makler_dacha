import 'dart:convert';

import '../../../../constans/imports.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl, // API bazaviy URL
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  ApiService() {
    // Tokenni avtomatik qo'shish uchun interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = Hive.box('profileBox').get('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioError e, handler) {
        if (e.response?.statusCode == 401) {
          // Token muddati tugagan bo'lsa, foydalanuvchini logout qilish
          Get.snackbar(
            "Авторизация",
            "Срок действия токена истек. Пожалуйста, войдите снова.",
            backgroundColor: Colors.red,
          );
        }
        return handler.next(e);
      },
    ));
  }

  Future<dynamic> makeGetRequest(String url) async {
    try {
      print("📡 GET $url");
      final response = await dio.get(url);

      // Log javob
      print("✅ Статус ответа: ${response.statusCode}");
      print("✅ Ответ сервера: ${response.data}");

      // JSONni to'g'ri aylantirish
      if (response.data is Map) {
        return Map<String, dynamic>.from(
            response.data); // To'g'ri turga aylantirish
      } else if (response.data is List) {
        return List<dynamic>.from(response.data);
      } else {
        print("⚠️ Noma'lum formatdagi javob: ${response.data}");
        return response.data;
      }
    } on DioError catch (e) {
      _handleError(e, "GET", url);
      return null;
    }
  }

  Future<dynamic> makePostRequest(String url,
      {Map<String, dynamic>? data}) async {
    try {
      print("📡 POST $url");
      print("📦 Ma'lumotlar: $data");

      final response = await dio.post(url, data: data);

      // Log javob
      print("✅ Статус ответа: ${response.statusCode}");
      print("✅ Ответ сервера: ${response.data}");

      // JSONni to'g'ri aylantirish
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      } else if (response.data is List) {
        return List<dynamic>.from(response.data);
      } else {
        print("⚠️ Noma'lum formatdagi javob: ${response.data}");
        return response.data;
      }
    } on DioError catch (e) {
      _handleError(e, "POST", url);
      return null;
    }
  }

  Future<void> saveUserIdFromToken() async {
    try {
      final box = Hive.box('profileBox');
      final token = box.get('access_token');

      if (token == null) {
        print("⚠️ Token mavjud emas!");
        return;
      }

      // Tokenni dekodlash
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception("❌ Неправильный формат токена");
      }

      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final Map<String, dynamic> decodedToken = json.decode(payload);

      // user_id ni olish
      final userId = decodedToken['user_id'];
      if (userId == null) {
        print("❌ Token ichida user_id mavjud emas!");
        return;
      }

      // user_id ni saqlash
      box.put('user_id', userId);
      print("✅ user_id saqlandi: $userId");
    } catch (e) {
      print("❌ saveUserIdFromToken() xatosi: $e");
    }
  }

  Future<dynamic> makePutRequest(String url,
      {Map<String, dynamic>? data}) async {
    try {
      print("📡 PUT $url");
      print("📦 Ma'lumotlar: $data");

      final response = await dio.put(url, data: data);

      // Log javob
      print("✅ Статус ответа: ${response.statusCode}");
      print("✅ Ответ сервера: ${response.data}");

      // JSONni to'g'ri aylantirish
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      } else if (response.data is List) {
        return List<dynamic>.from(response.data);
      } else {
        print("⚠️ Noma'lum formatdagi javob: ${response.data}");
        return response.data;
      }
    } on DioError catch (e) {
      _handleError(e, "PUT", url);
      return null;
    }
  }

  Future<dynamic> makeDeleteRequest(String url) async {
    try {
      print("📡 DELETE $url");

      final response = await dio.delete(url);

      // Log javob
      print("✅ Статус ответа: ${response.statusCode}");
      print("✅ Ответ сервера: ${response.data}");

      // JSONni to'g'ri aylantirish
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      } else if (response.data is List) {
        return List<dynamic>.from(response.data);
      } else {
        print("⚠️ Noma'lum formatdagi javob: ${response.data}");
        return response.data;
      }
    } on DioError catch (e) {
      _handleError(e, "DELETE", url);
      return null;
    }
  }

  void _handleError(DioError e, String method, String endpoint) {
    if (e.response != null) {
      print("❌ Ошибка ($method ${e.response!.statusCode}): $endpoint");
      print("❌ Детали ошибки: ${e.response!.data}");
      Get.snackbar(
        "Ошибка",
        "Ошибка $method-запроса: ${e.response!.statusCode}",
        backgroundColor: Colors.red,
      );
    } else {
      print("❌ Неизвестная ошибка при $method-запросе: $e");
      Get.snackbar(
        "Ошибка",
        "Неизвестная ошибка при $method-запросе",
        backgroundColor: Colors.red,
      );
    }
  }
}
