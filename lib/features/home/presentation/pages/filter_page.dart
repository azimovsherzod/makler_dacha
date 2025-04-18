import '../../../../constans/imports.dart';

class FilterPage extends StatefulWidget {
  final String city;
  const FilterPage({Key? key, required this.city}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // Move selectedType to state
  String selectedType = '';
  String? currentlyValue = 'UZS';
  final List<String> types = ['All', 'Oilali', 'Qizlar', 'Bollar', 'Lyuboy'];
  int _counter = 0;
  int _counter2 = 0;
  final TextEditingController _mincontroller = TextEditingController();
  final TextEditingController _maxcontroller = TextEditingController();
  void _IncrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _IncrementCounter3() {
    setState(() {
      _counter2--;
    });
  }

  void _resetController() {
    setState(() {
      _counter2 = 0;
      _counter = 0;
      _mincontroller.clear();
      _maxcontroller.clear();
      selectedType = '';
      currentlyValue = 'UZS';
    });
  }

  void _IncrementCounter4() {
    setState(() {
      _counter--;
    });
  }

  void _IncrementCounter2() {
    setState(() {
      _counter2++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.city),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Narxi',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Gap(20.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mincontroller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Min',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const Gap(20.0),
                  Expanded(
                    child: TextField(
                      controller: _maxcontroller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Max',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(20.0),
              const Text('Klient tipi', style: TextStyle(fontSize: 20)),
              const Gap(20.0),
              // Display the types
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: types.map(
                        (type) {
                          final isSelected = selectedType == type;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedType = type;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
              const Gap(20),
              const Text("Valyuta tipi", style: TextStyle(fontSize: 20)),
              const Gap(20),
              Row(
                children: [
                  Radio<String>(
                    fillColor:
                        MaterialStateProperty.all(AppColors.primaryColor),
                    value: "UZS",
                    groupValue: currentlyValue,
                    onChanged: (value) {
                      setState(() {
                        currentlyValue = value!;
                      });
                    },
                  ),
                  const Text("UZS"),
                  Radio<String>(
                    fillColor:
                        MaterialStateProperty.all(AppColors.primaryColor),
                    value: "USD",
                    groupValue: currentlyValue,
                    onChanged: (value) {
                      setState(() {
                        currentlyValue = value!;
                      });
                    },
                  ),
                  const Text("USD"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Spalniy", style: TextStyle(fontSize: 20)),
                  const Gap(20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                    ),
                    child: const Text(
                      "-",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _IncrementCounter4();
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      '$_counter',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                    ),
                    child: const Text(
                      "+",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _IncrementCounter();
                    },
                  ),
                ],
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sanuzel", style: TextStyle(fontSize: 20)),
                  const Gap(20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                    ),
                    child: const Text(
                      "-",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _IncrementCounter3();
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      "$_counter2",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.primaryColor),
                    ),
                    child: const Text(
                      "+",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      _IncrementCounter2();
                    },
                  ),
                ],
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SizedBox(
                        // width: 300,
                        child: AppButton(
                          text: "Bekor qilish",
                          textStyle: TextStyle(color: Colors.white),
                          onPressed: () {
                            _resetController();
                          },
                        ),
                      ),
                    ),
                    const Gap(20),
                    Flexible(
                      child: SizedBox(
                        // width: 300,
                        child: AppButton(
                          text: "Tasdiqlash",
                          textStyle: TextStyle(color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
