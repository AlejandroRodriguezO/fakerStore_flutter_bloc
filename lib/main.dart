import 'package:dio/dio.dart';
import 'package:ecommerce_bloc/bloc/store/store_bloc.dart';
import 'package:ecommerce_bloc/pages/home_page.dart';
import 'package:ecommerce_bloc/repository/store_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cubit/theme_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<StoreRepository>(
      create: (context) => StoreRepositoryImp(
        Dio(
          BaseOptions(baseUrl: 'https://fakestoreapi.com/products'),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => StoreBloc(
              repository: context.read(),
            )..add(StoreProductsRequest()),
          ),
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, bool>(
          builder: (context, state) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Bloc Ecommerce',
                theme: ThemeData(
                  brightness: state ? Brightness.dark : Brightness.light,
                  primarySwatch: Colors.blue,
                  useMaterial3: true,
                ),
                home: const HomePage());
          },
        ),
      ),
    );
  }
}

