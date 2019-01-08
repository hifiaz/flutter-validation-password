import 'package:examplepassword/itemPass.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Validation Password'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  FocusNode _focus = new FocusNode();
  TextEditingController passController = TextEditingController();
  AnimationController _passController;

  bool visible = false;
  bool eightChars = false;
  bool specialChar = false;
  bool upperChar = false;
  bool number = false;
  bool allValid() {
    return eightChars && specialChar && number && upperChar;
  }

  @override
  void initState() {
    super.initState();
    _focus.addListener(_hide);
    passController.addListener(() {
      setState(() {
        eightChars = passController.text.length >= 8;
        number = passController.text.contains(RegExp(r'\d'), 0);
        upperChar = passController.text.contains(RegExp(r'[A-Z]'), 0);
        specialChar = passController.text.isNotEmpty &&
            !passController.text.contains(RegExp(r'^[\w&.-]+$'), 0);
      });
      if (allValid()) {
        _passController.forward();
      } else {
        _passController.reverse();
      }
    });
    _passController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  void _hide() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                shape: CircleBorder(),
                color: Colors.pink,
                child: Container(
                  height: 100.0,
                  width: 100.0,
                ),
              ),
              SizedBox(
                height: 80.0,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'yourmail@example.com',
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2.0))),
              ),
              visible
                  ? validation()
                  : SizedBox(
                      height: 20.0,
                    ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  obscureText: true,
                  focusNode: _focus,
                  controller: passController,
                  decoration: InputDecoration(
                      hintText: 'set a password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0))),
                ),
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  padding: EdgeInsets.all(18.0),
                  onPressed: () {
                    _hide();
                  },
                  color: Colors.pink[800],
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget validation() {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PassItemValidation('- 8 characters', eightChars),
          PassItemValidation('- 1 special characters', specialChar),
          PassItemValidation('- 1 uppercase', upperChar),
          PassItemValidation('- 1 number', number),
        ],
      ),
    );
  }
}
