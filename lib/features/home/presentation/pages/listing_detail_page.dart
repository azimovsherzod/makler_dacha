import '../../../../constans/imports.dart';

class ListingDetailPage extends StatelessWidget {
  final DachaModel dacha;

  const ListingDetailPage({Key? key, required this.dacha}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listing Detail',
          overflow: TextOverflow.ellipsis, // Matnni cheklash
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                if (profileProvider.dachas.isEmpty) {
                  return const Center(
                    child: Text("Нет доступных дач"),
                  );
                }

                return ListingCardCustom(
                  dacha: profileProvider.dachas.first, // Передаем первую дачу
                );
              },
            ),
            const Gap(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      RatingBar.builder(
                        minRating: 1,
                        direction: Axis.horizontal,
                        ignoreGestures: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (double value) {},
                      ),
                      const Gap(8),
                      const Text('4.5K'),
                    ],
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primaryColor,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('${dacha.clientType}',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.only(left: 210.0),
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
            _buildSwitchTile('Billiard', true),
            _buildSwitchTile('Karaoke', true),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.only(left: 200.0),
              child: AppButton(
                text: "So'rov yuboring",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const Gap(50),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(context),
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(fontSize: 20),
            overflow: TextOverflow.ellipsis, // Matnni cheklash
          ),
        ),
        Switch(
          activeTrackColor: AppColors.primaryColor,
          activeColor: Colors.white,
          inactiveThumbColor: Colors.black,
          inactiveTrackColor: Colors.white,
          value: value,
          onChanged: (_) {},
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: _buildDialogButton(
              context,
              "Komment",
              "Komment",
              "Komment",
            ),
          ),
          const Gap(12),
          Flexible(
            flex: 1,
            child: _buildDialogButton(
              context,
              "Shikoyat",
              "Shikoyat",
              "Shikoyat",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButton(
      BuildContext context, String buttonText, String title, String hintText) {
    return AppButton(
      text: buttonText,
      width: 180,
      height: 50,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            actions: [
              TextField(
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
                maxLines: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: AppButton(
                  text: "Yuborish",
                  width: 300,
                  height: 50,
                  color: AppColors.primaryColor,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.profileDetail,
                      arguments: dacha,
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
