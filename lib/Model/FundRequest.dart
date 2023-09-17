class FundRequest {
  final String?id;
  final String? amount;
  final String? paymentMode;
  final String? transactionId;
  final String? transactionDate;
  final String? status;

  FundRequest({
    required this.id,
    required this.amount,
    required this.paymentMode,
    required this.transactionId,
    required this.transactionDate,
    required this.status,
  });

  factory FundRequest.fromJson(Map<String, dynamic> json) {
    return FundRequest(
      id: json['id'],
      amount: json['amount'],
      paymentMode: json['payment_mode'],
      transactionId: json['transaction_id'],
      transactionDate: json['transaction_date'],
      status: json['status'],
    );
  }
}
