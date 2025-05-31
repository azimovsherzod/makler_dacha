import '../../../../constans/imports.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(LocalImages.home1),
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Orzuingizdagi dachani toping – eng yaxshi takliflar sizni kutmoqda'
                      .tr,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 150.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Bizning platformamiz dachalar sotib olish va ijaraga olish uchun qulay qidiruv imkoniyatlarini taqdim etadi. Sizga mos joyni tez va oson toping!'
                        .tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textGrey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 50, 35),
        child: AppButton(
            height: 55,
            itemsAlignment: MainAxisAlignment.center,
            color: AppColors.primaryColor,
            text: 'Boshlash'.tr,
            textStyle: const TextStyle(fontSize: 17, color: Colors.white),
            onPressed: () {
              Get.offAllNamed(Routes.homePage);
            }),
      ),
    );
  }
}
