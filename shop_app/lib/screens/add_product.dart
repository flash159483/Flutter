import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/product_provider.dart';

class Add_Product extends StatefulWidget {
  static const RouteName = './Add_Product';
  @override
  State<Add_Product> createState() => _Add_ProductState();
}

class _Add_ProductState extends State<Add_Product> {
  final _priceFocus = FocusNode();
  final _desciFocus = FocusNode();
  final _urlController = TextEditingController();
  final _urlFocus = FocusNode();
  final _globalkey = GlobalKey<FormState>();
  bool _checkEnter = true;
  bool _loading = false;

  var _tmpSave = Product(
    description: '',
    id: null,
    imageUrl: '',
    price: 0,
    title: '',
  );

  final _initValue = {
    'title': '',
    'id': '',
    'price': '',
    'description': '',
  };

  @override
  void initState() {
    // TODO: implement initState
    _urlFocus.addListener(_updateUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_checkEnter) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _tmpSave = Provider.of<Product_Provider>(context, listen: false)
            .itemById(productId);
        _initValue['title'] = _tmpSave.title;
        _initValue['price'] = _tmpSave.price.toString();
        _initValue['description'] = _tmpSave.description;
        _initValue['id'] = productId;
        _urlController.text = _tmpSave.imageUrl;
      }
    }
    _checkEnter = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocus.dispose();
    _desciFocus.dispose();
    _urlController.dispose();
    _urlFocus.dispose();
    _urlController.removeListener(_updateUrl);
    super.dispose();
  }

  void _updateUrl() {
    if (!_urlFocus.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    bool check = _globalkey.currentState.validate();
    if (!check) {
      return;
    }
    _globalkey.currentState.save();
    final p = Provider.of<Product_Provider>(context, listen: false);
    setState(() {
      _loading = true;
    });
    if (_tmpSave.id != null) {
      await p.updateProduct(_tmpSave.id, _tmpSave);
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await p.addProduct(_tmpSave);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text('Something went Wrong failed to add the product'),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ]),
        );
      } finally {
        setState(() {
          _loading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _globalkey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValue['title'],
                        decoration: InputDecoration(
                          label: Text('Title'),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        onSaved: (newValue) {
                          _tmpSave = Product(
                            description: _tmpSave.description,
                            title: newValue,
                            imageUrl: _tmpSave.imageUrl,
                            price: _tmpSave.price,
                            id: _tmpSave.id,
                            favorite: _tmpSave.favorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the title';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['price'],
                        decoration: InputDecoration(
                          label: Text('price'),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocus,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_desciFocus);
                        },
                        onSaved: (newValue) {
                          _tmpSave = Product(
                            description: _tmpSave.description,
                            title: _tmpSave.title,
                            imageUrl: _tmpSave.imageUrl,
                            price: double.parse(newValue),
                            id: _tmpSave.id,
                            favorite: _tmpSave.favorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please enter price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter number above zero';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _initValue['description'],
                        decoration: InputDecoration(
                          label: Text('description'),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _desciFocus,
                        onSaved: (newValue) {
                          _tmpSave = Product(
                            description: newValue,
                            title: _tmpSave.title,
                            imageUrl: _tmpSave.imageUrl,
                            price: _tmpSave.price,
                            id: _tmpSave.id,
                            favorite: _tmpSave.favorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the description';
                          }
                          if (value.length < 10) {
                            return 'Description have to be longer than 10 letters';
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            margin: EdgeInsets.only(top: 20, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: _urlController.text.isEmpty
                                ? Container()
                                : FittedBox(
                                    child: Image.network(_urlController.text),
                                    fit: BoxFit.contain),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: Text('Input Url Here'),
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _urlController,
                              focusNode: _urlFocus,
                              onSaved: (newValue) {
                                _tmpSave = Product(
                                  description: _tmpSave.description,
                                  title: _tmpSave.title,
                                  imageUrl: newValue,
                                  price: _tmpSave.price,
                                  id: _tmpSave.id,
                                  favorite: _tmpSave.favorite,
                                );
                              },
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter the url';
                                }
                                if (!Uri.parse(value).isAbsolute) {
                                  return 'Please enter a valid URL';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
