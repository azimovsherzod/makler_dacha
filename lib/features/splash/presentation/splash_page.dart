import '../../../constans/imports.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final box = Hive.box('profileBox');
      final isLoggedIn = box.get('isLoggedIn', defaultValue: false);

      if (isLoggedIn) {
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        await profileProvider.refreshToken();
        await profileProvider.fetchAllData();
        Get.offAllNamed(Routes.homePage);
      } else {
        Get.offAllNamed(Routes.registerPage);
      }
    });

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(color: AppColors.primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(LocalImages.logo, width: Get.width * 0.5),
            const Gap(10),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
