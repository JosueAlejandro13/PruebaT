import 'package:prueb/screens/screens.dart';
import 'package:prueb/services/movie_service.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  Widget build(BuildContext context) {
    final movieService = MovieService();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster centrado
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  width: 200,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Título de la película debajo del poster
            Text(
              widget.movie.title,
              style: TextStyle(fontSize: screenWidth * 0.045),
            ),
            const SizedBox(height: 8),

            // Descripción de la película
            FutureBuilder<String>(
              future: movieService.fetchMovieDescription(widget.movie),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Failed to load description');
                } else {
                  return Text(snapshot.data ?? 'No description available');
                }
              },
            ),
            const SizedBox(height: 16),

            // Fecha de estreno
            Text('Release Date: ${widget.movie.releaseDate}'),
            const SizedBox(height: 8),

            // Puntuación
            Text('Rating: ${widget.movie.voteAverage}'),
            const SizedBox(height: 20),

            // Reparto (cast) de la película
            FutureBuilder<List<Map<String, String>>>(
              future: movieService.fetchMovieCastWithImages(widget.movie),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Failed to load cast');
                } else {
                  final cast = snapshot.data ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cast',
                        style: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                      const SizedBox(height: 8),
                      cast.isEmpty
                          ? const Text('No cast available')
                          : Container(
                            height: 200, // Establecemos la altura del carrusel
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cast.length,
                              itemBuilder: (context, index) {
                                final actor = cast[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      // Foto del actor (si está disponible)
                                      if (actor['photo'] != null &&
                                          actor['photo']!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            actor['photo']!,
                                            width: 100,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      const SizedBox(height: 4),
                                      // Nombre del actor
                                      Text(
                                        actor['name'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                    ],
                  );
                }
              },
            ),
            FutureBuilder<List<Map<String, String>>>(
              future: movieService.fetchRandomMovieCastWithImages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Failed to load cast');
                } else {
                  final cast = snapshot.data ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Watched by:',
                        style: TextStyle(fontSize: screenWidth * 0.045),
                      ),
                      const SizedBox(height: 8),
                      cast.isEmpty
                          ? const Text('No cast available')
                          : Container(
                            height: 200, // Establecemos la altura del carrusel
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cast.length,
                              itemBuilder: (context, index) {
                                final actor = cast[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    children: [
                                      // Foto del actor (si está disponible)
                                      if (actor['photo'] != null &&
                                          actor['photo']!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            actor['photo']!,
                                            width: 100,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      const SizedBox(height: 4),
                                      // Nombre del actor
                                      Text(
                                        actor['name'] ?? 'Unknown',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                    ],
                  );
                }
              },
            ),

            Center(
              child: buildCustomButton(
                context: context,
                text: 'Give your feedback',
                isDarkMode: isDarkMode,
                onPressed: () {
                  // Llamamos a la función para mostrar el primer diálogo
                  showFeedbackDialog(context);
                },
              ),
            ),

            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reviews',
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
                const SizedBox(height: 8),
                // Review 1
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'This app is amazing! I love how easy it is to use and the user interface is fantastic.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                // Review 2
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jane Smith',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Great app but I wish there were more customization options. Overall, it\'s good.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Michael Lee',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'The design is nice but the app crashes sometimes. Needs some bug fixes.',
                          style: TextStyle(fontSize: screenWidth * 0.032),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Recommended Movies',
              style: TextStyle(fontSize: screenWidth * 0.045),
            ),
            const SizedBox(height: 18),
            FutureBuilder<List<Movie>>(
              future: movieService.fetchLastTrailers(limit: 10),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No random movies found.');
                }

                final movies = snapshot.data!;
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          context.push('/detail', extra: movie);
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movie.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showFeedbackDialog(BuildContext context) {
  // Controlador para el campo de texto
  TextEditingController feedbackController = TextEditingController();
  final screenWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    barrierDismissible: false, // No se puede cerrar tocando fuera
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Give Your Review',
          style: TextStyle(fontSize: screenWidth * 0.045),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Write your comments below:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Your feedback...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showThankYouDialog(context);
            },
            child: const Text('Done'),
          ),
        ],
      );
    },
  );
}

void showThankYouDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Thank You!'),
        content: const Text('Thank you for your review.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
