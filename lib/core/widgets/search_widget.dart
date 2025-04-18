import '../../constans/imports.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(LocalIcons.staple),
        const Gap(15),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TextField(
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
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(
                    LocalIcons.sticers,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Rating(),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: AppButton(
                      text: "Yuborish",
                      width: 300,
                      height: 50,
                      color: AppColors.primaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
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
