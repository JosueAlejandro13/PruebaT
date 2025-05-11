import 'package:prueb/screens/screens.dart';

class Signuppage extends StatelessWidget {
  const Signuppage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          // Contenido desplazable
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  'With great power comes great responsibility. Log in',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
                const SizedBox(height: 16),
                _buildLabel(context, 'Username', screenWidth),
                _buildTextField(context, Icons.person, ''),

                _buildLabel(context, 'Email', screenWidth),
                _buildTextField(context, Icons.email, ''),

                _buildLabel(context, 'Password', screenWidth),
                buildPasswordField(context: context),

                _buildLabel(context, 'Confirm password', screenWidth),
                buildPasswordField(context: context),

                const SizedBox(height: 20),

                buildCustomButton(
                  context: context,
                  text: 'Create account',
                  isDarkMode: isDarkMode,
                  onPressed: () {
                    context.push('/account-verification');
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    StatefulBuilder(
                      builder: (context, setState) {
                        bool isChecked = false;
                        return Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF0886B5),
                        );
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the Terms of Service and Privacy Policy',
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // Texto "or continue with"
                Text(
                  'or continue with Google or Facebook',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSocialIcon(
                      icon: FontAwesomeIcons.google,
                      color: Colors.red,
                    ),
                    buildSocialIcon(
                      icon: FontAwesomeIcons.facebookF,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, IconData icon, String hintText) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: TextField(
        style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.033),

        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF0886B5)),
          hintText: hintText,
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text, double screenWidth) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.035,
          ),
        ),
      ),
    );
  }

}
