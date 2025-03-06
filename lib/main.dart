import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/soroban/kuaizhao.dart';
import 'package:provider/provider.dart';
import 'soroban.dart';
import './value.dart';
import './soroban/stateProvider.dart';
import 'soroban/ChuProvider.dart';
import 'jilvs.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => CountProvider()),
      ChangeNotifierProvider(create: (ctx) => ChuProvider()),
      ChangeNotifierProvider(create: (ctx) => kzArrayProvider()),
    ],
    child: MaterialApp(
      home: Builder(
        builder: (context){
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: AppBar(),
            ),
            body: Stack(
              children: [
                Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: AbacusApp(),
                    )
                ),
                Builder(
                  builder:  (innerContext){
                    return Positioned(
                      left: -10,
                      child: IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(innerContext).openEndDrawer();
                        },
                      ),
                    );
                  },
                )
              ],
            ),
            endDrawer: Drawer(
              child: Column(
                children: [
                  Container(
                    height: 50, // 设置高度
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                    ),
                    child: const Center(
                      child: Text('历史记录'),
                    ),
                  ),
                  Expanded(
                    // child: reCodes(),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        reCodes(),
                      ],
                    ),
                  )
                ]

              ),
            ),

            bottomNavigationBar: Container(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              height: 25,
              child: const ValueWidget(),
            ),
            floatingActionButton: Stack(
              children: [
                Positioned(
                  width: 30,
                  height: 30,
                  bottom: 10,
                  left: 15,
                  child: Selector<ChuProvider, ChuProvider>(
                    selector: (ctx,provider) => provider,
                    shouldRebuild: (pre,next) => false,
                    builder: (ctx, counterPro, child) {
                      return Selector<CountProvider, CountProvider>(
                        selector: (ctx,provider) => provider,
                        shouldRebuild: (pre,next) => false,
                        builder: (ctx, x, c){
                          return FloatingActionButton(

                            child: child,
                            onPressed: () {
                              x.setOffsetsArray();
                              counterPro.setChu();
                            },
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),

          );
        },
      ),
    ),
  ));
}