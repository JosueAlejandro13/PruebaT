import 'package:prueb/screens/screens.dart';
import 'package:prueb/services/movie_service.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  late Future<List<Movie>> _trendingMovies;
  final MovieService _movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedGenre = '';

  @override
  void initState() {
    super.initState();
    _trendingMovies = _movieService.fetchRandomMovies();
  }

  void _searchMovies() {
    setState(() {
      _trendingMovies = _movieService.fetchMoviesByGenre(
        _selectedGenre,
        searchTerm: _searchController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onSubmitted: (query) => _searchMovies(),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: [
                _buildGenreButton('Action'),
                _buildGenreButton('Comedy'),
                _buildGenreButton('Drama'),
                _buildGenreButton('Romance'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Movie List
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _trendingMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No movies found."));
                }

                final movies = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    final year =
                        DateTime.tryParse(movie.releaseDate)?.year ?? 'N/A';

                    return GestureDetector(
                      onTap: () {
                        context.push('/detail', extra: movie);
                      },
                      child: Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // Imagen de la película
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                width: 100,
                                height: 140,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const SizedBox(
                                          width: 100,
                                          height: 140,
                                          child: Center(
                                            child: Icon(
                                              Icons.broken_image,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                              ),
                            ),

                            // Detalles de la película
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.040,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "⭐ ${movie.voteAverage.toStringAsFixed(1)}",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Año: $year",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.032,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreButton(String genre) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGenre = genre;
          _searchMovies();
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(genre),
    );
  }
}
