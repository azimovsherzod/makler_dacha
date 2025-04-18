import '../../../../constans/imports.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: const Column(
        children: [
          CustomSearchContainer(
            placeholderText: "Manzil, shaharni qidiring",
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Search Results will appear here",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
