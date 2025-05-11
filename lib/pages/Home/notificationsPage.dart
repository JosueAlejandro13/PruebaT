import 'package:prueb/screens/screens.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Simulación de datos de notificaciones
    final List<Map<String, String>> notifications = [
      {'title': 'Estreno de "Avatar 2"', 'date': '2025-05-10 12:00:00'},
      {
        'title': 'Estreno de "Fast & Furious 10"',
        'date': '2025-05-12 10:00:00',
      },
      {
        'title': 'Estreno de "Guardians of the Galaxy Vol. 3"',
        'date': '2025-05-15 18:00:00',
      },
      {'title': 'Estreno de "The Flash"', 'date': '2025-05-18 20:00:00'},
      {'title': 'Estreno de "The Marvels"', 'date': '2025-05-20 09:00:00'},
      {'title': 'Estreno de "Indiana Jones 5"', 'date': '2025-05-22 16:00:00'},
      {
        'title': 'Estreno de "Mission: Impossible 8"',
        'date': '2025-05-25 14:00:00',
      },
      {'title': 'Estreno de "Dune Part Two"', 'date': '2025-05-30 19:00:00'},
    ];

    // Color de la barra de navegación
    final appBarColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white;

    final appBarTextColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 3,
        iconTheme: IconThemeData(color: appBarTextColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
        ),
   
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Hi User',
              style: TextStyle(
                color: appBarTextColor,
                fontSize: screenWidth * 0.038,
              ),
            ),
            IconButton(icon: const Icon(Icons.person), onPressed: () {
              context.push('/profile');
            }),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            DateTime notificationDate = DateTime.parse(
              notifications[index]['date']!,
            );
            String relativeTime = timeago.format(notificationDate);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  notifications[index]['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  relativeTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.notifications_active,
                  color:  Color(0xFF0886B5),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
