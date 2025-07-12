import '../../../../constans/imports.dart';

class CustomSearchContainer extends StatelessWidget {
  final IconData leftIcon;
  final String placeholderText;

  const CustomSearchContainer({
    super.key,
    this.leftIcon = Icons.search,
    this.placeholderText = "Manzil, shahar yoki pochta indeksini qidiring",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color(0xFFF2F2F2), // Цвет фона
      ),
      child: GestureDetector(
        onTap: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(
              searchTerms: [
                "Toshkent",
                "Chirchiq",
                "Qoranqul",
                "Samarqand",
                "Buxoro"
              ],
            ),
          );
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(16),
              SvgPicture.asset(
                LocalIcons.search,
                width: 24,
                height: 24,
                color: Colors.black54,
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  placeholderText,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
            ]
            // const Gap(16),],
            ),
      ),
    );
  }
}
