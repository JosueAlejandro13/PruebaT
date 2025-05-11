import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prueb/screens/screens.dart';
import 'package:prueb/services/movie_service.dart';

class Listpage extends StatefulWidget {
  const Listpage({super.key});

  @override
  State<Listpage> createState() => _ListpageState();
}

class _ListpageState extends State<Listpage> {
  late Future<List<Movie>> _moviesList;
  final MovieService _movieService = MovieService();
  int _selectedSegment =
      0; // Para controlar la lista seleccionada (Lista 1, 2, 3)
  bool _isGridView =
      true; // Para controlar la vista de las tarjetas (Grid o Column)

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  // Método para cargar las películas según la lista seleccionada
  void _loadMovies() {
    if (_selectedSegment == 0) {
      _moviesList = _movieService.fetchRandomMovies();
    } else if (_selectedSegment == 1) {
      _moviesList = _movieService.fetchTrendingMovies();
    } else {
      _moviesList = _movieService.fetchPopularMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Segment control para cambiar entre las listas
          SegmentControl(
            selectedSegment: _selectedSegment,
            onSegmentSelected: (index) {
              setState(() {
                _selectedSegment = index;
                _loadMovies();
              });
            },
          ),
          SizedBox(height: 10),
          // Botón para cambiar entre Column y Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Good Movies',
                  style: TextStyle(fontSize: screenWidth * 0.045),
                ),
                IconButton(
                  icon: Icon(_isGridView ? Icons.view_agenda : Icons.grid_view),
                  tooltip:
                      _isGridView ? 'Cambiar a columna' : 'Cambiar a grilla',
                  onPressed: () {
                    setState(() {
                      _isGridView = !_isGridView;
                    });
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 10),
          // FutureBuilder para mostrar las películas
          FutureBuilder<List<Movie>>(
            future: _moviesList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No hay películas disponibles."),
                );
              }

              final movies = snapshot.data!;

              if (_isGridView) {
                return Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.5,
                        ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return _buildMovieCard(movie, screenWidth);
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return _buildMovieCard(movie, screenWidth);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateListDialog,
        tooltip: 'Crear nueva lista',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateListDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    bool isPublic = false;
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Crear nueva lista',
            style: TextStyle(fontSize: screenWidth * 0.045),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: screenWidth * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: const Icon(Icons.list_alt),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        prefixIcon: const Icon(Icons.description),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Public List'),
                        Switch(
                          value: isPublic,
                          onChanged: (value) {
                            setState(() {
                              isPublic = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMovieCard(Movie movie, double screenWidth) {
       return GestureDetector(
                        onTap: () {
                          context.push('/detail', extra: movie);
                        }, child:  Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.network(
            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 60),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
            child: Text(
              movie.title,
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
              "⭐ ${movie.voteAverage.toStringAsFixed(1)}",
              style: TextStyle(
                fontSize: screenWidth * 0.028,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
                        ),
    );
  }
}

class SegmentControl extends StatelessWidget {
  final int selectedSegment;
  final ValueChanged<int> onSegmentSelected;

  const SegmentControl({
    super.key,
    required this.selectedSegment,
    required this.onSegmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: CupertinoSegmentedControl<int>(
        padding: const EdgeInsets.all(4),
        groupValue: selectedSegment,
        onValueChanged: onSegmentSelected,
        children: {
          0: _buildSegment('Lista 1'),
          1: _buildSegment('Lista 2'),
          2: _buildSegment('Lista 3'),
        },
      ),
    );
  }

  Widget _buildSegment(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
