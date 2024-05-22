import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/models/favorites.dart';

class MyFavorites extends StatelessWidget {
  const MyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Favorites', style: Theme.of(context).textTheme.displayLarge),
        backgroundColor: Color.fromARGB(255, 255, 200, 251),
      ),
      body: Container(
        color: Color.fromARGB(255, 241, 183, 244),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: _MyFavorites(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyFavorites extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    var itemNameStyle = Theme.of(context).textTheme.titleLarge;
    // This gets the current state of CartModel and also tells Flutter
    // to rebuild this widget when CartModel notifies listeners (in other words,
    // when it changes).
    var favorites = context.watch<FavoritesModel>();

    return ListView.builder(
      itemCount: favorites.items.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.done),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            favorites.remove(favorites.items[index]);
          },
        ),
        title: Text(
          favorites.items[index].name,
          style: itemNameStyle,
        ),
      ),
    );
  }
}
