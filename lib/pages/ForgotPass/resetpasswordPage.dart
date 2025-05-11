import 'package:prueb/screens/screens.dart';

class Resetpasswordpage extends StatelessWidget {
  const Resetpasswordpage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: buildCustomAppBar(screenHeight),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(
              'Reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'With great power comes great responsibility. Log in',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: screenWidth * 0.035),
            ),
            const SizedBox(height: 50),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  'Create a new password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ),
            ),
            buildPasswordField(
              context: context,
              controller: newPasswordController,
            ),
            const SizedBox(height: 40),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  'Confirm your new password',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035,
                  ),
                ),
              ),
            ),
            buildPasswordField(
              context: context,
              controller: confirmPasswordController,
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
                  context.push('/reset-password1');
                },
                child: Text(
                  'Send',
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 240,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.grey : Colors.white,
                  foregroundColor: isDarkMode ? Colors.white : Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
