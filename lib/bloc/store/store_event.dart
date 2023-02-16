part of 'store_bloc.dart';

class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object?> get props => [];
}

class StoreProductsRequest extends StoreEvent {}

class StoreProductsAddedToCart extends StoreEvent {
  const StoreProductsAddedToCart(this.cartId);

  final int cartId;

  @override
  List<Object?> get props => [cartId];
}

class StoreProductsRemovedToCart extends StoreEvent {
  const StoreProductsRemovedToCart(this.cartId);

  final int cartId;

  @override
  List<Object?> get props => [cartId];
}
