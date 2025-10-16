class JewelryItem {
  final int? diamondId;
  final String? jewelryId;
  final String? ringSize;
  final int? qty;

  JewelryItem({this.diamondId, this.jewelryId, this.ringSize, this.qty});

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

  factory JewelryItem.fromJson(Map<String, dynamic> json) {
    return JewelryItem(
      diamondId: json['diamondid'] ?? 0,
      jewelryId: json['jewelryid'],
      ringSize: json['ringSize'],
      qty: json['qty'] ?? 1,
    );
  }
}