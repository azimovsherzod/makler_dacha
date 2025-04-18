import '../../../../constans/imports.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.chatPage),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Gap(8),
            Row(
              children: [
                CircleAvatar(child: Image.asset(LocalImages.person)),
                Gap(12),
                Text(
                  'Shahzod',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
            )
          ],
        ),
      ),
    );
  }
}
