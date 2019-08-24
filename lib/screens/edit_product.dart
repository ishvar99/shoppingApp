import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class EditProduct extends StatefulWidget {
  static const namedroute = '/edit-products';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  // final _titleController = TextEditingController();
  // final _priceController = TextEditingController();
  // final _descriptionController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _init = true;
  var _isLoading = false;
  String prodStatus;
  var _initialValues = {
    'title': '',
    'price': '',
    'description': '',
  };
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0.0, imageUrl: '',isFavorite: false);
  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(updateImage);
    super.dispose();
  }

  void updateImage() {
    if (!_imageUrlFocusNode.hasFocus) setState(() {});
  }

  // bool isEdited() {
  //    }

  void saveProduct() {
    bool valid = _formKey.currentState.validate();
    if (!valid) return;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to save this product!'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    Navigator.of(context).pop(true);
                    
                  },
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            )).then((val) async {
      if (val) {
        _formKey.currentState.save();
        if (_editedProduct.id != null) {
          try{
           await Provider.of<Products>(context)
              .updateProduct(_editedProduct.id, _editedProduct);
          }catch(error){
            print(error);
          }
        } else {
          try {
            await Provider.of<Products>(context, listen: false)
                .addProduct(_editedProduct);
          } catch (error) {
            await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text('An Error Occurred!'),
                      content: Text('Something went wrong...'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Okay'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          }
        } 
            setState(() {
              _isLoading = false;
            });  
            Navigator.of(context).pop();
          
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveProduct,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        // onEditingComplete: isEdited,
                        decoration: InputDecoration(labelText: 'Title'),
                        initialValue: _initialValues['title'],
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) return 'Title field is required!';
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        initialValue: _initialValues['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) return 'Price field is required!';
                          if (double.tryParse(val) == null)
                            return 'Price must be a number!';
                          if (double.parse(val) <= 0) return 'Invalid price!';
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        // onEditingComplete: isEdited,
                        initialValue: _initialValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        textInputAction: TextInputAction.next,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (val) {
                          if (val.isEmpty)
                            return 'Description field is requried';
                          if (val.length < 10)
                            return 'Description must be atleast 10 characters long!';
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(right: 10, top: 8),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a Url')
                                  : FittedBox(
                                      fit: BoxFit.contain,
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                          Expanded(
                            child: TextFormField(
                              // onEditingComplete: isEdited,
                              decoration:
                                  InputDecoration(labelText: 'Image Url'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              validator: (val) {
                                if (val.isEmpty) return 'imageUrl is required!';
                                if (!val.startsWith('http') &&
                                    !val.startsWith('https'))
                                  return 'Invalid imageUrl';
                                if (!val.endsWith('png') &&
                                    !val.endsWith('jpg') &&
                                    !val.endsWith('jpeg'))
                                  return 'Invalid imageUrl';
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                    id: _editedProduct.id,
                                    title: _editedProduct.title,
                                    description: _editedProduct.description,
                                    price: _editedProduct.price,
                                    imageUrl: value,
                                    isFavorite: _editedProduct.isFavorite);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
