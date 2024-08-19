import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigator_2/product_page.dart';

class RouteModel {
  String path;
  //just a example, Uri is way more better than this
  String? subPath;

  RouteModel({required this.path});
}

// route information parser
class MyRouteParser extends RouteInformationParser<RouteModel> {
  @override
  Future<RouteModel> parseRouteInformation(RouteInformation routeInformation) {
    //parse subPath from routeInformation.uri ?
    return SynchronousFuture(RouteModel(path: routeInformation.uri.toString()));
  }

  @override
  RouteInformation? restoreRouteInformation(RouteModel configuration) {
    //Uri.parse(configuration.path + '/' + configuration.subPath)
    return RouteInformation(uri: Uri.parse(configuration.path));
  }
}

// router delegate
class MyRouterDelegate extends RouterDelegate<RouteModel>
    with PopNavigatorRouterDelegateMixin<RouteModel>, ChangeNotifier {
  static MyRouterDelegate of(BuildContext context) {
    final deledate = Router.of(context).routerDelegate;
    // assert
    return deledate as MyRouterDelegate;
  }

  // 可以通过仅保存必要的页面信息，来优化存在需要往栈中打开大量页面导致OOM的情况
  // 【【Flutter直播回放】用Navigator 2.0解决极限路由情况】 https://www.bilibili.com/video/BV1uP411w7j2/
  List<RouteModel> routeDataStack = [RouteModel(path: "Home")];

  // https://github.com/MeandNi/flutter_navigator_v2/blob/master/lib/router_example.dart#L16
  // 会在哪里用到呢？
  // final RouteFactory onGenerateRoute;

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  @override
  // 系统通过 routeNameProvider 发出打开新路由页面的通知时，直接调用 setNewRoutePath() 方法，参数就是由 routeNameParser 解析的结果。
  Future<void> setNewRoutePath(RouteModel configuration) async {
    return;
  }

  push(String routeData) {
    routeDataStack.add(RouteModel(path: routeData));
    notifyListeners();
    _printStack();
  }

  _printStack() {
    print(routeDataStack
        .map(
          (e) => e.path,
        )
        .toList());
  }

  List<Page> _getPage() {
    List<Page> pages = routeDataStack
        .map((data) => MaterialPage(

            /// This key will be used for comparing pages in [canUpdate].
            key: ValueKey(data.path),
            child: ProductPage(
              path: data.path,
            )))
        .toList();
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _getPage(),
      onPopPage: (route, result) {
        //don't pop home page?
        // routeDataStack 只有一个元素的时候，就没有返回按钮了，挺好的
        routeDataStack.removeLast();
        notifyListeners();
        _printStack();
        return route.didPop(result);
      },
    );
  }
}
