import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/provider_modal.dart';
import 'index_page.dart';
import './routers/application.dart';
import './routers/routes.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  final isLogin = IsLoginModal();
  // final
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => IsLoginModal(),
          )
        ],
        child: Consumer<IsLoginModal>(
          builder: (context, counter, _) {
            return Container(
              child: MaterialApp(
                title: '博客flutter',
                debugShowCheckedModeBanner: false,
                onGenerateRoute: Application.router.generator,
                theme: ThemeData(primarySwatch: Colors.blue),
                home: IndexPage(),
              ),
            );
          },
        ));
  }
}
