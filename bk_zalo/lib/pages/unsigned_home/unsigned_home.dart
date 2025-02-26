import 'package:bk_zalo/pages/unsigned_home/sign_in.dart';
import 'package:bk_zalo/pages/unsigned_home/sign_up.dart';
import 'package:bk_zalo/provider/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isVietnamese = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/zalo1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 190),
                child: Text(
                  "Zalo",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 116, 255),
                    fontSize: 80,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5,
                  height: 60,
                  child: Material(
                    color: Colors.transparent,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 0, 145, 254),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SignIn(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signin,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 3 / 5,
                  height: 60,
                  child: Material(
                    color: Colors.transparent,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 243, 244, 248),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SignUp(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signup,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        provider.setLocale(const Locale('vi'));
                        setState(() {
                          isVietnamese = true;
                        });
                      },
                      child: Text(
                        "Tiếng Việt",
                        style: isVietnamese
                            ? const TextStyle(
                                decoration: TextDecoration.underline)
                            : null,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        provider.setLocale(const Locale('en'));
                        setState(() {
                          isVietnamese = false;
                        });
                      },
                      child: Text(
                        "English",
                        style: isVietnamese
                            ? null
                            : const TextStyle(
                                decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void clickSignin() {}
}
