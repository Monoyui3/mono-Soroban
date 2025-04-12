import 'package:flutter/material.dart';
import 'package:fluttertest/soroban/LoginProvider.dart';
import 'package:fluttertest/soroban/kuaizhao.dart';
import 'package:fluttertest/soroban/stateProvider.dart';
import 'package:fluttertest/util.dart';
import 'package:provider/provider.dart';

class reCodes extends StatefulWidget {
  @override
   State<StatefulWidget> createState() {
    // TODO: implement createState
    return reCodesState();
  }
}

class reCodesState extends State<reCodes> {
  bool canAdd(CountProvider counterPro) {
    bool res = true;
    for(int i =0; i<13;i++) {
      int wei = 0;
      for(int j=0;j<7;j++) {
        if(j<5) {
          wei +=  counterPro.array[i][j] ? 1 : 0;
        } else {
          wei +=  counterPro.array[i][j] ? 5 : 0;
        }
      }
      if(wei>=10) {
        res = false;
      }
    }
    return res;
  }
  String getValue(CountProvider counterPro) {
    String res = "";
    for(int i =0; i<13;i++) {
      int wei = 0;
      for(int j=0;j<7;j++) {
        if(j<5) {
          wei +=  counterPro.array[i][j] ? 1 : 0;
        } else {
          wei +=  counterPro.array[i][j] ? 5 : 0;
        }
      }
      res = res + wei.toString();
    }
    return res;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<CountProvider>(
        builder: (ctx, counterPro, child) {
          return Selector<kzArrayProvider, kzArrayProvider>(
              selector: (ctx, provider) => provider,
              shouldRebuild: (pre, next) => false,
              builder: (ctx, kzPro, cld) {
                return Stack(
                  children: [
                    Column(
                        children: [
                          ...List.generate(counterPro.values.length, (index) {
                            return  Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey,width: 1)
                                )
                              ),
                              child: ListTile(
                                leading: Text(
                                  index.toString()+".",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),
                                ),
                                tileColor: Colors.black12,
                                title:  Text(counterPro.values[index].replaceFirst(RegExp(r'^0+'), '')),
                                trailing: IconButton(
                                    onPressed: () async {
                                      await counterPro.deleteValuesAndKzArrayToSql(index, Provider.of<LoginProvider>(context, listen: false).token );
                                      counterPro.deleteValue(index);
                                    },
                                    icon: Icon(
                                        Icons.delete
                                    )),
                                onTap: () {
                                  counterPro.hositoryClicked(index);
                                  kzPro.setCurrentArray(counterPro.array);
                                },
                              ),
                            );
                          }),
                          Align(
                            alignment:  Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () async {
                                if(!canAdd(counterPro)) {
                                  Utils.showMessage(ctx, '注意进位');
                                  return;
                                }
                                String res = getValue(counterPro);
                                if(int.parse(res) == 0) return;
                                if(counterPro.values.length == 0 ||(counterPro.values.length > 0 && res != counterPro.values[counterPro.values.length -1])) {
                                  bool success = await counterPro.addValuesAndKzArrayToSql(Provider.of<LoginProvider>(context, listen: false).token, context, res);
                                  print("success::::$success");
                                  if(success) {
                                    setState(() {
                                      counterPro.values.add(res);
                                      counterPro.updateKzArrayValue();
                                    });
                                  }
                                }

                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                color: Colors.black26,
                                child:
                                const Icon(Icons.add),
                              ),
                            ) ,
                          ),
                          // Align(
                          //   alignment:  Alignment.centerRight,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       setState(() {
                          //         counterPro.values.add(getValue(counterPro));
                          //       });
                          //     },
                          //     child: Container(
                          //       width: 50,
                          //       height: 50,
                          //       color: Colors.black26,
                          //       child:
                          //       const Icon(Icons.add),
                          //     ),
                          //   ) ,
                          // )
                        ]
                    ),

                  ],
                );
              }
          );
        }
    );
  }
}