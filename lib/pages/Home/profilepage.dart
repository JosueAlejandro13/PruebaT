import 'package:prueb/screens/screens.dart';

import '../../services/movie_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Movie> movies = [];
  double rating = 3.0; // Calificación inicial

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  // Función para cargar las películas desde el MovieService
  Future<void> _loadMovies() async {
    try {
      final movieService = MovieService();
      final fetchedMovies = await movieService.fetchMovies();
      setState(() {
        movies = fetchedMovies;
      });
    } catch (e) {
      print("Error loading movies: $e");
    }
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
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => context.push('/notifications'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.040,
                        ),
                      ),
                      Text(
                        'Password',
                        style: TextStyle(fontSize: screenWidth * 0.040),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Text('Member since: '),
                          Text(
                            '15 May 2025',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Agregar redes sociales
              Text(
                'Add New Socials',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.040,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Wrap(
                  spacing: 16,
                  children: [
                    _socialMediaButton(
                      'Facebook',
                      Icons.facebook,
                      const Color(0xFF0886B5),
                    ),
                    _socialMediaButton(
                      'Instagram',
                      Icons.messenger,
                      const Color(0xFF0886B5),
                    ),
                    _socialMediaButton(
                      'Telegram',
                      Icons.telegram,
                      const Color(0xFF0886B5),
                    ),
                    _socialMediaButton(
                      'LinkedIn',
                      Icons.inbox,
                      const Color(0xFF0886B5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: buildCustomButton(
                  context: context,
                  text: 'Save',
                  isDarkMode:
                      Theme.of(context).brightness ==
                      Brightness.dark, // Se verifica si el modo es oscuro
                  onPressed: () {},
                ),
              ),

              const SizedBox(height: 24),

              // Divider
              const Divider(),

              const SizedBox(height: 16),

              // Reseñas de películas
              Text(
                'Overview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.040,
                ),
              ),
              Text(
                'Reviews',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.040,
                ),
              ),
              const SizedBox(height: 16),

              // Mostrar las 3 primeras películas
              if (movies.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                      movies.take(3).map((movie) => _movieCard(movie)).toList(),
                ),

              if (movies.isEmpty)
                const Center(child: CircularProgressIndicator()),

              // Calificación
              const SizedBox(height: 24),
              Text(
                'Rate the Movies',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.040,
                ),
              ),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder:
                    (context, index) =>
                        const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _movieCard(Movie movie) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen de la película
            Image.network(
              'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.035,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  // Widget para los botones de redes sociales
  Widget _socialMediaButton(String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
