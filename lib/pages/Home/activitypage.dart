import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  /// Lista de actividades de ejemplo
  final List<Map<String, String>> activities = const [
    {
      'title': 'Nueva película añadida: Inception',
      'description': 'Explora los sueños en este thriller psicológico.',
    },
    {
      'title': 'Top 10: Interstellar',
      'description': 'Sube al ranking como una de las más vistas.',
    },
    {
      'title': 'Recomendada: The Dark Knight',
      'description': 'Un clásico del cine de superhéroes.',
    },
    {
      'title': 'Nueva reseña: Parasite',
      'description': 'Una mirada cruda a las desigualdades sociales.',
    },
    {
      'title': 'Ganadora de premios: Everything Everywhere',
      'description': 'La película más premiada del año.',
    },
    {
      'title': 'Nueva función: Comentarios en tiempo real',
      'description': 'Opina mientras ves tu película favorita.',
    },
    {
      'title': 'Clásico destacado: Fight Club',
      'description': 'Explora la mente humana en este thriller psicológico.',
    },
    {
      'title': 'Reestreno en cines: Avatar',
      'description': 'Vuelve la épica de James Cameron.',
    },
    {
      'title': 'Especial de fin de semana: El Señor de los Anillos',
      'description': 'Disfruta la trilogía completa.',
    },
    {
      'title': 'Documental recomendado: Oppenheimer',
      'description': 'Descubre la historia del padre de la bomba atómica.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 150,
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: 0.2,
                      child: Image.asset('assets/fond.jpg', fit: BoxFit.cover),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title']!,
                            style: TextStyle(
                              fontSize: screenWidth * 0.040,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['description']!,
                            style: TextStyle(fontSize: screenWidth * 0.035),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
