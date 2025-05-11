
// Validación para verificar que el campo no esté vacío
String? validateNotEmpty(String? value, String fieldName) {
  if (value == null || value.isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

