import '../../../../constans/imports.dart';

class CommentsPage extends StatelessWidget {
  final DachaModel dacha;
  const CommentsPage({super.key, required this.dacha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Consumer<ProfileProvider>(
              builder: (context, provider, child) {
                print('dacha.id: ${dacha.id}');
                print(
                    'COMMENTS: ${provider.comments.map((e) => e.dacha).toList()}');
                final comments = provider.comments
                    .where((c) => c.dacha == dacha.id.toString())
                    .toList();
                print('FILTERED: $comments');

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];

                    return Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: CommentsWidget(comment: comment),
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.white,
              child: SearchWidget(
                  dachaId: dacha.id.toString()), // <-- dachaId ni uzating
            ),
          ),
        ],
      ),
    );
  }
}
