import 'package:prueb/screens/screens.dart';
import 'package:prueb/services/tmdb_service.dart';

class Firtspage extends StatefulWidget {
  const Firtspage({super.key});

  @override
  State<Firtspage> createState() => _FirtspageState();
}

class _FirtspageState extends State<Firtspage> {
  final TMDbService _tmdbService = TMDbService();
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  List<int> _selectedMovieIds = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
  }

  // Petición de películas populares
  Future<void> _fetchPopularMovies() async {
    setState(() => _isLoading = true);

    try {
      final movies = await _tmdbService.getPopularMovies();
      setState(() {
        _movies = movies;
        _filteredMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching movies: $e');
      setState(() => _isLoading = false);
    }
  }

  // Buscar películas según la consulta
  void _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() => _filteredMovies = _movies);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final movies = await _tmdbService.searchMovies(query);
      setState(() {
        _filteredMovies = movies;
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching movies: $e');
      setState(() => _isLoading = false);
    }
  }

  // Seleccionar o deseleccionar una película
  void _toggleMovieSelection(int movieId) {
    setState(() {
      if (_selectedMovieIds.contains(movieId)) {
        _selectedMovieIds.remove(movieId);
      } else if (_selectedMovieIds.length < 5) {
        _selectedMovieIds.add(movieId);
      }
    });
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSelectionComplete = _selectedMovieIds.length == 5;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 90),
            Text(
              'What kind of movie do you want to watch?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: _searchMovies,
              decoration: InputDecoration(
                hintText: 'Search for movies...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0886B5)),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose up to 5 movies',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: screenWidth * 0.035),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
                : Expanded(
                  child: GridView.builder(
                    itemCount: _filteredMovies.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (context, index) {
                      final movie = _filteredMovies[index];
                      final isSelected = _selectedMovieIds.contains(movie.id);

                      return GestureDetector(
                        onTap: () => _toggleMovieSelection(movie.id),
                        child: Stack(
                          children: [
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side:
                                    isSelected
                                        ? const BorderSide(
                                          color: Colors.blue,
                                          width: 3,
                                        )
                                        : BorderSide.none,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child:
                                          movie.posterPath.isEmpty
                                              ? const Icon(
                                                Icons.movie,
                                                size: 80,
                                              )
                                              : Image.network(
                                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      movie.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Positioned(
                                top: 8,
                                right: 8,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            const SizedBox(height: 10),

            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 240,
        child: ElevatedButton(
          style: customButtonStyle(
            context,
            Theme.of(context).brightness == Brightness.dark,
          ),
          onPressed:
              isSelectionComplete
                  ? () {
                    print('Películas seleccionadas: $_selectedMovieIds');
                    context.push('/home');
                  }
                  : null,
          child: Text(
            'Continue (${_selectedMovieIds.length}/5)',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
        ),
      ),
    );
  }
}
