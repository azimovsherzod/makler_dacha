import '../../constans/imports.dart';

Future<bool> refreshToken() async {
  final refresh = await box.read('refresh');
  if (refresh == null) {
    await box.remove('token');
    await box.remove('refresh');
    Get.offAllNamed(Routes.loginPage);
    return false;
  }

  try {
    final response = await dio.post(
      '/refresh',
      data: {
        'refresh_token': refresh
      }, // Отправляем refresh_token в тело запроса
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    // Проверяем, что API вернуло новые токены
    if (response.data != null && response.data['data'] != null) {
      await box.write('token', response.data['data']['access_token']);
      await box.write('refresh', response.data['data']['refresh_token']);
      return true;
    }
  } catch (e) {
    await box.remove('token');
    await box.remove('refresh');
    Get.offAllNamed(Routes.loginPage);
  }

  return false;
}
