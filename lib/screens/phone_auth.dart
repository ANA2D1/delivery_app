import 'package:delivery_app/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_count_down.dart';

class MobileNumberInputPage extends StatefulWidget {
  @override
  _MobileNumberInputPageState createState() => _MobileNumberInputPageState();
}

class _MobileNumberInputPageState extends State<MobileNumberInputPage> {
  String mobileNum;

  // final _frmKey = GlobalKey<FormState>();
  _submitNum(context) => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => OtpInputPage(
            mobNum: mobileNum,
          )));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: EdgeInsets.only(
                top: 50,
                bottom: 30,
              ),
              child: Center(
                child: Container(
                  height: 120,
                  child: Placeholder(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  "Welcome",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      // width: SizeConfig.widthMultiplier * 89,
                      child: TextFormField(
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (str) {
                          if (mobileNum != null && mobileNum.length == 10)
                            _submitNum(context);
                          else
                            Fluttertoast.showToast(
                                msg: "Please enter 10 digit mobile number!");

                          // print(str);
                        },
                        onChanged: (str) {
                          mobileNum = str;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                )),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 1,
                                )),
                            alignLabelWithHint: true,
                            prefixIcon: Icon(
                              Icons.phone_iphone,
                              color: Colors.black,
                            ),
                            prefixText: "+91",
                            labelText: "Mobile number",
                            labelStyle: TextStyle(color: Colors.black)
                            // hintText: "Mobile Number ",
                            ),
                        onSaved: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: MyCustomButton(
            text: "Get OTP",
            onTap: () {
              if (mobileNum != null && mobileNum.length == 10)
                _submitNum(context);
              else
                Fluttertoast.showToast(
                    msg: "Please enter 10 digit mobile number!");
            },
          ),
        ),
      ),
    );
  }
}

class MyCustomButton extends StatelessWidget {
  final onTap;
  final text;
  const MyCustomButton({this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.blue,
        height: 60,
        child: Center(child: Text(text, style: TextStyle(color: Colors.white))),
      ),
    );
  }
}

class OtpInputPage extends StatefulWidget {
  final String mobNum;
  OtpInputPage({@required this.mobNum});
  @override
  _OtpInputPageState createState() => _OtpInputPageState();
}

class _OtpInputPageState extends State<OtpInputPage> {
  String verificationId;
  String smsCode;

  bool showResend = false;
  // bool showResend=false;
  @override
  void initState() {
    verifyNumber();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(size.width * 0.02),
                  child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.height * 0.12, bottom: size.height * 0.01),
                  child: Text("Enter OTP",
                      style: TextStyle(
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.height * 0.12, bottom: size.height * 0.04),
                  child: Text("Sent to ${widget.mobNum}",
                      style: TextStyle(
                          fontSize: size.height * 0.02, color: Colors.green)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.height * 0.12,
                      vertical: size.height * 0.02),
                  child: PinFieldAutoFill(
                    decoration: BoxLooseDecoration(
                      strokeWidth: 1,
                      gapSpace: 10,
                      strokeColorBuilder:
                          PinListenColorBuilder(Colors.green, Colors.grey),
                    ),
                    onCodeChanged: (str) {
                      smsCode = str;
                      if (str.length == 6) {
                        _otpSubmit(str);
                      }
                    },
                    onCodeSubmitted: _otpSubmit,
                    codeLength: 6,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.height * 0.12),
                  child: Container(
                    height: size.height * 0.05,
                    child: showResend
                        ? InkWell(
                            onTap: () {
                              verifyNumber();
                              setState(() {
                                showResend = false;
                              });
                            },
                            child: Text(
                              "Did not recieved? resend OTP",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          )
                        : Countdown(
                            seconds: 30,
                            build: (_, time) => Text(
                              "Please wait   00:${time.round()}",
                              style: TextStyle(fontSize: 15),
                            ),
                            interval: Duration(seconds: 1),
                            onFinished: () {
                              setState(() {
                                showResend = true;
                              });
                            },
                          ),
                  ),
                ),
              ]),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: MyCustomButton(
            // width: SizeConfig.widthMultiplier * 85,
            text: "Verify OTP",
            onTap: () {
              if (smsCode.length == 6)
                _otpSubmit(smsCode);
              else
                Fluttertoast.showToast(msg: "Please enter 6 digit OTP!");
            },
          ),
        ),
      ),
    );
  }

  Future<void> verifyNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID) {
      this.verificationId = verID;
      Fluttertoast.showToast(msg: "auto reetrive timeout");
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
      FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        Fluttertoast.showToast(msg: "Logged in successfully");
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
      }).catchError((e) => print(e));
    };

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationId = verID;
      Fluttertoast.showToast(msg: "OTP sent to ${widget.mobNum}");
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print(exception.message);
      Fluttertoast.showToast(msg: "Verification Failed");
    };
    // print("befor");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.mobNum}',
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFailed);
    // print("after");
  }

  _otpSubmit(str) async {
    if (str?.length == 6) {
      var _user = await FirebaseAuth.instance.currentUser();
      if (_user != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
        // ));
      } else {
        // Navigator.pop(context);
        signIn(str);
      }
    } else
      Fluttertoast.showToast(msg: "Please enter 6 digit OTP");
  }

  signIn(str) {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: str,
    );
    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      if (user != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
      }
    }).catchError((e) => print(e));
  }
}
