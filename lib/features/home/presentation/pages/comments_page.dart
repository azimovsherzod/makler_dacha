import '../../../../constans/imports.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              padding: EdgeInsets.only(bottom: 80),
              children: const [
                CommentsWidget(),
                Gap(12),
                CommentsWidget(),
                Gap(12),
                CommentsWidget(),
                Gap(12),
                CommentsWidget(),
                Gap(12),
                CommentsWidget(),
                Gap(12),
                CommentsWidget(),
                Gap(12),
                CommentsWidget(),
                Gap(12),
                CommentsWidget(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.white,
              child: SearchWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
