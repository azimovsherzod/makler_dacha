import '../../../../constans/imports.dart';

class ListingCardProfile extends StatelessWidget {
  final DachaModel dacha;
  final List<String> addressOptions;

  const ListingCardProfile({
    super.key,
    required this.dacha,
    required this.addressOptions,
  });

  @override
  Widget build(BuildContext context) {
    String selectedAddress = dacha.address;
    bool isActive = dacha.isActive;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          print("Card tapped: \${dacha.name}");
          Get.toNamed(Routes.profileDetail);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      (dacha.images != null && dacha.images.isNotEmpty)
                          ? dacha.images.first
                          : "https://get.wallhere.com/photo/temple-reflection-Tourism-tower-France-Paris-Eiffel-Tower-pagoda-tree-landmark-wat-place-of-worship-87935.jpg",
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                        dacha.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isActive ? "Active" : "Not Active",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "\$${dacha.price}/sutka",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(dacha.address),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InfoIconWithText(
                        icon: LocalIcons.bed, text: "${dacha.bedsCount}"),
                    InfoIconWithText(
                        icon: LocalIcons.bath, text: "${dacha.hallCount}"),
                  ],
                ),
              ),
              const Gap(12),
            ],
          ),
        ),
      ),
    );
  }
}
