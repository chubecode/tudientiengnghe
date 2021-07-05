import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tieng_nghe/features/main/main.dart';
import 'package:flutter_tieng_nghe/generated/codegen_loader.g.dart';
import 'package:flutter_tieng_nghe/generated/locale_keys.g.dart';
import 'package:get_it/get_it.dart';
import 'features/main/bloc/main_bloc.dart';

import 'common/appTheme.dart';
import 'common/deeplink/deeplink_init.dart';
import 'common/deeplink/deeplink_navigator.dart';
import 'package:uni_links2/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;

//Run when change string json file
//flutter pub run easy_localization:generate --source-dir ./assets/translations
//flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart
// => LocaleKeys.money_args

//Run when change retrofit config
//flutter pub run build_runner build --delete-conflicting-outputs
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  _initGetItDi();

  try {
    String? initialDeeplink = await getInitialLink();
    GetIt.instance.get<DeeplinkInit>().updateInitDeeplink(initialDeeplink);
  } on PlatformException {
    // Handle exception by warning the user their action did not succeed
    // return?
  }

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      startLocale: Locale('en'),
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: StartApp(),
    ),
  );
}

void _initGetItDi() {
  GetIt.instance.registerSingleton(DeeplinkInit());
  GetIt.instance.registerSingleton(DeeplinkNavigator());
  // GetIt.instance.registerFactory(() => CheckUserStateUseCase());
  // GetIt.instance.registerLazySingleton<WebcomicRepository>(
  //         () => WebcomicRepositoryImpl());
  // GetIt.instance.registerFactory(() => GetWebComicsUseCase());
}

class StartApp extends StatefulWidget {

  @override
  _StartAppState createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> {

  StreamSubscription? _sub;

  @override
  void initState() {
    String? initDeeplink = GetIt.instance.get<DeeplinkInit>().getInitDeeplink();
    if(initDeeplink != null) {
      GetIt.instance.get<DeeplinkNavigator>().gotoDeeplink(context, initDeeplink);
    }
    GetIt.instance.get<DeeplinkInit>().clearInitDeeplink();

    _sub = linkStream.listen((String? link) {
      if (!mounted) return;
      if(link != null) {
        GetIt.instance.get<DeeplinkNavigator>().gotoDeeplink(context, link);
      }
    }, onError: (err) {
      if (!mounted) return;
      //TODO nothing to do here
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      create: (BuildContext context) => MainBloc()..add(InitEvent()),
      child: MaterialApp(
        title: LocaleKeys.app_title.tr(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
        ),
        initialRoute: MainScreen.screenName,
        routes: {
          MainScreen.screenName: (context) => MainScreen(),
          // TitleDetailScreen.screenName: (context) => TitleDetailScreen(),
        },
      ),
    );
  }
}
