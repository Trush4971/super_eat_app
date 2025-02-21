import '../entities/product.dart';
import '../services/local_storage_helper.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/input_fields.dart';
import '../shared/section_header_widgets.dart';
import '../shared/buttons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:flutter/material.dart';
import 'home_dashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'dart:convert'; //  Base64 Convert

class AddItemPage extends StatefulWidget {
  final String? pageTitle;

  AddItemPage({Key? key, this.pageTitle}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedCategory;
  bool isRecommended = false;
  bool categoryError = false;

  Uint8List? _selectedImage; // SELECT IMAGE

  void _addItem() async{
    setState(() {
      categoryError = selectedCategory == null;
    });

    if (_formKey.currentState?.validate() ?? false) {
      if (selectedCategory == null) {
        return;
      }
    }

    String imageBase64 = '';
    if (_selectedImage != null) {
      imageBase64 = base64Encode(_selectedImage!);
    }

    final newItem = Product(
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      description: _descriptionController.text.trim(),
      isHamburger: selectedCategory == "Burger"
          ? true
          : selectedCategory == "Pizza"
          ? false
          : null,
      isRecommended: isRecommended,
      image: imageBase64, // SAVE IMAGE PATH
    );
    try {

      if (selectedCategory == 'Burger') {
        LocalStorageHelper.saveProductsToLocalStorage('hamburgers', [newItem]);
      } else if (selectedCategory == 'Pizza') {
        LocalStorageHelper.saveProductsToLocalStorage('pizzas', [newItem]);
      } else if (selectedCategory == 'Salad') {
        LocalStorageHelper.saveProductsToLocalStorage('salads', [newItem]);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add item: $e')),
      );
      print('Error while saving item: $e');
    }

    // if (selectedCategory == 'Burger') {
    //   LocalStorageHelper.saveProductsToLocalStorage('hamburgers', [newItem]);
    // } else if (selectedCategory == 'Pizza') {
    //   LocalStorageHelper.saveProductsToLocalStorage('pizzas', [newItem]);
    // } else if (selectedCategory == 'Salad') {
    //   LocalStorageHelper.saveProductsToLocalStorage('salads', [newItem]);
    // }
    //
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Item added successfully!')),
    // );
    //
    //catch

    // Clear the form
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();

    setState(() {
      selectedCategory = null;
      isRecommended = false;
      categoryError = false;
      _selectedImage = null;
    });

  }


  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndSaveImage() async {
    try {
      // select image
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isEmpty) return;

        // convert Base64
        final reader = html.FileReader();
        reader.readAsDataUrl(files[0]); // read Base64
        reader.onLoadEnd.listen((e) {
          setState(() {
            _selectedImage = base64Decode(reader.result.toString().split(',')[1]); // get Base64 data
          });
        });
      });
    } catch (e) {
      print("Image selection failure：$e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image selection failure")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Form(
              key: _formKey, // use form key
              child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add An Item', style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),

                    GestureDetector(
                      onTap: _pickAndSaveImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: _selectedImage != null
                            ? Image.memory(_selectedImage!, fit: BoxFit.cover)
                            : Center(
                          child: Icon(Icons.add_a_photo, size: 50,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text('Item Name:', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: 'Enter item name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Item Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    Text('Item Price:', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(hintText: 'Enter item price'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Item Price cannot be empty';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Item Price must be a number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    Text('Item Description:', style: TextStyle(fontSize: 16)),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(hintText: 'Enter item description'),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Item Description cannot be empty' : null,
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('It is Recommended by chef', style: TextStyle(fontSize: 16)),
                        Switch(
                          value: isRecommended,
                          onChanged: (bool newValue) {
                            setState(() {
                              isRecommended = newValue;
                            });
                          },
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Text('Item Category:', style: TextStyle(fontSize: 16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCategoryRadio('Pizza'),
                        _buildCategoryRadio('Burger'),
                        _buildCategoryRadio('Salad'),
                      ],
                    ),
                    if (categoryError) ...[
                      SizedBox(height: 5),
                      Text('Please select a category', style: TextStyle(color: Colors.red)),
                    ],
                    SizedBox(height: 20),

                    Container(
                      alignment: Alignment.center,
                      width: 400,
                      child: ElevatedButton(
                        onPressed: _addItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(
                          "Add An Item",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

            ),
            height: 800,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRadio(String category) {
    return Row(
      children: [
        Radio<String>(
          value: category,
          groupValue: selectedCategory,
          onChanged: (String? value) {
            setState(() {
              selectedCategory = value;
              categoryError = false;
            });
          },
        ),
        Text(category, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}


