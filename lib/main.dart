// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:products_repository/products_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/bootstrap.dart';
import 'package:provider_shopper/common/theme.dart';
import 'package:provider_shopper/models/cart.dart';
import 'package:provider_shopper/models/favorites.dart';
import 'package:provider_shopper/screens/cart.dart';
import 'package:provider_shopper/screens/catalog.dart';
import 'package:provider_shopper/screens/favorites.dart';
import 'package:provider_shopper/screens/login.dart';
import 'package:products_api/api.dart';

void main() {
  bootstrap(() async {
    const baseUrl = String.fromEnvironment('API_URL',
        defaultValue: 'http://localhost:8080');

    final apiClient = ApiClient(baseUrl: baseUrl);

    final productsRepository = ProductsRepository(apiClient: apiClient);

    return MyApp(
      productsRepository: productsRepository,
    );
  });
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const MyLogin(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) => const MyCatalog(),
        routes: [
          GoRoute(
            path: 'cart',
            builder: (context, state) => const MyCart(),
          ),
          GoRoute(
            path: 'favorites',
            builder: (context, state) => const MyFavorites(),
          ),
        ],
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required ProductsRepository productsRepository,
  }) : _productsRepository = productsRepository;

  final ProductsRepository _productsRepository;

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiProvider(
      providers: [
        // In this sample app, ProductsRepository never changes, so a simple Provider
        // is sufficient.
        Provider(create: (context) => _productsRepository),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on ProductsRepository, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<ProductsRepository, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            if (cart == null) throw ArgumentError.notNull('cart');
            cart.catalog = catalog;
            return cart;
          },
        ),
        Provider(create: (context) => _productsRepository),
        // FavoritesModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, FavoritesModel depends
        // on ProductsRepository, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<ProductsRepository, FavoritesModel>(
          create: (context) => FavoritesModel(),
          update: (context, catalog, favorites) {
            if (favorites == null) throw ArgumentError.notNull('favorites');
            favorites.catalog = catalog;
            return favorites;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'Carrito de compras',
        theme: appTheme,
        routerConfig: router(),
      ),
    );
  }
}

class FavModel {
}
