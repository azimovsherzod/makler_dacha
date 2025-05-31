import '../../../../constans/imports.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(LocalImages.logosTelegram),
            const Gap(40),
            Text(
              "Guruhlar chiqishi uchun telegramga ulaning!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            const Gap(40),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: AppButton(
                text: "Yuborish",
                onPressed: () {
                  Get.toNamed(Routes.groupLogin);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
