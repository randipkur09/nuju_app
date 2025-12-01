extension StringExtension on String {
  // Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  // Check if email is valid
  bool isValidEmail() {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  // Check if phone is valid
  bool isValidPhone() {
    return length >= 10 && length <= 13;
  }

  // Remove all whitespace
  String removeAllWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  // Truncate string to specific length
  String truncate(int length) {
    if (this.length <= length) return this;
    return '${substring(0, length)}...';
  }

  // Convert to title case
  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}
