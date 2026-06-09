import 'package:flutter/material.dart';
import 'dart:math';
import 'database_helper.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int _currentStep = 0; // 0: Email, 1: Code, 2: New Password
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String _generatedCode = '';
  Map<String, dynamic>? _foundUser;

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendCode() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showSnackBar('Please enter your email address.');
      return;
    }

    final user = await DatabaseHelper.instance.getUserByEmail(email);
    if (user == null) {
      _showSnackBar('No account found with that email address.');
      return;
    }

    _foundUser = user;
    
    // Generate a 6-digit code
    final rand = Random();
    _generatedCode = (100000 + rand.nextInt(900000)).toString();

    setState(() {
      _currentStep = 1;
    });

    // Show dialog with the code
    _showCodeDialog(_generatedCode);
  }

  void _showCodeDialog(String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        const Color purpleGlow = Color(0xFFBB86FC);
        return AlertDialog(
          backgroundColor: const Color(0xFF11162D),
          title: const Text('Test Environment', style: TextStyle(color: Colors.white)),
          content: Text(
            "Since this app doesn't have an email server configured yet, your code is displayed here:\n\n$code",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Got It', style: TextStyle(color: purpleGlow)),
            )
          ],
        );
      }
    );
  }

  void _verifyCode() {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      _showSnackBar('Please enter the code.');
      return;
    }

    if (code == _generatedCode) {
      setState(() {
        _currentStep = 2;
      });
    } else {
      _showSnackBar('Invalid code. Please try again.');
    }
  }

  void _resetPassword() async {
    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    if (newPass.isEmpty || confirmPass.isEmpty) {
      _showSnackBar('Please fill all fields.');
      return;
    }

    if (newPass != confirmPass) {
      _showSnackBar('Passwords do not match.');
      return;
    }

    if (_foundUser != null) {
      final username = _foundUser!['username'];
      bool success = await DatabaseHelper.instance.resetUserPassword(username, newPass);
      if (success) {
        if (!mounted) return;
        _showSnackBar('Password reset successfully. You can now login.', color: Colors.green);
        Navigator.pop(context);
      } else {
        _showSnackBar('Failed to reset password. Please try again later.');
      }
    }
  }

  void _showSnackBar(String message, {int duration = 3, Color color = Colors.redAccent}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: duration),
      ),
    );
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
                      child: const Icon(Icons.lock_reset_rounded, size: 40, color: purpleGlow),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      _currentStep == 0 
                        ? 'Forgot Password' 
                        : _currentStep == 1 
                          ? 'Verify Code' 
                          : 'New Password',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentStep == 0 
                        ? 'Enter your email to receive a reset code.' 
                        : _currentStep == 1 
                          ? 'Enter the 6-digit code sent to your email.' 
                          : 'Enter your new password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 16),
                    ),
                    const SizedBox(height: 40),
                    
                    if (_currentStep == 0) ...[
                      _buildTextField('Email Address', Icons.email_outlined, emailController),
                      const SizedBox(height: 40),
                      _buildButton('Send Code', _sendCode),
                    ] else if (_currentStep == 1) ...[
                      _buildTextField('6-digit Code', Icons.numbers, codeController),
                      const SizedBox(height: 40),
                      _buildButton('Verify Code', _verifyCode),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          // Resend Code logic
                          final rand = Random();
                          _generatedCode = (100000 + rand.nextInt(900000)).toString();
                          _showCodeDialog(_generatedCode);
                        },
                        child: Text('Resend Code', style: TextStyle(color: purpleGlow.withAlpha(200))),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentStep = 0;
                          });
                        },
                        child: Text('Back to Email', style: TextStyle(color: Colors.white54)),
                      ),
                    ] else if (_currentStep == 2) ...[
                      _buildTextField('New Password', Icons.lock_outline, newPasswordController, isPassword: true),
                      const SizedBox(height: 20),
                      _buildTextField('Confirm Password', Icons.lock_outline, confirmPasswordController, isPassword: true),
                      const SizedBox(height: 40),
                      _buildButton('Reset Password', _resetPassword),
                    ]
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

  Widget _buildButton(String text, VoidCallback onPressed) {
    const Color purpleGlow = Color(0xFFBB86FC);
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: purpleGlow,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 10,
          shadowColor: purpleGlow.withAlpha(100),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
      ),
    );
  }
}
