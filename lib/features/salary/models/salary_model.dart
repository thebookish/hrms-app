class SalaryModel {
  final double basic;
  final double hra;
  final double allowance;
  final double deduction;
  final List<Payment> paymentHistory;
  final List<Increment> upcomingIncrements;

  SalaryModel({
    required this.basic,
    required this.hra,
    required this.allowance,
    required this.deduction,
    required this.paymentHistory,
    required this.upcomingIncrements,
  });

  factory SalaryModel.fromJson(Map<String, dynamic> json) {
    return SalaryModel(
      basic: (json['basic'] ?? 0).toDouble(),
      hra: (json['hra'] ?? 0).toDouble(),
      allowance: (json['allowance'] ?? 0).toDouble(),
      deduction: (json['deduction'] ?? 0).toDouble(),
      paymentHistory: (json['paymentHistory'] as List<dynamic>? ?? [])
          .map((e) => Payment.fromJson(e))
          .toList(),
      upcomingIncrements: (json['upcomingIncrements'] as List<dynamic>? ?? [])
          .map((e) => Increment.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'basic': basic,
      'hra': hra,
      'allowance': allowance,
      'deduction': deduction,
      'paymentHistory': paymentHistory.map((e) => e.toJson()).toList(),
      'upcomingIncrements': upcomingIncrements.map((e) => e.toJson()).toList(),
    };
  }
}
class Payment {
  final String month;
  final double amount;
  final String status;

  Payment({
    required this.month,
    required this.amount,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      month: json['month'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Paid',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'amount': amount,
      'status': status,
    };
  }
}
class Increment {
  final String effectiveDate;
  final double newSalary;

  Increment({
    required this.effectiveDate,
    required this.newSalary,
  });

  factory Increment.fromJson(Map<String, dynamic> json) {
    return Increment(
      effectiveDate: json['effectiveDate'] ?? '',
      newSalary: (json['newSalary'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'effectiveDate': effectiveDate,
      'newSalary': newSalary,
    };
  }
}
