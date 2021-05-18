import 'package:flutter/material.dart';
import './otp_verify_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _numberController = TextEditingController();
  var phoneNumber;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/mobile.png',
                  height: mediaQuery.size.height * 0.6,
                  width: mediaQuery.size.height * 0.5),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'We will send you a ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(
                        text: 'One Time Password ',
                        style: Theme.of(context).textTheme.subtitle1),
                    TextSpan(
                        text: 'on this number',
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
              SizedBox(height: 15),
              TextField(
                  autocorrect: false,
                  controller: _numberController,
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '+91',
                    hintStyle: Theme.of(context).textTheme.bodyText1,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  )),
              SizedBox(height: 20),
              ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: mediaQuery.size.width, height: 50),
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Next', style: TextStyle(fontSize: 18)),
                        Icon(Icons.navigate_next)
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) =>
                              OtpVerifyScreen(phoneNumber: phoneNumber)));
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
