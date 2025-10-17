class JewelryItemWish {
  final int? diamondId;
  final String? jewelryId;
  final String? ringSize;
  final int? qty;

  JewelryItemWish({this.diamondId, this.jewelryId, this.ringSize, this.qty});

  @override
  String toString() {
    return 'JewelryItem{diamondId: $diamondId, jewelryId: $jewelryId, ringSize: $ringSize, qty: $qty}';
  }

  Map<String, dynamic> toJson() {
    return {
      'diamondid': diamondId,
      'jewelryid': jewelryId,
      'ringSize': ringSize,
      'qty': qty,
    };
  }

  factory JewelryItemWish.fromJson(Map<String, dynamic> json) {
    return JewelryItemWish(
      diamondId: json['diamondid'] ?? 0,
      jewelryId: json['jewelryid'],
      ringSize: json['ringSize'],
      qty: json['qty'] ?? 1,
    );
  }
}