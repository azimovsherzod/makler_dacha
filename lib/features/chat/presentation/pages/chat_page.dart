import '../../../../constans/imports.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "New home for Sale",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Gap(12),
            const DateWidget(),
            const Gap(12),
            const MessageWidget(
              message: "Hi! What’s your favorite way to spend a Sunday?",
              time: "12:10",
              isSentByUser: false,
            ),
            const MessageWidget(
              message: "Hi! What’s your favorite way to spend ",
              time: "12:10pm",
              isSeen: true,
              isSentByUser: true,
            ),
            const Spacer(),
            const SearchWidget(),
            const Gap(12),
          ],
        ),
      ),
    );
  }
}
