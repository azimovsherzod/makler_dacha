import '../../../constans/imports.dart';

Future<void> splashFunctions(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 2));

  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

  final isLoggedIn =
      Hive.box('profileBox').get('isLoggedIn', defaultValue: false);

  if (!isLoggedIn) {
    // Foydalanuvchi login qilmagan bo‘lsa, token tekshirilmaydi, refresh qilinmaydi
    Get.offNamedUntil(Routes.registerPage, (_) => false);
    return;
  }

  try {
    await profileProvider.refreshToken();
    await profileProvider.initProfile();
    await profileProvider.profileDachas();
  } catch (e) {
    print("Token yoki profil yangilashda xatolik: $e");
  }

  Get.offNamedUntil(Routes.maklerHome, (_) => false);
}
