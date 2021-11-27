import 'package:bk_zalo/api/api_service.dart';
import 'package:bk_zalo/components/progress_hud.dart';
import 'package:bk_zalo/models/signin_model.dart';
import 'package:bk_zalo/pages/signed_home/main_home.dart';
import 'package:bk_zalo/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPass = true;
  bool hasError = false;
  bool isPhoneEmpty = true;
  bool isPassEmpty = true;
  bool isApiCall = false;
  String errorText = "";
  final TextEditingController _user = TextEditingController();
  final TextEditingController _password = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  var requestModel = LoginRequestModel(phoneNumber: "", password: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _user.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final wp = _size.width * 0.00255;
    final hp = _size.height * 0.00128;
    return ProgressHUD(
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.signin),
          ),
          body: SafeArea(
            child: Container(
              color: ResColors.backgroundColor,
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    constraints: BoxConstraints.expand(
                        width: _size.width, height: 50 * hp),
                    color: const Color.fromARGB(255, 243, 244, 246),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15 * wp),
                      child: Text(
                        AppLocalizations.of(context)!.signin_hint,
                        style: TextStyle(
                          fontSize: 15 * hp,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: globalKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 15 * wp, right: 10 * wp, bottom: 20 * hp),
                          child: TextFormField(
                            onSaved: (input) =>
                                requestModel.phoneNumber = input!,
                            onChanged: (str) {
                              setState(() {
                                isPhoneEmpty = str.isEmpty;
                              });
                            },
                            controller: _user,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.sdt,
                              hintStyle: TextStyle(fontSize: 17 * hp),
                              suffix: _user.text.isEmpty
                                  ? null
                                  : GestureDetector(
                                      child: const Icon(
                                        Icons.close,
                                        color: Color(0xff9AA4A6),
                                      ),
                                      onTap: () {
                                        _user.clear();
                                        setState(() {});
                                      },
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 15 * wp, right: 10 * wp),
                          child: TextFormField(
                            onSaved: (input) => requestModel.password = input!,
                            onChanged: (str) {
                              setState(() {
                                isPassEmpty = str.isEmpty;
                              });
                            },
                            controller: _password,
                            obscureText: showPass,
                            decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.password,
                                hintStyle: TextStyle(fontSize: 17 * hp),
                                errorText: hasError ? errorText : null,
                                suffix: GestureDetector(
                                  child: Text(
                                    showPass
                                        ? AppLocalizations.of(context)!.show
                                        : AppLocalizations.of(context)!.hide,
                                    style: TextStyle(
                                      fontSize: 17 * hp,
                                      color: const Color(0xff9AA4A6),
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15 * wp, top: 20 * wp),
                    child: GestureDetector(
                      onTap: () {
                        print(_size);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.forgot_password,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xff1B92F0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: AlignmentDirectional.bottomEnd,
                          padding:
                              EdgeInsets.only(bottom: 10 * hp, right: 10 * wp),
                          child: ElevatedButton(
                            child: const Icon(Icons.arrow_forward),
                            onPressed: (isPassEmpty || isPhoneEmpty)
                                ? null
                                : loginValidator,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              fixedSize: Size(60 * wp, 60 * wp),
                            ),
                          ),
                        ),
                        Container(
                          alignment: AlignmentDirectional.bottomStart,
                          padding:
                              EdgeInsets.only(left: 15 * wp, bottom: 10 * hp),
                          child: SizedBox(
                            height: 60 * hp,
                            child: Container(
                              alignment: AlignmentDirectional.centerStart,
                              child: GestureDetector(
                                onTap: () {
                                  print("tapped");
                                },
                                child: Text(AppLocalizations.of(context)!.faq),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        inAsyncCall: isApiCall);
  }

  void loginValidator() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    hasError = false;
    errorText = "";
    String sdt = _user.text;
    String pass = _password.text;
    if (sdt.length < 9 || sdt[0] != '0') {
      hasError = true;
      errorText = AppLocalizations.of(context)!.phone_error;
    } else if (pass.length < 6 || pass.length > 256) {
      hasError = true;
      errorText = AppLocalizations.of(context)!.password_error;
    }
    if (hasError) {
      setState(() {
        hasError;
        errorText;
      });
    } else {
      if (validateAndSave()) {
        setState(() {
          isApiCall = true;
        });
        APIService apiService = APIService();
        apiService.login(requestModel).then((value) {
          setState(() {
            isApiCall = false;
          });

          if (value.code == '1000') {
            value.saveData();
            var snackBar = SnackBar(
                content: Text(AppLocalizations.of(context)!.login_success));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const MainHome(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          } else {
            hasError = true;
            errorText = value.message + ' (' + value.code + ')';
            setState(() {
              hasError;
              errorText;
            });
          }
        });
      }
    }
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
