import '../../../../constans/imports.dart';

class CommentsWidget extends StatelessWidget {
  final CommentsModel comment;
  const CommentsWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        final userName = provider.profile?.name ?? "Noma'lum";
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(child: Image.asset(LocalImages.person)),
                  const Gap(8),
                  Text(userName),
                ],
              ),
              const Gap(8),
              Text(comment.comment),
            ],
          ),
        );
      },
    );
  }
}
