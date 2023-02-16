import 'package:ecommerce_bloc/bloc/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/store/store_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void addToCart(int cartId) {
      context.read<StoreBloc>().add(StoreProductsAddedToCart(cartId));
    }

    void removeFromCart(int cartId) {
      context.read<StoreBloc>().add(StoreProductsRemovedToCart(cartId));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Store Bloc', style: Theme.of(context).textTheme.titleMedium),
        actions: [
          IconButton(
            onPressed: () => context.read<ThemeCubit>().togleMode(),
            icon: const Icon(
              Icons.sunny,
            ),
          )
        ],
      ),
      body: Center(
        child: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            if (state.productsStatus == StoreRequest.requestInProgress) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            if (state.productsStatus == StoreRequest.requestFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Problema al cargar Productos'),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      context.read<StoreBloc>().add(StoreProductsRequest());
                    },
                    child: const Text('Intenta nuevamente'),
                  ),
                ],
              );
            }

            if (state.productsStatus == StoreRequest.unknown) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shop_outlined,
                    size: 60,
                    color: Colors.black26,
                  ),
                  const SizedBox(height: 10),
                  const Text('No se encontraron productos'),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      context.read<StoreBloc>().add(StoreProductsRequest());
                    },
                    child: const Text('Cargar productos'),
                  ),
                ],
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                final inCart = state.cartIds.contains(product.id);

                return Card(
                  key: ValueKey(product.id),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Flexible(
                          child: Image.network(product.image),
                        ),
                        Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        inCart
                            ? OutlinedButton.icon(
                                icon: const Icon(
                                    Icons.remove_shopping_cart_outlined),
                                onPressed: () => removeFromCart(product.id),
                                style: ButtonStyle(
                                  backgroundColor: inCart
                                      ? const MaterialStatePropertyAll<Color>(
                                          Colors.black12)
                                      : null,
                                ),
                                label: Text(
                                  'Eliminar del carrito',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              )
                            : OutlinedButton.icon(
                                icon: const Icon(Icons.add_shopping_cart),
                                onPressed: () => addToCart(product.id),
                                style: ButtonStyle(
                                  backgroundColor: inCart
                                      ? const MaterialStatePropertyAll<Color>(
                                          Colors.black12)
                                      : null,
                                ),
                                label: Text(
                                  'Agregar al carrito',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
