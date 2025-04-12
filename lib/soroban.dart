// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertest/soroban/kuaizhao.dart';
import 'package:fluttertest/soroban/stateProvider.dart';
import 'package:provider/provider.dart';
import '2zhu.dart';
import '5zhu.dart';
import 'soroban/ChuProvider.dart';
import 'base-atos.dart';
class AbacusApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AbacusAppState();
  }
}
class AbacusAppState extends State<AbacusApp> {
  final keyArr = [];
  final GlobalKey _firstExpandedKey = GlobalKey();
  final GlobalKey _secondExpandedKey = GlobalKey();
  double? zzheight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (mounted) {
        setState(() {
          if (_firstExpandedKey.currentContext != null) {
            final renderObject = _firstExpandedKey.currentContext!.findRenderObject();
            if (renderObject is RenderObject) {
              renderObject.markNeedsLayout();
            }
          }
          if (_secondExpandedKey.currentContext != null) {
            final renderObject = _secondExpandedKey.currentContext!.findRenderObject();
            if (renderObject is RenderObject) {
              renderObject.markNeedsLayout();
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.brown,
            width: 10,
          ),
          right: BorderSide(
            color: Colors.brown,
            width: 10,
          )
        ),
        color: Color.fromRGBO(3, 3, 255, 0.1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 10,
            width: double.infinity,
            color: Colors.brown, // 可以根据需要修改颜色
          ),
          Expanded(
            key: _firstExpandedKey,
            flex: 1,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                zzheight = constraints.maxHeight / 3;
                double zzwidth = constraints.maxWidth / 13;
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  color: Colors.grey[200],
                  child: Consumer<ChuProvider>(
                      builder: (ctx, counterPro, child) {
                        return Consumer<kzArrayProvider>(
                          builder: (ctx,kz,zk) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(13, (horIndex) {
                                return Container(
                                  key: Key('2zhu_${horIndex}'),
                                  width: zzwidth,
                                  height: constraints.maxHeight,
                                  child: LinkedDraggableContainers2(zzheight!, zzwidth, horIndex,counterPro, kz),
                                );
                              }),
                            );
                          },
                        );
                      }
                  ),
                );
              },
            ),
          ),
          Container(
            height: 10,
            width: double.infinity,
            color: Colors.brown, // 可以根据需要修改颜色
          ),
          Expanded(
            key: _secondExpandedKey,
            flex: 2,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double zzheight = constraints.maxHeight / 6;
                double zzwidth = constraints.maxWidth / 13;
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  color: Colors.grey[200],
                  child: Consumer<ChuProvider>(
                    builder: (ctx, counterPro, child) {
                      return Consumer<kzArrayProvider>(
                        builder: (ctx,kz,zk) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(13, (horIndex) {
                              return Container(
                                key: Key('5zhu_${horIndex}'),
                                width: zzwidth,
                                height: constraints.maxHeight,
                                child: LinkedDraggableContainers(zzheight, zzwidth, horIndex,counterPro,kz),
                              );
                            }),
                          );
                        },
                      );
                    }
                  ),
                );
              },
            ),
          ),
          Container(
            height: 10,
            width: double.infinity,
            color: Colors.brown, // 可以根据需要修改颜色
          ),
        ],
      )

    );
  }
}

class buildGridCoutainer extends StatelessWidget {
  final int rows;
  final int columns;
  final int itemCount;
  buildGridCoutainer(this.rows,this.columns,this.itemCount);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const spacing = 1.0;
          final childWidth = (constraints.maxWidth - (columns-1)*spacing)/columns;
          final childHeight = (constraints.maxHeight - (rows-1)*spacing)/rows;
          return GridView.count(
            crossAxisCount: columns,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: childWidth / childHeight,
            children: List.generate((itemCount-13), (index) =>
                DraggableContainer(childWidth, childHeight)),
          );
        },
      ),
    );
  }
}

//算珠Container
// class atos extends StatelessWidget {
//   final int index;
//   atos(this.index);
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return
//       Container(
//         key: Key('atos-${index}'),
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           border: Border.all(
//             color: Colors.grey,
//             width: 1,
//             style: BorderStyle.solid,
//           ),
//             borderRadius: BorderRadius.circular(4)
//         ),
//       );
//
//   }
// }
// //算珠
// class abac extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return abacState()
//   }
// }
// class abacState extends State<abac> {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Container()
//   }
// }
class DraggableContainer extends StatefulWidget {
  final double width;
  final double height;
  DraggableContainer(this.width, this.height);
  @override
  _DraggableContainerState createState() => _DraggableContainerState(width: this.width,height: this.height);
}

class _DraggableContainerState extends State<DraggableContainer> {
  final double width;
  final double height;
  _DraggableContainerState({this.width=100.0, this.height=100.0});
  double offsetY = 0.0;      // 当前垂直偏移量
  double midPoint = 100 / 2;
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Positioned(
            top: offsetY.clamp(0.0, height),
            child: GestureDetector(
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  // 累加垂直方向的位移
                  offsetY = (offsetY+details.delta.dy).clamp(0.0,height);
                });
              },
              onVerticalDragEnd: (DragEndDetails details) {
                setState(() {
                  // 根据当前位置决定归位方向
                  offsetY = offsetY < midPoint ? 0.0 : height;
                });
              },
              // child: Container(
              //   // duration: Duration(milliseconds: 300),
              //   // curve: Curves.easeOut,
              //   // transform: Matrix4.translationValues(0, offsetY, 0),
              //   width: width,
              //   height: height,
              //   color: Colors.blue,
              //   child: AbacusBead(width,height, Colors.red, Colors.blue,),
              // ),
            ),
          )


        ],
      );
  }
}





