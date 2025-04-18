import '../../../../../../constans/imports.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastController = TextEditingController();
  final _surnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 8, 19),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(20, 120, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Register",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const Gap(40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      prefix: '+998 ',
                      maxLength: 12,
                      keyboardType: TextInputType.phone,
                      validators: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length != 12) {
                          return 'Phone number must be exactly 12 characters';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                        PhoneNumberInputFormatter(),
                      ],
                    ),
                    const Gap(20),
                    CustomTextField(
                      controller: _nameController,
                      label: "Name",
                      keyboardType: TextInputType.name,
                      validators: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),
                    CustomTextField(
                      controller: _surnameController,
                      label: "Surname",
                      keyboardType: TextInputType.name,
                      validators: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your surname';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),
                    CustomTextField(
                      controller: _lastController,
                      label: "Lastname",
                      keyboardType: TextInputType.name,
                      validators: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your surname';
                        }
                        return null;
                      },
                    ),
                    const Gap(20),
                    CustomTextField(
                      controller: _passwordController,
                      label: "Password",
                      obscureText: true,
                      validators: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const Gap(12),
              AppButton(
                text: "Register",
                color: AppColors.primaryColor,
                onPressed: () async {
                  final authProvider = context.read<AuthProvider>();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print("Registering...");
                    print(
                        "Data: ${_phoneController.text}, ${_passwordController.text}");

                    try {
                      await authProvider.register(
                        _usernameController.text,
                        _nameController.text,
                        _phoneController.text,
                        _surnameController.text,
                        _firstnameController.text,
                        _lastController.text,
                        _passwordController.text,
                      );
                    } catch (e) {
                      print("Register Error: $e");
                    }
                  }
                },
              ),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already registered?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offNamedUntil(Routes.loginPage, (_) => false);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    String prefix = "",
    int? maxLength,
    TextInputType? keyboardType,
    required String? Function(String?) validators,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        prefixStyle: const TextStyle(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        ),
      ),
      validator: validators,
    );
  }
}

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String label;
  bool obscureText = false;
  String prefix = "";
  int? maxLength;
  TextInputType? keyboardType;
  String? Function(String?) validators;
  List<TextInputFormatter>? inputFormatters;
  CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.prefix = "",
    this.maxLength,
    this.keyboardType,
    required this.validators,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        prefixStyle: const TextStyle(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        ),
      ),
      validator: validators,
    );
  }
}
