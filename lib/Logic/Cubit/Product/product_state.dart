part of 'product_cubit.dart';

class ProductState extends Equatable {
  final Status status;
  final ProductResponse? productData;
  final List<Product> cartProduct;
  final num cartTotal;
  const ProductState(
      {this.status = Status.initial,
      this.productData,
      this.cartProduct = const [],
      this.cartTotal = 0});

  @override
  List<Object?> get props => [
        status,
        productData,
        cartProduct,
        cartTotal,
      ];

  ProductState copyWith(
      {Status? status,
      ProductResponse? productData,
      List<Product>? cartProduct,
      num? cartTotal}) {
    return ProductState(
      status: status ?? this.status,
      productData: productData ?? this.productData,
      cartProduct: cartProduct ?? this.cartProduct,
      cartTotal: cartTotal ?? this.cartTotal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'status': status.index,
      // 'postModeList': postModeList,
    };
  }

  factory ProductState.fromMap(Map<String, dynamic> map) {
    return ProductState();
  }

  String toJson() => json.encode(toMap());

  factory ProductState.fromJson(String source) =>
      ProductState.fromMap(json.decode(source));
}
