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
      basic: json['basic']?.toDouble() ?? 0,
      hra: json['hra']?.toDouble() ?? 0,
      allowance: json['allowance']?.toDouble() ?? 0,
      deduction: json['deduction']?.toDouble() ?? 0,
      paymentHistory: List.from(json['paymentHistory'] ?? [])
          .map((e) => Payment.fromJson(e))
          .toList(),
      upcomingIncrements: List.from(json['upcomingIncrements'] ?? [])
          .map((e) => Increment.fromJson(e))
          .toList(),
    );
  }
}

class Payment {
  final String month;
  final double amount;
  final String status;

  Payment({required this.month, required this.amount, required this.status});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      month: json['month'] ?? '',
      amount: json['amount']?.toDouble() ?? 0,
      status: json['status'] ?? 'Paid',
    );
  }
}

class Increment {
  final String effectiveDate;
  final double newSalary;

  Increment({required this.effectiveDate, required this.newSalary});

  factory Increment.fromJson(Map<String, dynamic> json) {
    return Increment(
      effectiveDate: json['effectiveDate'] ?? '',
      newSalary: json['newSalary']?.toDouble() ?? 0,
    );
  }
}
