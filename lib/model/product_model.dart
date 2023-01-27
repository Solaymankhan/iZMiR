class product_model {
  late final int id;
  late final String product_img;
  late final String product_description;
  late final String product_price;
  late final String product_stock;
  late final String product_discount;

  product_model({
    required this.id,
    required this.product_img,
    required this.product_description,
    required this.product_price,
    required this.product_stock,
    required this.product_discount,
  });
}
