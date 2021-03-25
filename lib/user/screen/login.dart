import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pick_paper/screens/otp.dart';

class LogIn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "LOG IN",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Log in with your phone number",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        controller: _controller,
                        validator: (value) {
                          if (value.isEmpty)
                            return "Phone number can't be empty";
                          return null;
                        },
                        onSaved: (value) {
                          _phoneNumber = value.trim();
                        },
                        decoration: InputDecoration(
                          hintText: "PHONE",
                          prefixIcon: Icon(
                            Icons.phone,
                          ),
                          prefix: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("+251"),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Builder(
                      builder: (BuildContext context) => InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          _submitForm(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "SEND CODE",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0XFF85FF40),
                                  Color(0XFF0CE69C),
                                ],
                                begin: const FractionalOffset(0.0, 1.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  Text("Terms and Conditions"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submitForm(BuildContext context) async {
    final formState = _formKey.currentState;

    if (formState.validate()) {
      formState.save();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTP(
                    phoneNumber: "+251" + _phoneNumber,
                  )));
    }
  }
}
