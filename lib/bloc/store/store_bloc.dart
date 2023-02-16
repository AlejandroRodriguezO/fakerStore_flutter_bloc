import 'package:bloc/bloc.dart';
import 'package:ecommerce_bloc/repository/store_repository.dart';
import 'package:equatable/equatable.dart';

import '../../model/product.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc({required this.repository}) : super(const StoreState()) {
    on<StoreProductsRequest>(_getStoreProductsRequested);
    on<StoreProductsAddedToCart>(_productsAddedToCart);
    on<StoreProductsRemovedToCart>(_productsRemovedFromCart);
  }
  final StoreRepository repository;

  Future<void> _getStoreProductsRequested(
    StoreProductsRequest event,
    Emitter<StoreState> emit,
  ) async {
    try {
      emit(state.copyWith(productsStatus: StoreRequest.requestInProgress));
      final response = await repository.getProducts();

      emit(
        state.copyWith(
            products: response, productsStatus: StoreRequest.requestSuccess),
      );
    } catch (e) {
      emit(
        state.copyWith(productsStatus: StoreRequest.requestFailure),
      );
    }
  }

  Future<void> _productsAddedToCart(
    StoreProductsAddedToCart event,
    Emitter<StoreState> emit,
  ) async {
    emit(state.copyWith(cartIds: {...state.cartIds, event.cartId}));
  }

  Future<void> _productsRemovedFromCart(
    StoreProductsRemovedToCart event,
    Emitter<StoreState> emit,
  ) async {
    emit(state.copyWith(cartIds: {...state.cartIds}..remove(event.cartId)));
  }
}
