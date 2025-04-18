import '../../../../constans/imports.dart';

class AutoScrollingImageWidget extends StatefulWidget {
  final List<String>? images; // Добавляем images как поле

  const AutoScrollingImageWidget({
    super.key,
    this.images, // Делаем его необязательным
  });

  @override
  State<AutoScrollingImageWidget> createState() =>
      _AutoScrollingImageWidgetState();
}

class _AutoScrollingImageWidgetState extends State<AutoScrollingImageWidget> {
  late PageController pageController;
  Timer? _timer;
  int _currentPage = 0;

  List<String> get imagePaths => widget.images ?? _defaultImages;

  final List<String> _defaultImages = [
    LocalImages.dachaImg,
    LocalImages.home1,
    LocalImages.logo,
    LocalImages.map
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) {
        if (_currentPage < imagePaths.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        if (mounted && pageController.hasClients) {
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
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: PageView.builder(
        controller: pageController,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePaths[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
                  errorBuilder: (context, error, stackTrace) {
                    return const Placeholder();
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
                  child: const Text(
                    "Shahzod Dasdasdaa",
                    style: TextStyle(color: AppColors.primaryColor),
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
                      const Text(
                        "active",
                        style: TextStyle(color: Colors.green),
                      ),
                      const Gap(5),
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
