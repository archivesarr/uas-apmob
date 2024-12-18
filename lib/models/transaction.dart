class Transaction {
  final String name;
  final String lastModified;
  final String firstMonth;
  final String lastMonth;
  final double amount;

  Transaction({
    required this.name,
    required this.lastModified,
    required this.firstMonth,
    required this.lastMonth,
    required this.amount,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      name: json['name'],
      lastModified: json['last_modified_on'] ?? 'Unknown',
      firstMonth: json['first_month'] ?? 'Unknown',
      lastMonth: json['last_month'] ?? 'Unknown',
      amount: (json['amount'] ?? 0) / 1000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'last_modified_on': lastModified,
      'first_month': firstMonth,
      'last_month': lastMonth,
      'amount': amount,
    };
  }
}
