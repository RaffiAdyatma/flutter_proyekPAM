class Bid {
  int? id;
  int? produkId;
  int? memberId;
  int? bidValue;

  Bid({this.id, this.produkId, this.memberId, this.bidValue});

  factory Bid.fromJson(Map<String, dynamic> obj) {
    return Bid(
      id: int.tryParse(obj['id'].toString()),
      produkId: int.tryParse(obj['produk_id'].toString()),
      memberId: int.tryParse(obj['member_id'].toString()),
      bidValue: int.tryParse(obj['bid_value'].toString()),
    );
  }
}