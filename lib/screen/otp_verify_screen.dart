import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:lets_connect/services/phone_auth.dart';

class OtpVerifyScreen extends StatefulWidget {
  final phoneNumber;
  OtpVerifyScreen({@required this.phoneNumber});

  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _textController = TextEditingController();

  @override
  void initState() {
    PhoneAuth.verifyNumber(widget.phoneNumber, context, _textController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _smsCode = ModalRoute.of(context).settings.arguments as String;
    _textController.text = (_smsCode != null) ? _smsCode : _textController.text;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(children: [
            Image.asset('assets/images/otp_image.gif'),
            Text(
              'Enter 6 digit verification code sent to ${widget.phoneNumber}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(
              height: 35,
            ),
            PinCodeTextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              appContext: context,
              length: 6,
              onChanged: (value) {
                print(value);
              },
              pinTheme: PinTheme(
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColorLight,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(25),
                fieldHeight: 50,
                fieldWidth: 40,
              ),
              boxShadows: [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.black12,
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: mediaQuery.size.width, height: 50),
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Confirm', style: TextStyle(fontSize: 18)),
                      Icon(Icons.navigate_next)
                    ],
                  ),
                  onPressed: () {
                    PhoneAuth.verifyOtp(_textController.text, context);
                  },
                ))
          ]),
        ),
      ),
    );
  }
}
