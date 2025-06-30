import 'package:makler_dacha/constans/imports.dart';

class SearchWidget extends StatefulWidget {
  final String dachaId;
  const SearchWidget({Key? key, required this.dachaId}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();

  void _sendComment() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await profileProvider.sendDachaComment(
        dachaId: int.parse(widget.dachaId),
        comment: text,
        userId: profileProvider.profile?.id ?? 0, // id int bo‘lsa
      );
      _controller.clear(); // TextField bo‘shatish
      FocusScope.of(context).unfocus(); // Klaviaturani yopish
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TextField(
              controller: _controller,
              maxLength: 150,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
                labelStyle: const TextStyle(color: Colors.grey),
                hintText: "Сообщения",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: _sendComment,
          icon: const Icon(
            Icons.send,
            color: AppColors.primaryColor,
            size: 30,
          ),
        )
      ],
    );
  }
}
