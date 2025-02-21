import 'package:flutter/material.dart';
import '../entities/cart_items.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import './product_page.dart';
import '../shared/buttons.dart';
import './add_item_page.dart';
import '../entities/product.dart';
import '../shared/partials.dart';
import '../shared/category_widgets.dart';
import '../shared/section_header_widgets.dart';
import 'cart_page.dart';
import 'map.dart'; //
import './store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/local_storage_helper.dart';

class HomeDashboard extends StatefulWidget {
  final String pageTitle;

  HomeDashboard({
    Key? key,
    this.pageTitle = '',
  }) : super(key: key);

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 2;
  String selectedCategory = 'Hamburger';

  void updateCategories(String newCategory) {
    setState(() {
      selectedCategory = newCategory;
    });
  }

  // data list
  List<Product> hamburgers = [];
  List<Product> pizzas = [];
  List<Product> salads = [];

  @override
  void initState() {
    super.initState();
    _loadAllCategories();
  }

  Future<void> _loadAllCategories() async {
    // loading Hamburger data
    List<Product> loadedHamburgers = await _loadCategory('hamburgers', LocalStorageHelper.initializeDefaultHamburgers);

    // loading Pizza data
    List<Product> loadedPizzas = await _loadCategory('pizzas', LocalStorageHelper.initializeDefaultPizzas);

    // loading Salad data
    List<Product> loadedSalads = await _loadCategory('salads', LocalStorageHelper.initializeDefaultSalads);

    // UI
    setState(() {
      hamburgers = loadedHamburgers;
      pizzas = loadedPizzas;
      salads = loadedSalads;
    });
  }

  Future<List<Product>> _loadCategory(
      String key, Future<void> Function() initializeDefault) async {
    List<Product> loadedItems = await LocalStorageHelper.loadProductsFromLocalStorage(key);
    if (loadedItems.isEmpty) {
      await initializeDefault();
      loadedItems = await LocalStorageHelper.loadProductsFromLocalStorage(key);
    }
    return loadedItems;
  }

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      StorePage(),
      MapPage(pageTitle: 'Map'),
      homeTab(context, selectedCategory, updateCategories,hamburgers,pizzas,salads),
      CartPage(),
      AddItemPage(),
    ];

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryColor,
          title: Text('Super Eat',
              style: logoWhiteStyle, textAlign: TextAlign.center),
        ),
        body: _tabs[_selectedIndex],

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _loadAllCategories();
          },
          child: Icon(Icons.refresh),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: 'Store',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'My Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_business),
              label: 'Add Item',
            )
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.green[800],
          onTap: _onItemTapped,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

Widget homeTab(BuildContext context, String selectedCategory,
    Function(String) updateCategories,List<Product> hamburgers,
    List<Product> pizzas,List<Product> salads) {


  List<Product> selects = [];

  switch (selectedCategory) {
    case 'Hamburger':
      selects = hamburgers.toList();
      break;
    case 'Pizza':
      selects = pizzas.toList();
      break;
    case 'Salad':
      selects = salads.toList();
      break;
    default:
      selects = [];
      break;
  }

  return ListView(padding: EdgeInsets.symmetric(vertical: 10), children: [
    sectionHeader('All Categories'),
    HeaderTopCategories(onCategoryChanged: updateCategories),
    sectionHeader(selectedCategory),
    Wrap(
      spacing: 1,
      runSpacing: 20,
      children: selects.map((product) {

        return Container(
          width: MediaQuery.of(context).size.width / 2 -
              15,
          child: foodItem(
            product,
            imgWidth: 250,
            onLike: () {},
            onTapped: () {
              // // Cartitems.addToCart(product, 1);
              // ScaffoldMessenger.of(context).showSnackBar(
              // //   SnackBar(content: Text('${product.name} added to cart')),
              // // );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ProductPage(productData: product);
                  },
                ),
              );
            },
          ),
        );
      }).toList(),
    ),
  ]);
}



// wrap the horizontal listview inside a sizedBox..

Widget deals(String dealTitle, {onViewMore, List<Widget>? items}) {
  return Container(
    margin: EdgeInsets.only(top: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        sectionHeader(dealTitle),
        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: (items != null)
                ? items
                : <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text('No items available at this moment.',
                          style: taglineText),
                    )
                  ],
          ),
        )
      ],
    ),
  );
}
