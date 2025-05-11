// ignore_for_file: dead_code

import 'package:prueb/screens/screens.dart';

//botones
Widget buildCustomButton({
  required BuildContext context,
  required String text,
  required bool isDarkMode,
  required VoidCallback onPressed,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  return SizedBox(
    width: 240,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.white : Colors.grey,
        foregroundColor: isDarkMode ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: screenWidth * 0.035)),
    ),
  );
}

Widget buildCustomButtonHome({
  required BuildContext context,
  required String text,
  required bool isDarkMode,
  required VoidCallback onPressed,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  return SizedBox(
    width: 100,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.white : Colors.grey,
        foregroundColor: isDarkMode ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: screenWidth * 0.035)),
    ),
  );
}

// Campos iconos de redes sociales
Widget buildSocialIcon({
  required IconData icon,
  required Color color,
  VoidCallback? onPressed,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: IconButton(
      icon: FaIcon(icon, color: color),
      onPressed: onPressed ?? () {},
    ),
  );
}

PreferredSizeWidget buildCustomAppBar(double screenHeight) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Center(
      child: Icon(
        Icons.movie,
        size: screenHeight * 0.08,
        color: const Color(0xFF0886B5),
      ),
    ),
  );
}

// Campos de texto para contraseña
Widget buildPasswordField({
  required BuildContext context,
  TextEditingController? controller,
  String hintText = '',
}) {
  final screenWidth = MediaQuery.of(context).size.width;

  return StatefulBuilder(
    builder: (context, setState) {
      bool obscureText = true;

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
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.033),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF0886B5)),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
            ),
          ),
        ),
      );
    },
  );
}

ButtonStyle customButtonStyle(BuildContext context, bool isDarkMode) {
  return ElevatedButton.styleFrom(
    backgroundColor: isDarkMode ? Colors.white : Colors.grey,
    foregroundColor: isDarkMode ? Colors.black : Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}

PreferredSizeWidget buildCustomAppBarPage({
  required BuildContext context,
  required Color appBarColor,
  required Color appBarTextColor,
  required double screenWidth,
  String title = 'Hi User',
  bool showBackButton = true,
  List<Widget>? additionalActions,
}) {
  return AppBar(
    backgroundColor: appBarColor,
    elevation: 3,
    iconTheme: IconThemeData(color: appBarTextColor),
    leading:
        showBackButton
            ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            )
            : null,
    title: Text(
      title,
      style: TextStyle(color: appBarTextColor, fontSize: screenWidth * 0.038),
    ),
    actions: [
      ...?additionalActions,
      IconButton(
        icon: const Icon(Icons.notifications),
        onPressed: () => context.push('/notifications'),
      ),
      IconButton(
        icon: const Icon(Icons.person),
        onPressed: () => context.push('/profile'),
      ),
    ],
  );
}
