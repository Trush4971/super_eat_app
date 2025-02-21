import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './styles.dart';

// Example color constants (you can replace with your own)
const Color white = Colors.white;
const Color green = Colors.green;
const Color categoryText = Colors.black;

class HeaderTopCategories extends StatefulWidget {
  final Function(String) onCategoryChanged;

  HeaderTopCategories({Key? key, required this.onCategoryChanged}) : super(key: key);

  @override
  _HeaderTopCategoriesState createState() => _HeaderTopCategoriesState();
}

class _HeaderTopCategoriesState extends State<HeaderTopCategories> {
  // String selectedCategory = 'Pizza';
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              headerCategoryItem('Hamburger', FontAwesomeIcons.burger),
              headerCategoryItem('Pizza', FontAwesomeIcons.pizzaSlice),
              headerCategoryItem('Salad', FontAwesomeIcons.leaf),
            ],
          ),
        ),
      ],
    );
  }

  Widget headerCategoryItem(String name, IconData icon) {
    bool isSelected = selectedCategory == name;
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
              shape: CircleBorder(),
              heroTag: name,
              onPressed: () {
                setState(() {
                  selectedCategory = name;
                });
                widget.onCategoryChanged(name);
              },
              backgroundColor: isSelected ? green : white,
              child: Icon(icon, size: 40, color: isSelected ? white : Colors.black87),
            ),
          ),
          Text(name + ' ›', style: h5),
        ],
      ),
    );
  }
}
