class JewelryItemWish {
  final int? diamondId;
  final String? jewelryId;
  final String? ringSize;
  final int? qty;

  JewelryItemWish({this.diamondId, this.jewelryId, this.ringSize, this.qty});

  @override
  String toString() {
    return 'JewelryItemWish{diamondId: $diamondId, jewelryId: $jewelryId, ringSize: $ringSize, qty: $qty}';
  }

  Map<String, dynamic> toJson() {
    return {
      'diamondid': diamondId,
      'jewelryid': jewelryId,
      'ringsize': ringSize,
      'qty': qty,
    };
  }

  factory JewelryItemWish.fromJson(Map<String, dynamic> json) {
    return JewelryItemWish(
      diamondId: json['diamondid'] ?? 0,
      jewelryId: json['jewelryid'],
      ringSize: json['ringsize'],
      qty: json['qty'] ?? 1,
    );
  }
}