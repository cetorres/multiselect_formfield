class Pair<T> {
  final String label;
  final T value;

  Pair({
    required this.label,
    required this.value,
  });

  static Pair<String> from(String label) => Pair(label: label, value: label);
}
