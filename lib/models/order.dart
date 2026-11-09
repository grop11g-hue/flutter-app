class Order {
  final String id;
  final DateTime date;
  final double total;
  final int itemCount;
  final List<String> lines;

  const Order({
    required this.id,
    required this.date,
    required this.total,
    required this.itemCount,
    required this.lines,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'total': total,
        'itemCount': itemCount,
        'lines': lines,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String? ?? '',
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        total: (json['total'] as num?)?.toDouble() ?? 0,
        itemCount: json['itemCount'] as int? ?? 0,
        lines: List<String>.from(json['lines'] as List? ?? const []),
      );
}
