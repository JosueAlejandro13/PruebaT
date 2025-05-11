import 'package:prueb/screens/screens.dart';

class Resetpassword1page extends StatelessWidget {
  const Resetpassword1page({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Recuperar el modo oscuro del tema actual
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: buildCustomAppBar(screenHeight),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 90),
              Text(
                'Password changed successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.white : Colors.grey,
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Lógica de envío
                    context.push('/login');
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
