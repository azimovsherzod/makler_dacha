import '../../../../constans/imports.dart';

class ProfileDetail extends StatelessWidget {
  final DachaModel? dacha;

  const ProfileDetail({Key? key, this.dacha}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dacha == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Dacha ma'lumotlari mavjud emas"),
        ),
        body: const Center(
          child: Text(
            "Dacha ma'lumotlari mavjud emas.",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                final profileProvider =
                    Provider.of<ProfileProvider>(context, listen: false);
                final dacha = profileProvider.selectedDacha;

                if (dacha != null) {
                  Get.toNamed(Routes.editPage, arguments: dacha);
                } else {
                  print("Ошибка: dachaModel = null");
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Gap(8),
                    Text('4.5K'),
                  ],
                ),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primaryColor,
                  ),
                  child: Text(
                      '${dacha!.clientType}', // `dacha!` bilan null emasligini tasdiqlaymiz
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.only(left: 240.0),
              child: TextButton(
                onPressed: () {
                  Get.toNamed(Routes.commentsPages);
                },
                child: const Text("Hammasini ko'rish"),
              ),
            ),
            const Gap(12),
            CommentsWidget(),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Billiard',
                  style: TextStyle(fontSize: 20),
                ),
                Switch(
                    activeTrackColor: AppColors.primaryColor,
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                    value: true,
                    onChanged: (_) {})
              ],
            ),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Karaoke',
                  style: TextStyle(fontSize: 20),
                ),
                Switch(
                    activeTrackColor: AppColors.primaryColor,
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                    value: true,
                    onChanged: (_) {})
              ],
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.only(left: 200.0),
              child: SizedBox(
                width: 150,
                height: 50,
                child: AppButton(
                  text: "So'rov yuboring",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
