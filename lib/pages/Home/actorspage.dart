import 'package:prueb/screens/screens.dart';
import 'package:prueb/services/actors_service.dart';

class ActorsPage extends StatefulWidget {
  const ActorsPage({super.key});

  @override
  State<ActorsPage> createState() => _ActorsPageState();
}

class _ActorsPageState extends State<ActorsPage> {
  final ActorsService _actorService = ActorsService();
  late Future<List<Actor>> _popularActors;

  @override
  void initState() {
    super.initState();
    _popularActors = _actorService.fetchPopularActors();
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
      body: FutureBuilder<List<Actor>>(
        future: _popularActors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay actores disponibles."));
          }

          final actors = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Most Popular Actors",
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.49,
                  ),
                  itemCount: actors.length,
                  itemBuilder: (context, index) {
                    final actor = actors[index];
                    final knownFor =
                        actor.knownFor.isNotEmpty == true
                            ? actor.knownFor.first.title ?? 'Sin título'
                            : 'Sin películas';

                    return InkWell(
                      onTap: () {
                        context.pushNamed(
                          'actorDetail',
                          pathParameters: {'id': actor.id.toString()},
                        );
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Image.network(
                              'https://image.tmdb.org/t/p/w500${actor.profilePath}',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 60),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                actor.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.030,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                knownFor,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.028,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
