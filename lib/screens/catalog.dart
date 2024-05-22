// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:products_api/api.dart';
import 'package:products_repository/products_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/models/cart.dart';
import 'package:provider_shopper/models/favorites.dart';

class MyCatalog extends StatelessWidget {
  const MyCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Product>>(
            future: context.read<ProductsRepository>().getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Waiting for a surprise... ⏳');
              } else if (snapshot.hasError) {
                return Text('Oops! Something went wrong. 🙁');
              } else {
                return CustomScrollView(slivers: [
                  _MyAppBar(),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => _MyListItem(snapshot.data![index]),
                        childCount: snapshot.data!.length),
                  )
                ]);
              }
            }));
  }
}

///
/// BUTTON AGREGAR A CARRITO
///

class _AddButton extends StatelessWidget {
  final Product item;

  const _AddButton({required this.item});

  @override
  Widget build(BuildContext context) {
    // The context.select() method will let you listen to changes to
    // a *part* of a model. You define a function that "selects" (i.e. returns)
    // the part you're interested in, and the provider package will not rebuild
    // this widget unless that particular part of the model changes.
    //
    // This can lead to significant performance improvements.
    var isInCart = context.select<CartModel, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (cart) => cart.items.contains(item),
    );

    return TextButton(
      onPressed: isInCart
          ? null
          : () {
              // If the item is not in cart, we let the user add it.
              // We are using context.read() here because the callback
              // is executed whenever the user taps the button. In other
              // words, it is executed outside the build method.
              var cart = context.read<CartModel>();
              cart.add(item);
            },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: isInCart
          ? const Icon(Icons.check, semanticLabel: 'ADDED')
          : const Text('ADD'),
    );
  }
}

///
///   boton de favoritos de cada item
///
///
class _FavButton extends StatelessWidget {
  final Product item;

  const _FavButton({required this.item});

  @override
  Widget build(BuildContext context) {
    // The context.select() method will let you listen to changes to
    // a *part* of a model. You define a function that "selects" (i.e. returns)
    // the part you're interested in, and the provider package will not rebuild
    // this widget unless that particular part of the model changes.
    //
    // This can lead to significant performance improvements.
    var isInFav = context.select<FavoritesModel, bool>(
      // Here, we are only interested whether [item] is inside the cart.
      (favorites) => favorites.items.contains(item),
    );

    IconData icon;
    if (isInFav) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return TextButton(
      onPressed: isInFav
          ? null
          : () {
              // If the item is not in cart, we let the user add it.
              // We are using context.read() here because the callback
              // is executed whenever the user taps the button. In other
              // words, it is executed outside the build method.
              var cart = context.read<FavoritesModel>();
              cart.add(item);
            },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }
          return null; // Defer to the widget's default.
        }),
      ),
      child: Icon (icon)
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Catalogo', style: Theme.of(context).textTheme.displayLarge),
      floating: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => context.go('/catalog/cart'),
        ),
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () => context.go('/catalog/favorites'),
        ),
        SizedBox(width: 40),
      ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final Product product;

  const _MyListItem(this.product);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(color: Colors.deepPurple),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(product.name, style: textTheme),
            ),
            const SizedBox(width: 24),
            _FavButton(item: product),
            _AddButton(item: product),
          ],
        ),
      ),
    );
  }
}
