import 'package:flutter/material.dart';
import 'main.dart';
import 'database_helper.dart';

// --- PAGE 3: REGISTER PAGE ---
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color purpleGlow = Color(0xFFBB86FC);
    const Color darkBackground = Color(0xFF060914);

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        iconTheme: const IconThemeData(color: purpleGlow),
      ),
      body: Stack(
        children: [
          // Background Glow effect top left
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [purpleGlow.withAlpha(50), Colors.transparent],
                ),
                boxShadow: [
                  BoxShadow(color: purpleGlow.withAlpha(40), blurRadius: 100, spreadRadius: 50),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView( 
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                curve: Curves.easeOutQuart,
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: purpleGlow.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_add_alt_1_rounded, size: 40, color: purpleGlow),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Join Spotlight to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 16),
                    ),
                    const SizedBox(height: 35),
                    
                    _buildTextField('Full Name', Icons.badge_outlined, fullNameController),
                    const SizedBox(height: 15),
                    _buildTextField('Email Address', Icons.email_outlined, emailController),
                    const SizedBox(height: 15),
                    _buildTextField('Username', Icons.person_outline, usernameController),
                    const SizedBox(height: 15),
                    _buildTextField('Password', Icons.lock_outline, passwordController, isPassword: true),
                    const SizedBox(height: 15),
                    _buildTextField('Confirm Password', Icons.lock_outline, confirmPasswordController, isPassword: true),
                    
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          final String fullName = fullNameController.text;
                          final String email = emailController.text;
                          final String username = usernameController.text;
                          final String password = passwordController.text;
                          final String confirmPassword = confirmPasswordController.text;

                          if (fullName.isEmpty ||
                              email.isEmpty ||
                              username.isEmpty ||
                              password.isEmpty ||
                              confirmPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all the fields.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          // Validate email format
                          if (!email.contains('@') || !email.contains('.')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid email address.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          // Validate passwords match
                          if (password != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match.'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            return;
                          }

                          try {
                            Map<String, dynamic> newUser = {
                              'fullName': fullName,
                              'email': email,
                              'username': username,
                              'password': password,
                            };

                            int result = await DatabaseHelper.instance.createUser(newUser);

                            if (!context.mounted) return;

                            if (result == -1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Username already exists. Please choose another.'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MainScreen(
                                  currentThemeMode: ThemeMode.dark, 
                                  onThemeChanged: (mode) {},
                                  userName: username,
                                  fullName: fullName,
                                )),
                              );
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: Please fully STOP and rerun the app. (Details: $e)'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: purpleGlow,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 10,
                          shadowColor: purpleGlow.withAlpha(100),
                        ),
                        child: const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    const Color purpleGlow = Color(0xFFBB86FC);
    const Color cardBackground = Color(0xFF11162D);
    return TextField(
      controller: controller, 
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
        prefixIcon: Icon(icon, color: purpleGlow.withAlpha(150)),
        filled: true,
        fillColor: cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withAlpha(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: purpleGlow),
        ),
      ),
    );
  }
}
