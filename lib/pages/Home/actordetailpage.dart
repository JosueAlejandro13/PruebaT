import 'package:prueb/services/actors_service.dart';
import 'package:prueb/screens/screens.dart';

class ActorDetailPage extends StatefulWidget {
  final int actorId;

  const ActorDetailPage({super.key, required this.actorId});

  @override
  State<ActorDetailPage> createState() => _ActorDetailPageState();
}

class _ActorDetailPageState extends State<ActorDetailPage> {
  late Future<Map<String, dynamic>> _actorDetail;
  final ActorsService _actorService = ActorsService();

  @override
  void initState() {
    super.initState();
    _actorDetail = _actorService.fetchActorDetails(widget.actorId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final appBarColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white;
    final appBarTextColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;

    return Scaffold(
      appBar: buildCustomAppBarPage(
        context: context,
        appBarColor: appBarColor,
        appBarTextColor: appBarTextColor,
        screenWidth: screenWidth,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _actorDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          
          final data = snapshot.data!;
          final profile = data['profile'];
          final credits = data['credits'] as List;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${profile['profile_path']}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  profile['name'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Biography",
                    style: TextStyle(fontSize: screenWidth * 0.045),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(profile['biography'] ?? 'No biography available.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recognized by",
                    style: TextStyle(fontSize: screenWidth * 0.045),
                  ),
                ),
                const SizedBox(height: 10),
                ...credits
                    .take(5)
                    .map(
                      (movie) => Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading:
                              movie['poster_path'] != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : const Icon(Icons.movie),
                          title: Text(movie['title'] ?? 'Untitled'),
                          subtitle: Text(
                            movie['character'] != null
                                ? 'as ${movie['character']}'
                                : '',
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
