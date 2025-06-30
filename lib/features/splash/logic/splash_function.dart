import '../../../constans/imports.dart';

Future<void> splashFunctions(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 2));

  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

  // Tokenni tekshirish va kerak bo‘lsa yangilash
  if (!await profileProvider.isTokenValid()) {
    await profileProvider.refreshToken();
  }

  // Foydalanuvchi login bo‘lganmi?
  final isLoggedIn =
      Hive.box('profileBox').get('isLoggedIn', defaultValue: false);

  if (isLoggedIn) {
    // Ma'lumotlarni boshlang'ich yuklash (ixtiyoriy)
    await profileProvider.initProfile();
    await profileProvider.profileDachas();
    Get.offNamedUntil(Routes.homePage, (_) => false);
  } else {
    Get.offNamedUntil(Routes.registerPage, (_) => false);
  }
}
