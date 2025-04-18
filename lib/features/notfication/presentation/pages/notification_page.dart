import '../../../../constans/imports.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 150),
            child: Text(
              "Notifications",
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: const [
            NotificationWidget(),
            Gap(12),
            NotificationWidget(),
            Gap(12),
            NotificationWidget(),
            Gap(12),
            NotificationWidget(),
            Gap(12),
            NotificationWidget(),
            Gap(12),
            NotificationWidget(),
            Gap(12),
            NotificationWidget(),
          ],
        ),
      ),
    );
  }
}
