/// Пара (связка) двух значений одного типа.
class Pair<T> {
  /// Первое значение.
  final T first;

  /// Второе значение.
  final T second;

  /// Создаёт пару из двух значений.
  const Pair(this.first, this.second);

  factory Pair.fromJson(Map<String, dynamic> json) {
    return Pair<T>(json['first'] as T, json['second'] as T);
  }
  Map<String, dynamic> toJson() {
    return {'first': first, 'second': second};
  }
}
