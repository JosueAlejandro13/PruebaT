import 'package:prueb/screens/screens.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _currentStep = 0;
  // Recuperar el modo oscuro del tema actual
  late bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            const Spacer(),
            Icon(
              Icons.movie,
              size: screenSize.height * 0.07,
              color: const Color(0xFF0886B5),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/fond.jpg',
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'With great power comes great responsibility',
              style: TextStyle(
                fontSize: screenSize.width * 0.040,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Stepper compacto
          SizedBox(
            width: screenSize.width * 0.6,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(height: 3, color: Colors.grey.shade300),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 3,
                    width:
                        _currentStep == 0
                            ? 0
                            : _currentStep == 1
                            ? screenSize.width * 0.35
                            : screenSize.width * 0.7,
                    color: const Color(0xFF0886B5),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (index) {
                    return _StepBubble(
                      number: index + 1,
                      isActive: _currentStep >= index,
                      isCompleted: _currentStep > index,
                      onTap: () => setState(() => _currentStep = index),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _getStepContent(_currentStep),
            ),
          ),

          const SizedBox(height: 32),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.white : Colors.grey,
                  foregroundColor: isDarkMode ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(0, 36),
                ),
                onPressed: () {
                  if (_currentStep == 2) {
                    context.push('/login');
                  } else {
                    setState(() => _currentStep++);
                  }
                },
                child: Text(
                  _currentStep == 2 ? 'Get Started' : 'Next',
                  style: TextStyle(fontSize: screenWidth * 0.034),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _getStepContent(int step) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titles = [
      'Discover the best movies',
      'Create your personalized list',
      'Share with your friends',
    ];

    return Text(
      titles[step],
      key: ValueKey<int>(step), // Necesario para AnimatedSwitcher
      style: TextStyle(fontSize: screenWidth * 0.035),
      textAlign: TextAlign.center,
    );
  }
}

class _StepBubble extends StatelessWidget {
  final int number;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback? onTap;

  const _StepBubble({
    required this.number,
    required this.isActive,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isActive ? 32 : 24,
        height: isActive ? 32 : 24,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0886B5) : Colors.grey.shade300,
          shape: BoxShape.circle,
          border:
              isActive && !isCompleted
                  ? Border.all(
                    color: const Color(0xFF0886B5).withOpacity(0.3),
                    width: 3,
                  )
                  : null,
        ),
        child: Center(
          child:
              isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                    '$number',
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: isActive ? 14 : 12,
                    ),
                  ),
        ),
      ),
    );
  }
}
