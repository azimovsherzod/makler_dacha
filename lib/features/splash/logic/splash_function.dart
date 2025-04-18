import '../../../constans/imports.dart';

Future<void> splashFunctions(BuildContext context) async {
  await Future.delayed(Duration(seconds: 2));
  // refreshToken()
  // Oldin registratsiya o'tganmi?
  // init data
  Get.offNamedUntil(Routes.registerPage, (_) => false);
}
