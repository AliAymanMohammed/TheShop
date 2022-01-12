import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/products.dart';
import '../Providers/product_provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const String routeName = '/edit-products';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageController = TextEditingController();
  final imageUrlFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var editedProduct = Product(id: null, title: '', description: '', price: 0, imageUrl: '');


  var isLoading = false;
  var ifInit = true;
  var initValues = {
    'title' : '',
    'description' : '',
    'price' : '',
    'imageUrl' : '',
  };

  @override
  void initState() {
    imageUrlFocusNode.addListener(updateImage);
    super.initState();
  }

  void updateImage() {
    if (!imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  // to clear out memory leaks
  @override
  void dispose() {
    imageUrlFocusNode.removeListener(updateImage);
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlFocusNode.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if(ifInit){
     final pId = ModalRoute.of(context).settings.arguments as String;
     if(pId != null){
       editedProduct = Provider.of<ProductProvider>(context , listen: false).findById(pId);
       initValues = {
         'title' : editedProduct.title,
         'description' : editedProduct.description,
         'price' : editedProduct.price.toString(),
         'imageUrl' : '',
       };
       imageController.text = editedProduct.imageUrl;
     }
    }
    ifInit = false;
    super.didChangeDependencies();
  }

  Future <void> saveForm() async{
    final isValid = formKey.currentState.validate();
    if(!isValid){
      return;
    }
    formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    if(editedProduct.id != null){
      await Provider.of<ProductProvider>(context , listen: false).updateProduct(editedProduct.id,editedProduct);
    }else{
      try{
        await Provider.of<ProductProvider>(context , listen: false).addProduct(editedProduct);

      }catch(error){
        showDialog<Null>(context: context, builder: (context) => AlertDialog(title: Text('An Error Occurred'), content: Text('Something went wrong'),actions: [
          FlatButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('Okay')),
        ],));
      }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD & Edit Product'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: Icon(
              Icons.save,
            ),
          )
        ],
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()):Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: ListView(
            children: [
              // title
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Product Title'),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(priceFocusNode);
                },
                initialValue: initValues['title'],
                validator: (value){
                  if(value.isEmpty){
                    return 'Product Title is must';
                  }
                  return null;
              },
                onSaved: (value) {
                  editedProduct = Product(
                      id: editedProduct.id,
                      isFavorite: editedProduct.isFavorite,
                      title: value,
                      description: editedProduct.description,
                      price: editedProduct.price,
                      imageUrl: editedProduct.imageUrl);
                },
              ),
              // price
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Product Price'),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: priceFocusNode,
                initialValue: initValues['price'],
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(descriptionFocusNode);
                },
                validator: (value){
                  if(value.isEmpty){
                    return 'Product Price is must';
                  }
                  if(double.tryParse(value) == null){
                    return 'Please Enter A Valid Number';
                  }
                  if(double.tryParse(value) <= 0 ){
                    return 'Please Enter A Number Greater Than Zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                      id: editedProduct.id,
                      isFavorite: editedProduct.isFavorite,
                      title: editedProduct.title,
                      description: editedProduct.description,
                      price: double.parse(value),
                      imageUrl: editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Product Description'),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: descriptionFocusNode,
                initialValue: initValues['description'],
                validator: (value){
                  if(value.isEmpty){
                    return 'Product Description is must';
                  }
                  if(value.length < 10){
                    return 'Please Describe Your Product More';
                  }
                  return null;
                },
                onSaved: (value) {
                  editedProduct = Product(
                      id: editedProduct.id,
                      isFavorite: editedProduct.isFavorite,
                      title: editedProduct.title,
                      description: value,
                      price: editedProduct.price,
                      imageUrl: editedProduct.imageUrl);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 10, top: 8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: imageController.text.isEmpty
                        ? Text('Enter Url')
                        : FittedBox(
                            child: Image.network(imageController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image Url',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageController,
                      focusNode: imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        saveForm();
                      },
                      validator: (value){
                        if(value.isEmpty){
                          return 'Product ImageUrl is must';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Please Enter A Valid URL';
                        }
                        if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                          return 'Please Enter A Valid Image URL';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        editedProduct = Product(
                            id: editedProduct.id,
                            isFavorite: editedProduct.isFavorite,
                            title: editedProduct.title,
                            description: editedProduct.description,
                            price: editedProduct.price,
                            imageUrl: value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          key: formKey,
        ),
      ),
    );
  }
}
