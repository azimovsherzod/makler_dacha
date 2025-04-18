import '../../../../constans/imports.dart';

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(child: Image.asset(LocalImages.person)),
              const Gap(8),
              const Text('Shahzod')
            ],
          ),
          Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.')
        ],
      ),
    );
  }
}
