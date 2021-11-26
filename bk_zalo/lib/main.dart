import 'package:bk_zalo/locale/locale.dart';
import 'package:bk_zalo/pages/splash.dart';
import 'package:bk_zalo/pages/unsigned_home/unsigned_home.dart';
import 'package:bk_zalo/provider/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => LocaleProvider(),
    builder: (context, child) {
      final provider = Provider.of<LocaleProvider>(context);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const Loading(),
          '/login': (context) => const Home(),
        },
        locale: provider.locale,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      );
    },
  ));
}
