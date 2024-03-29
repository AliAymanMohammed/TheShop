import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/http_exception.dart';
import '../Providers/authentication.dart';
import '../Screens/products_overview_screen.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Your Shop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.subtitle1.color,
                          fontSize: 43,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  AnimationController controller;
  Animation<double> opacityController;
  Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this , duration: Duration(milliseconds: 500),);
    slideAnimation = Tween<Offset>(begin: Offset(0 , -1.5) ,end: Offset(0 , 0)).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
    opacityController = Tween<double>(begin: 0.0 , end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut));
    // heightAnimation.addListener(() => setState(() { }));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void showErrorDialog(String message){
    showDialog(context: context, builder: (context)=> AlertDialog(
      title: Text('Error !'),
      content: Text(message),
      actions: [
        FlatButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text('OK'),),
      ],
    ),);
  }

  Future<void> _submit() async{
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try{
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context , listen: false).signIn(email: _authData['email'], password: _authData['password'])
             .then((_) => Navigator.of(context).pushNamed(ProductsOverViewScreen.routeName));
      } else {
        await Provider.of<Auth>(context , listen: false).signUp(email: _authData['email'], password: _authData['password'])
            .then((_) => Navigator.of(context).pushNamed(ProductsOverViewScreen.routeName));
      }
    } on HttpException catch(error){
      var errorMessage = 'Authentication Failed';
      if(error.toString().contains('EMAIL_EXISTS')){
        errorMessage = 'Email Address already used';
      }else if(error.toString().contains('INVALID_EMAIL')){
        errorMessage = 'Invalid Email Address';
      }else if(error.toString().contains('EMAIL_NOT_FOUND')){
        errorMessage = 'Could not find user with such Email';
      }else if(error.toString().contains('INVALID_PASSWORD')){
        errorMessage ='Invalid Password';
      }
      showErrorDialog(errorMessage);
    }catch(error){
      var errorMessage = 'Could not authenticate you . Please try later';
      showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      controller.reverse();
    }
  }

  IconData suffixIcon = Icons.visibility_rounded;
  var isPassword = true;

  void changeSuffixIcon(){
   setState(() {
     isPassword = !isPassword;
     suffixIcon = isPassword ? Icons.visibility_rounded :Icons.visibility_off_outlined;
   });
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        // height: heightAnimation.value.height,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon:IconButton(onPressed: (){
                      setState(() {
                        changeSuffixIcon();
                      });
                    },icon:  Icon(suffixIcon),),
                  ),
                  obscureText: isPassword,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                // if (_authMode == AuthMode.Signup)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    constraints: BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 60 : 0 , maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                    child: FadeTransition(
                      opacity: opacityController,
                      child: SlideTransition(
                        position: slideAnimation,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(onPressed: (){
                              setState(() {
                                changeSuffixIcon();
                              });
                            },icon:  Icon(suffixIcon),),
                          ),
                          obscureText: isPassword,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
