import '../../../../constans/imports.dart';

class ImageDatailWidget extends StatelessWidget {
  const ImageDatailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(LocalIcons.close),
          ),
          const Text("1/10")
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
