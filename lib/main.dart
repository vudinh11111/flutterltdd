import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trang chu")),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductListScreen()));
              },
              child: Text("Go to ProductScreen"))),
    );
  }
}

class Product {
  String search_image;
  String styleid;
  String brands_filter_facet;
  String price;
  String product_additional_info;

  Product({
    required this.search_image,
    required this.styleid,
    required this.brands_filter_facet,
    required this.price,
    required this.product_additional_info,
  });
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  Future<void> fetchdata() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.115.221:8181/i.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(json.decode(response.body));
        products = convertMaptoList(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<Product> convertMaptoList(Map<String, dynamic> data) {
    List<Product> list = [];
    data.forEach((key, value) {
      for (int i = 0; i < value.length; i++) {
        Product product = Product(
          search_image: value[i]["search_image"] ?? "",
          styleid: value[i]["styleid"] ?? "",
          brands_filter_facet: value[i]["brands_filter_facet"] ?? "",
          price: value[i]["price"] ?? "",
          product_additional_info: value[i]["product_additional_info"] ?? "",
        );
        list.add(product);
      }
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Danh sach san pham")),
        body: FutureBuilder(
            future: fetchdata(),
            builder: (context, index) {
              return ListView.builder(
                itemCount: products?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${products?[index].brands_filter_facet ?? "N/A"}'),
                    subtitle: Column(
                      children: [
                        Text('Price: ${products?[index].price ?? "N/A"}'),
                        Text(
                            'Product Additional Info: ${products?[index].product_additional_info ?? "N/A"}'),
                      ],
                    ),
                    leading: Image.network(
                      products?[index].search_image ?? "",
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreeen(products![index])));
                    },
                  );
                },
              );
            }));
  }
}

class ProductDetailScreeen extends StatelessWidget {
  final Product product;
  ProductDetailScreeen(this.product);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Detail"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
              child: Icon(Icons.shopping_cart),
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), padding: EdgeInsets.all(0)))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Name:${product.brands_filter_facet}"),
          ),
          Image.network(product.search_image),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Info ${product.product_additional_info}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("ID:${product.styleid}"),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text("Price:${product.price}"),
          )
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext contetx) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: Center(
        child: Text("Giỏ hàng của bạn"),
      ),
    );
  }
}
