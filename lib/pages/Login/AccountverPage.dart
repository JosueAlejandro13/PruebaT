import 'package:prueb/screens/screens.dart';

class Accountverpage extends StatelessWidget {
  const Accountverpage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Recuperar el modo oscuro del tema actual
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: buildCustomAppBar(screenHeight),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/fond.jpg',
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 90),
                  Text(
                    'Account verification required',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Please check your email to verify your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'If you did not receive the email, please check your spam folder.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                  const SizedBox(height: 50),
                  buildCustomButton(
                    context: context,
                    onPressed: () {
                      // Lógica de envío
                      context.push('/login');
                    },
                    isDarkMode: isDarkMode,
                    text: 'Resend verification email', 
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
