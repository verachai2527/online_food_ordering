import 'package:flutter/material.dart';
import 'package:online_food_ordering/models/product_model.dart';
import 'package:online_food_ordering/states/food_detail.dart';

class MySearchDelegate extends SearchDelegate {
  List<ProductModel> suggestions = [];
  MySearchDelegate(List<ProductModel> products) {
    suggestions = products;
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    // throw UnimplementedError();
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // throw UnimplementedError();
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // throw UnimplementedError();
    final results;
    if (query.isEmpty) {
      results = [];
    } else {
      results = suggestions.where((product) {
        final productName = product.name.toLowerCase();
        final input = query.toLowerCase();
        return productName.contains(input);
      }).toList();
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          leading: Image.network(
            product.imagePath,
            fit: BoxFit.cover,
            width: 50,
            height: 50,
          ),
          title: Text(product.name),
          onTap: () {
            // query = product.name;
            // showResults(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FoodDetail(productModel: product),
              ),
            ).then((value) {
              // setState(() {
              // checkFavoriteAllFlag(productModels);
              // });
            });
          },
        );
      },
    );
  }
}
