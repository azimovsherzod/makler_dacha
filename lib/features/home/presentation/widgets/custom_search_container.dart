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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Container(
        height: 50, // Фиксированная высота
        width: MediaQuery.of(context).size.width, // Заполняем всю ширину экрана
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color(0xFFF2F4FD),
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
              const SizedBox(width: 16), // Отступ слева
              SvgPicture.asset(
                LocalIcons.search,
                width: 24,
                height: 24,
                color: Colors.black54,
              ),
              const SizedBox(width: 12), // Отступ между иконкой и текстом
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
              const SizedBox(width: 16), // Отступ справа
            ],
          ),
        ),
      ),
    );
  }
}
