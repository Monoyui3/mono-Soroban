import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './soroban/stateProvider.dart';

class ValueWidget extends StatelessWidget {

  const ValueWidget({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double zzheight = constraints.maxHeight;
        double zzwidth = (constraints.maxWidth) / 13;
        return Row(
            children: List.generate(13, (horIndex) {
              final containerKey = GlobalKey();
              return Consumer<CountProvider>(
                builder: (ctx, couterPro, child) {
                  double res = 0;
                  for (int i = 0; i < 5; i++) {
                    res += (couterPro.array[horIndex][i] == true ? 1 : 0);
                  }
                  for (int i = 5; i < 7; i++) {
                    res += (couterPro.array[horIndex][i] == true ? 5 : 0);
                  }

                  // 根据 res 的值动态设置颜色
                  Color containerColor = res >= 10 ? Colors.red : Color.fromRGBO(3, 3, 255, 0.1);

                  return Builder(
                    builder: (containerContext) {
                      return GestureDetector(
                        onTap: () {
                          final renderBox = containerContext.findRenderObject() as RenderBox;
                          final position = renderBox.localToGlobal(Offset.zero);
                          if(res >= 10) {
                            _showHintOverlay(context, position, zzwidth, res);
                          }
                        },
                        child: Container(
                          key: containerKey,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.brown,
                                width: 1,
                              ),
                              right: BorderSide(
                                color: Colors.brown,
                                width: 1,
                              ),
                            ),
                            color: containerColor,
                          ),
                          width: zzwidth,
                          height: zzheight,
                          child: Center(
                            child: Text(res.toInt().toString()),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
              // return Container(
              //   decoration: BoxDecoration(
              //     border: Border(
              //         left: BorderSide(
              //           color: Colors.brown,
              //           width: 1,
              //         ),
              //         right: BorderSide(
              //           color: Colors.brown,
              //           width: 1,
              //         )
              //     ),
              //     color: Color.fromRGBO(3, 3, 255, 0.1),
              //   ),
              //   width: zzwidth,
              //   height: zzheight,
              //   child: Center(
              //     child: Consumer<CountProvider>(
              //       builder: (ctx, couterPro, child) {
              //         double res = 0;
              //         for(int i =0;i <5;i++) {
              //           res += (couterPro.array[horIndex][i] == true ? 1 : 0);
              //         }
              //         for(int i = 5;i<7;i++) {
              //           res += (couterPro.array[horIndex][i] == true ? 5 : 0);
              //         }
              //         return Text(res.toInt().toString());
              //       },
              //     ),
              //   ),
              // );
            })
        );
      },
    );
      
  }
  void _showHintOverlay(
      BuildContext context,
      Offset position,
      double width,
      double res,
      ) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + width/2 - 40, // 居中显示
        top: position.dy - 40, // 显示在上方
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius:  BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "注意进位",
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ),
        ),
      ),
    );

    // 添加Overlay并延迟移除
    Overlay.of(context)?.insert(overlayEntry);
    Future.delayed(Duration(seconds: 1), () => overlayEntry.remove());
  }
}
