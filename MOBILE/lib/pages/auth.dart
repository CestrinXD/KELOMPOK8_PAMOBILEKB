import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sofa_score/services/auth_services.dart';
import 'package:sofa_score/util/custom_text_field.dart';
import 'package:intl/intl.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyRegister = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  TextEditingController username = TextEditingController();
  TextEditingController passwordLogin = TextEditingController();
  TextEditingController passwordRegis = TextEditingController();
  TextEditingController tanggalLahir = TextEditingController();
  TextEditingController emailLogin = TextEditingController();
  TextEditingController emailRegis = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late TabController _tabController;
  bool _agreedToTerms = false;
  bool _autoLogin = false;
  var gender = "";
  DateTime? _selectedDate;
  String? _country;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Add a listener to update the state when the tab changes
    _tabController.addListener(() {
      setState(() {}); // Call setState to trigger a rebuild
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            DateFormat('d MMMM, yyyy').format(_selectedDate!);
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        // Setelah login berhasil, navigasi ke home_page
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home_page');
        }
      } else {
        if (kDebugMode) {
          print('Login canceled or failed');
        }
      }
    } catch (e) {
      // Tangani error jika login gagal
      if (kDebugMode) {
        print('Error logging in with Google: $e');
      }
    }
  }

  Future<void> _login() async {
    try {
      if (kDebugMode) {
        print('Email: ${emailLogin.text.trim()}');
      }
      if (kDebugMode) {
        print('Password: ${passwordLogin.text.trim()}');
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailLogin.text.trim(),
        password: passwordLogin.text.trim(),
      );

      // Navigate to home page after successful login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home_page');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  Future<void> _register() async {
    if (_formKeyRegister.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailRegis.text.trim(),
          password: passwordRegis.text.trim(),
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home_page');
        }
      } on FirebaseAuthException catch (e) {
        _showErrorMessage(e.message);
      } on SocketException {
        _showErrorMessage('No Internet connection');
      } catch (e) {
        _showErrorMessage('An unexpected error occurred');
      }
    }
  }

  void _showErrorMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? 'An error occurred')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sofa Score'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Text(
                _tabController.index == 0
                    ? 'Welcome Back'
                    : "Let's Get Started",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _tabController.index == 0
                    ? 'Please login with your account'
                    : "Please create your account",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Sign In"),
                  Tab(text: "Sign Up"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // sign in
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKeyLogin,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: emailLogin,
                    label: "Email",
                    hint: "Enter Your Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordLogin,
                    label: "Password",
                    hint: "Enter Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Remember Me'),
                    trailing: Switch(
                      value: _autoLogin,
                      onChanged: (bool value) {
                        setState(() {
                          _autoLogin = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _loginWithGoogle, // login dengan Google
                      child: const Text('Login with Google'),
                    ),
                  )
                ],
              ),
            ),
          ),
          // sign up
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKeyRegister,
              child: ListView(
                // physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 6),
                  CustomTextField(
                    controller: username,
                    label: "Username",
                    hint: "Enter Username",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: emailRegis,
                    label: "Email",
                    hint: "Enter Your Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _dateController,
                    label: "Birth Date",
                    hint: "Select Birth Date",
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your birthdate';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordRegis,
                    label: "Password",
                    hint: "Enter A Password",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  const Text("Pilih Negara"),
                  DropdownButtonFormField<String>(
                    value: _country,
                    items: <String>[
                      'Indonesia',
                      'Malaysia',
                      'Singapore',
                      'Thailand'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    hint: const Text('Select Country'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _country = newValue;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('I agree to the terms and conditions'),
                    leading: Checkbox(
                      value: _agreedToTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          _agreedToTerms = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _register,
                      child: const Text('Register'),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: _loginWithGoogle, // Registrasi dengan Google
                      child: const Text('Register with Google'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
