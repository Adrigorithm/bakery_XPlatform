class Good {
  Good(this.id, this.name, this.imageUri, this.price);

  final int id;
  final String name;
  final String imageUri;
  final double price;

  factory Good.fromJson(Map<String, dynamic> rawData) {
    return Good(rawData["id"], rawData["name"] ?? "Unnamed",
        rawData["imageUri"] ?? "No image found", rawData["price"] ?? 0);
  }
}

class Goods {
  Goods(this.goods);

  final List<Good> goods;

  factory Goods.fromJson(List<dynamic> data) {
    return Goods(data.map((good) => Good.fromJson(good)).toList());
  }
}
