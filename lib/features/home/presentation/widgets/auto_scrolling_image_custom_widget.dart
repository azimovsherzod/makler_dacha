import '../../../../constans/imports.dart';

class AutoScrollingImageCustomWidget extends StatefulWidget {
  final int index;

  const AutoScrollingImageCustomWidget({super.key, required this.index});

  @override
  State<AutoScrollingImageCustomWidget> createState() =>
      _AutoScrollingImageCustomWidgetState();
}

class _AutoScrollingImageCustomWidgetState
    extends State<AutoScrollingImageCustomWidget> {
  late PageController pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) {
        if (!mounted) return;

        setState(() {
          _currentPage++;
          final dacha = context.read<ProfileProvider>().dachas[widget.index];
          if (_currentPage >= (dacha.images?.length ?? 1)) {
            _currentPage = 0;
          }
        });

        if (pageController.hasClients) {
          pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final dacha = profileProvider.dachas[widget.index];

        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.imageViewerPage, arguments: dacha.images ?? []);
          },
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: PageView.builder(
              controller: pageController,
              itemCount:
                  dacha.images?.isNotEmpty == true ? dacha.images!.length : 1,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        dacha.images?.isNotEmpty == true
                            ? dacha.images![index]
                            : "https://via.placeholder.com/300",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image,
                              size: 50, color: Colors.red);
                        },
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Text(
                          dacha.name.isNotEmpty ? dacha.name : "No Name",
                          style: const TextStyle(color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text(
                              dacha.isActive ? "Active" : "Inactive",
                              style: TextStyle(
                                color:
                                    dacha.isActive ? Colors.green : Colors.red,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.check_circle,
                              color: dacha.isActive ? Colors.green : Colors.red,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
