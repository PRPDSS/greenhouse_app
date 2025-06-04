import 'dart:convert';

/// Пара (связка) двух значений одного типа.
class Pair<T> {
  /// Первое значение.
  final T first;

  /// Второе значение.
  final T second;

  /// Создаёт пару из двух значений.
  const Pair(this.first, this.second);

  factory Pair.fromJson(Map<String, dynamic> json) {
    if (T == double) {
      return Pair<T>(
        (json['first'] as num).toDouble() as T,
        (json['second'] as num).toDouble() as T,
      );
    }
    return Pair<T>(json['first'] as T, json['second'] as T);
  }

  String toJson() {
    return jsonEncode({'first': first, 'second': second});
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pair<T> && other.first == first && other.second == second;
  }

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}
