extension StringExtension on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Mask email for privacy
  String maskEmail() {
    if (!contains('@')) return this;
    final parts = split('@');
    final localPart = parts[0];
    final domain = parts[1];
    
    if (localPart.length < 2) {
      return '$localPart@$domain';
    }
    
    final masked = '${localPart[0]}${'*' * (localPart.length - 2)}${localPart[localPart.length - 1]}';
    return '$masked@$domain';
  }

  /// Extract numbers only
  String getNumbersOnly() {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }
}
