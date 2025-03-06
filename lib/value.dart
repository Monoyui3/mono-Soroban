import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './soroban/stateProvider.dart';

class ValueWidget extends StatelessWidget {

  const ValueWidget({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("positon build nononono");
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double zzheight = constraints.maxHeight;
        double zzwidth = (constraints.maxWidth) / 13;
        return Row(
            children: List.generate(13, (horIndex) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                        color: Colors.brown,
                        width: 1,
                      ),
                      right: BorderSide(
                        color: Colors.brown,
                        width: 1,
                      )
                  ),
                  color: Color.fromRGBO(3, 3, 255, 0.1),
                ),
                width: zzwidth,
                height: zzheight,
                child: Center(
                  child: Consumer<CountProvider>(
                    builder: (ctx, couterPro, child) {
                      double res = 0;
                      for(int i =0;i <5;i++) {
                        res += (couterPro.array[horIndex][i] == true ? 1 : 0);
                      }
                      for(int i = 5;i<7;i++) {
                        res += (couterPro.array[horIndex][i] == true ? 5 : 0);
                      }
                      return Text(res.toInt().toString());
                    },
                  ),
                ),
              );
            })
        );
      },
    );
      
  }
}
