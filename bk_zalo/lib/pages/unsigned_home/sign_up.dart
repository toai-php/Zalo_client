import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/progress_hud.dart';
import 'package:bk_zalo/models/signup_model.dart';
import 'package:bk_zalo/pages/unsigned_home/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

late GetUserModel signupResponseModel;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _password = TextEditingController();
  final _phone = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  var signupRequestModel = SignupRequestModel();

  // ignore: prefer_final_fields
  late Map<int, dynamic> mapBody;
  int bodyPos = 1;
  bool isButtonPass = true;
  bool isButtonPhone = true;
  bool showPass = true;
  bool hasError = false;
  bool hasError2 = false;
  bool inAsyncCall = false;
  String errorText = "";
  String errorText2 = "";

  Widget _body() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              constraints: const BoxConstraints.expand(
                  width: double.infinity, height: 50),
              color: const Color.fromARGB(255, 243, 244, 246),
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  AppLocalizations.of(context)!.signup_hint,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 10),
              child: TextFormField(
                key: globalKey,
                onChanged: (input) {
                  setState(() {
                    isButtonPhone = _phone.text.isEmpty;
                  });
                },
                autofocus: true,
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enter_phone,
                  hintStyle: const TextStyle(fontSize: 17),
                  errorText: hasError ? errorText : null,
                  suffix: _phone.text.isEmpty
                      ? null
                      : GestureDetector(
                          child: const Icon(
                            Icons.close,
                            color: Color(0xff9AA4A6),
                          ),
                          onTap: () {
                            _phone.clear();
                          },
                        ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.bottomEnd,
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: ElevatedButton(
                  child: const Icon(Icons.arrow_forward),
                  onPressed: isButtonPhone
                      ? null
                      : () {
                          hasError = false;
                          if (_phone.text[0] != '0' ||
                              _phone.text.isEmpty ||
                              _phone.text.length < 10) {
                            setState(() {
                              hasError = true;
                              errorText =
                                  AppLocalizations.of(context)!.phone_error;
                            });
                          } else {
                            setState(() {
                              inAsyncCall = true;
                            });
                            APIService apiService = APIService();
                            apiService.getUser(_phone.text).then((value) {
                              setState(() {
                                inAsyncCall = false;
                              });
                              if (value.code == '9996') {
                                signupResponseModel = value;
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 200),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const UserExisted(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ));
                              } else if (value.code != '1000') {
                                setState(() {
                                  hasError = true;
                                  errorText = value.message;
                                });
                              } else {
                                FocusScope.of(context).nextFocus();
                                setState(() {
                                  hasError = false;
                                  bodyPos = 2;
                                });
                              }
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    fixedSize: const Size(60, 60),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body2() {
    return SafeArea(
      child: Container(
        color: Colors.white,
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              constraints: const BoxConstraints.expand(
                  width: double.infinity, height: 50),
              color: const Color.fromARGB(255, 243, 244, 246),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  AppLocalizations.of(context)!.enter_password,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 10),
              child: TextFormField(
                key: globalKey,
                onChanged: (str) {
                  setState(() {
                    isButtonPass = _password.text.isEmpty;
                  });
                },
                autofocus: true,
                obscureText: showPass,
                controller: _password,
                keyboardType: TextInputType.visiblePassword,
                autocorrect: false,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.password,
                    hintStyle: const TextStyle(fontSize: 17),
                    errorText: hasError2 ? errorText2 : null,
                    suffix: GestureDetector(
                      child: Text(
                        showPass
                            ? AppLocalizations.of(context)!.show
                            : AppLocalizations.of(context)!.hide,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xff9AA4A6),
                        ),
                      ),
                      onTap: () {
                        showPass = !showPass;
                        setState(() {
                          showPass;
                        });
                      },
                    )),
              ),
            ),
            Expanded(
              child: Container(
                alignment: AlignmentDirectional.bottomEnd,
                padding: const EdgeInsets.only(bottom: 10, right: 10),
                child: ElevatedButton(
                  child: const Icon(Icons.arrow_forward),
                  onPressed: isButtonPass
                      ? null
                      : () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          hasError = false;
                          signupRequestModel.phone = _phone.text;
                          signupRequestModel.passwd = _password.text;
                          print(signupRequestModel.phone);
                          print(signupRequestModel.passwd);
                          if (_password.text.length < 6) {
                            setState(() {
                              hasError = true;
                              errorText = AppLocalizations.of(context)!
                                  .password_invalid;
                            });
                          } else {
                            setState(() {
                              inAsyncCall = true;
                            });

                            APIService apiService = APIService();
                            apiService.signup(signupRequestModel).then((value) {
                              setState(() {
                                inAsyncCall = false;
                              });

                              if (value.code == '1000') {
                                var snackBar = SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .signup_success));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 200),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const SignIn(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ));
                              } else {
                                hasError = true;
                                errorText =
                                    value.message + ' (' + value.code + ')';
                                setState(() {
                                  hasError;
                                  errorText;
                                });
                              }
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    fixedSize: const Size(60, 60),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    mapBody = {1: _body, 2: _body2};
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: _signup(context), inAsyncCall: inAsyncCall);
  }

  Widget _signup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signup),
        leading: BackButton(
          onPressed: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            if (bodyPos > 1) {
              bodyPos--;
              setState(() {
                bodyPos;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: mapBody[bodyPos](),
    );
    ;
  }
}

class UserExisted extends StatelessWidget {
  const UserExisted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.user_valid),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 20, left: 10, bottom: 50),
                child: Text(
                  AppLocalizations.of(context)!.user_valid_message,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Image(
                  width: 80,
                  height: 80,
                  image: signupResponseModel.data['avtlink'] != null
                      ? NetworkImage(signupResponseModel.data['avtlink'])
                      : const NetworkImage(
                          'https://iupac.org/wp-content/uploads/2018/05/default-avatar.png'),
                ),
              ),
              Text(signupResponseModel.data['phone']),
              Text(signupResponseModel.data['name'] ??
                  AppLocalizations.of(context)!.invalid_name),
            ],
          ),
        ),
      ),
    );
  }
}
