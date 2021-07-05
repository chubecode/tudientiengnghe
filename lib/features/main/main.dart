
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tieng_nghe/common/components/background.dart';
import 'package:flutter_tieng_nghe/features/main/bloc/main_bloc.dart';

class MainScreen extends StatelessWidget {
  static final screenName = "/";
  final PageController controller =
  PageController(initialPage: 1, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        GlobalKey<ScaffoldState> _mainKey = GlobalKey();
        return BlocListener<MainBloc, MainState>(
          listener: (context, MainState state) {
            _listenBlocChange(state, context);
          },
          child: Scaffold(
            key: _mainKey,
            body: SafeArea(
              child: Stack(
                children: [
                  // WebtoonPageView(),
                  // MyCustomAppBar(
                  //   onDrawerTap: () => {_mainKey.currentState!.openDrawer()},
                  //   height: 60,
                  // ),
                  Background(child: Text("Từ điển tiếng Nghệ"))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _listenBlocChange(MainState state, BuildContext context) {
    // if (state is UserStateNotYetLogin) {
    //   Navigator.of(context)
    //       .popUntil(ModalRoute.withName(MainScreen.screenName));
    // }
  }


}
