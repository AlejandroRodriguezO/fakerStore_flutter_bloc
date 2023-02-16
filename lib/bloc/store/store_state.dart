part of 'store_bloc.dart';

enum StoreRequest {
  unknown,
  requestInProgress,
  requestSuccess,
  requestFailure,
}

class StoreState extends Equatable {
  const StoreState({
    this.products = const [],
    this.productsStatus = StoreRequest.unknown,
    this.cartIds = const {},
  });

  final List<Product> products;
  final StoreRequest productsStatus;
  final Set<int> cartIds;

  @override
  List<Object> get props => [
        products,
        productsStatus,
        cartIds,
      ];

  StoreState copyWith({
    List<Product>? products,
    StoreRequest? productsStatus,
    Set<int>? cartIds,
  }) =>
      StoreState(
        products: products ?? this.products,
        productsStatus: productsStatus ?? this.productsStatus,
        cartIds: cartIds ?? this.cartIds,
      );
}
