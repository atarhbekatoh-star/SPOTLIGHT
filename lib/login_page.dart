import 'package:flutter/material.dart';
import 'main.dart';
import 'database_helper.dart';
import 'forgot_password_page.dart';

// --- PAGE 2: LOGIN PAGE ---
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
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
          // Background Glow effect top right
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [purpleGlow.withAlpha(60), Colors.transparent],
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
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: purpleGlow.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_open_rounded, size: 40, color: purpleGlow),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Login to continue your journey.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    
                    _buildTextField('Username', Icons.person_outline, usernameController),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                    
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                            final user = await DatabaseHelper.instance.loginUser(
                              usernameController.text, 
                              passwordController.text
                            );

                            if (!context.mounted) return;

                            if (user != null) {
                              String fullName = user['fullName'] as String;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => MainScreen(
                                  currentThemeMode: ThemeMode.dark, 
                                  onThemeChanged: (mode) {},
                                  userName: user['username'],
                                  fullName: fullName,
                                )),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid username or password.'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter both username and password.'),
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
                        child: const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                          );
                        },
                        child: Text('Forgot Password?', style: TextStyle(color: purpleGlow.withAlpha(200))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller) {
    const Color purpleGlow = Color(0xFFBB86FC);
    const Color cardBackground = Color(0xFF11162D);
    return TextField(
      controller: controller,
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

  Widget _buildPasswordField() {
    const Color purpleGlow = Color(0xFFBB86FC);
    const Color cardBackground = Color(0xFF11162D);
    return TextField(
      controller: passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
        prefixIcon: Icon(Icons.lock_outline, color: purpleGlow.withAlpha(150)),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: purpleGlow.withAlpha(150),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
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