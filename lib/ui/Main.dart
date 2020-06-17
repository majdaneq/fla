import 'package:core/api/Api.dart';
import 'package:core/api/decoder/forums.dart';
import 'package:core/conf/app.dart';
import 'package:core/generated/l10n.dart';
import 'package:core/ui/Setup.dart';
import 'package:core/ui/Splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('zh', 'CN'),
      ],
      home: Builder(builder: (BuildContext context) {
        initApp(context);
        return Scaffold(
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Text("hello"),
                ),
        );
      }),
    );
  }

  Future<void> initApp(BuildContext context) async {
    if (!await AppConfig.init()) {
      return;
    }
    ForumInfo info;
    if (AppConfig.getUrlList() == null || AppConfig.getUrlList().length == 0) {
      info = await Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return Setup();
      }));
    } else {
      var urlInfo = AppConfig.getIndexUrl();
      info = await Api.checkUrl(urlInfo.url);
    }
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Splash(info);
    }));
  }
}
