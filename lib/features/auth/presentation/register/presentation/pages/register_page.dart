import '../../../../../../constans/imports.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _lastController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: AppColors.primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(140, 120, 0, 0),
            child: Text(
              "Register",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Montserrat',
                color: Colors.white,
              ),
            ),
          ),
          // Register card
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: _buildRegisterForm(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Gap(24),
        Form(
          key: _formKey,
          child: Column(
            children: [
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
              const Gap(16),
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
              const Gap(16),
              CustomTextField(
                controller: _lastController,
                label: "Last name",
                keyboardType: TextInputType.name,
                validators: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const Gap(16),
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
        Row(
          children: [
            Checkbox(
                activeColor: AppColors.primaryColor,
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                }),
            const Text("Remember me", style: TextStyle(color: Colors.black)),
          ],
        ),
        const Gap(16),
        AppButton(
          text: "Register",
          color: AppColors.primaryColor,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              print("Registering...");
            }
          },
        ),
        const Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?",
                style: TextStyle(color: Colors.black)),
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
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final String prefix;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? Function(String?) validators;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        letterSpacing: 1.2,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: widget.prefix,
        prefixStyle: const TextStyle(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: const TextStyle(color: AppColors.primaryColor),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.textGrey, width: 2.0),
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

        // 👇 Password icon only if obscureText is true
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey, // kulrang
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
      ),
      validator: widget.validators,
    );
  }
}
