class product_model {
  late final int id;
  late final String product_img;
  late final String product_description;
  late final String product_price;
  late final String product_discount;
  late final String m_size;
  late final String l_size;
  late final String xl_size;

  product_model({
    required this.id,
    required this.product_img,
    required this.product_description,
    required this.product_price,
    required this.product_discount,
    required this.m_size,
    required this.l_size,
    required this.xl_size,
  });
}
