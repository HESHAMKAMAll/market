import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../controller/theme.dart';
import '../../utils/utils.dart';
import '../../widgets/text_field_custom.dart';

class VendorAddProductsScreen extends StatefulWidget {
  @override
  State<VendorAddProductsScreen> createState() => _VendorAddProductsScreenState();
}

class _VendorAddProductsScreenState extends State<VendorAddProductsScreen> with AutomaticKeepAliveClientMixin<VendorAddProductsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  Uint8List? _image;
  String? fileName;
  int randomo = Random().nextInt(999999999);
  int randomt = Random().nextInt(999999999);
  String dropdownValue = list.first;

  pickImage() async {
    var _file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_file != null) {
      _image = await _file.readAsBytes();
      fileName = await basename(_file.path);
      setState(() {});
    }
  }

  _uploadBannersToStorage(dynamic image) async {
    Reference reference = _storage.ref().child("products").child("$randomo$fileName$randomt");
    UploadTask uploadTask = reference.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  _uploadToFirestore({required price, required String title, required String details}) async {
    FocusManager.instance.primaryFocus!.unfocus();
    if (_image != null && title.isNotEmpty && price != null && details.isNotEmpty) {
      var phone = await _firestore.collection("users").doc(_auth.currentUser!.uid).get();
      setState(() {
        _isLoading = true;
      });
      String imageUrl = await _uploadBannersToStorage(_image);

      await _firestore.collection("products").doc("$randomo$fileName$randomt").set({
        "category": dropdownValue,
        "likes": [],
        "permission": false,
        "ProductDetails": details,
        "productsID": "$randomo$fileName$randomt",
        "time": DateTime.now(),
        "username": phone["username"],
        "email": _auth.currentUser!.email,
        "uid": _auth.currentUser!.uid,
        "phone": phone["phone"],
        "userImage": phone["photoUrl"],
        "productImage": imageUrl,
        "price": price,
        "title": title,
      });
      setState(() {
        _isLoading = false;
      });
      titleController.clear();
      detailsController.clear();
      priceController.clear();
      _image = null;
      fileName = null;
      setState(() {});
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    detailsController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Provider.of<MyTheme>(context).theme == Brightness.light ? Colors.white : Color.fromRGBO(28, 28, 28, 1),
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child:
        MediaQuery.of(context).size.width >= 1025
            ? Column(
                children: [
                  Text(
                    'Upload Products',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 500,
                        child: GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 400,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // color: Color.fromRGBO(55, 51, 64, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(
                                        _image!,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset("assets/images/add.png"),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          fileName != null ? Text(fileName.toString()) : SizedBox(height: 20),
                          DropdownMenu<String>(
                            initialSelection: list.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(value: value, label: value);
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          TextFieldCustom(
                            controller: titleController,
                            hintText: "product Title",
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 10),
                          TextFieldCustom(
                            controller: detailsController,
                            hintText: "Product Details",
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(height: 10),
                          TextFieldCustom(
                            controller: priceController,
                            hintText: "product \$ Price",
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (titleController.text.isNotEmpty && detailsController.text.isNotEmpty && priceController.text.isNotEmpty) {
                                _uploadToFirestore(
                                    title: titleController.text, details: detailsController.text, price: double.parse(priceController.text));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(500, 45),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text("Save", style: TextStyle(color: Colors.white, fontSize: 22)),
                          ),
                        ],

                      ),
                    ],
                  ),

                ],
              )
            : Column(
                children: [
                  Text(
                    'Upload Products',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(55, 51, 64, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  _image!,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset("assets/images/add.png"),
                              ),
                      ),
                    ),
                  ),
                  fileName != null ? Text(fileName.toString()) : SizedBox(height: 20),
                  DropdownMenu<String>(
                    initialSelection: list.first,
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  TextFieldCustom(
                    controller: titleController,
                    hintText: "product Title",
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                  TextFieldCustom(
                    controller: detailsController,
                    hintText: "Product Details",
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 10),
                  TextFieldCustom(
                    controller: priceController,
                    hintText: "product \$ Price",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty && detailsController.text.isNotEmpty && priceController.text.isNotEmpty) {
                        _uploadToFirestore(
                            title: titleController.text, details: detailsController.text, price: double.parse(priceController.text));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(500, 45),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text("Save", style: TextStyle(color: Colors.white, fontSize: 22)),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
