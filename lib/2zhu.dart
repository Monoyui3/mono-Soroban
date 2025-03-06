import 'package:flutter/material.dart';
import 'package:fluttertest/soroban/ChuProvider.dart';
import 'package:fluttertest/soroban/kuaizhao.dart';
import 'package:fluttertest/soroban/stateProvider.dart';
import 'package:fluttertest/verticalBeam.dart';
import 'package:provider/provider.dart';
import './base-atos.dart';
class LinkedDraggableContainers2 extends StatefulWidget {
  kzArrayProvider kz;
  int horIndex;
  ChuProvider counterPro;
  double zzheight;
  double zzwidth;
  LinkedDraggableContainers2(this.zzheight , this.zzwidth, this.horIndex, this.counterPro, this.kz );
  @override
  _LinkedDraggableContainersState2 createState() => _LinkedDraggableContainersState2();
}

class _LinkedDraggableContainersState2 extends State<LinkedDraggableContainers2> {
  double zzheight = 0;
  List<double> initOffsets = [0,0];
  List<double> offsets = [0,0];
  @override
  void initState() {
    print("xixixixiixix");
    print(zzheight);

    _updateOffsets();
  }
  @override
  void didUpdateWidget(LinkedDraggableContainers2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.zzheight != widget.zzheight) {
      _updateOffsets();
    }
  }
  // _LinkedDraggableContainersState2(zzheight) {
  //   print("xixixixiixix");
  //   print(zzheight);
  //
  //   this.zzheight = zzheight;
  //   initOffsets[0] = zzheight;
  //   initOffsets[1] = zzheight*2;
  //   offsets[0] = zzheight;
  //   offsets[1] = zzheight*2;
  // }
  void _updateOffsets() {
    zzheight = widget.zzheight;
    print("zzzheight ${zzheight}");
    initOffsets[0] = zzheight;
    initOffsets[1] = zzheight * 2;
    offsets[0] = zzheight;
    offsets[1] = zzheight * 2;
    print("xixixixiixix");
    print(zzheight);
  }


  @override
  Widget build(BuildContext context) {
    print("2zhubuild");
    print(offsets);
    print(initOffsets);
    if(widget.counterPro.chu) {
      print("eee");
      for(int i =0; i < 2; i++) {
          offsets[i] = initOffsets[i];
      }
    }
    if(widget.kz.kzClick) {
      List<bool> kz = widget.kz.getUp(widget.horIndex);
      for(int i =0;i<2;i++) {
        offsets[i] = kz[i] == true? initOffsets[i]-zzheight: initOffsets[i];
      }
    }
    print(offsets);
    return Stack(
      children: [
        const VerticalBeam(),
        ...List.generate(offsets.length, (index) {
          return _buildDraggableContainer(index, Key('draggable_container_$index'));
        })
      ],

    );
  }

  Widget _buildDraggableContainer(int index, Key key) {
    return Selector<CountProvider, CountProvider>(
      selector: (ctx, provider) => provider,
      shouldRebuild: (pre, next) => false,
      builder: (ctx, counterPro, child) {
        print("hhhhh");
        print(offsets);
        return AnimatedPositioned(
          key: key,
          left: 0,
          bottom: offsets[index],
          duration: Duration(microseconds: 0),
          child:
          GestureDetector(
            onVerticalDragUpdate: (details) => _handleDrag(index, details.delta.dy),
            onVerticalDragEnd: (_) => _handleSnap(index, counterPro),
            child:  AbacusBead( width: widget.zzwidth, height: widget.zzheight),
          ),
        );
      },
    );
  }

  void _handleDrag(int index, double deltaY) {
    print(deltaY);
    print(offsets);
    setState(() {
      // 更新当前 Container 位置（限制在父容器范围内）
      double newOffset = (offsets[index] - deltaY).clamp(initOffsets[index]-zzheight,initOffsets[index]);
      offsets[index] = newOffset;

      // 强制后续所有 Container 跟随移动
      double newNextOffset = 0.0;
      if(deltaY > 0) {
        for(int i = index -1; i >= 0; i--) {
          if(offsets[i+1]- initOffsets[i+1] < offsets[i]-initOffsets[i]) {
            newNextOffset = offsets[i+1]-zzheight;
            offsets[i] = newNextOffset.clamp(initOffsets[i]-zzheight, initOffsets[i]);
          }
        }
        return;
      }
      for (int i = index + 1; i < offsets.length; i++) {
        if(offsets[i-1]-initOffsets[i-1] > offsets[i]-initOffsets[i]) {
          newNextOffset = offsets[i-1]+zzheight;
          offsets[i] = newNextOffset.clamp(initOffsets[i]-zzheight, initOffsets[i]);
        }
      }

    });
  }

  void _handleSnap(int index, CountProvider x) {
    setState(() {
      for(int i = 0; i < offsets.length; i++) {
        if(initOffsets[i]-offsets[i] > zzheight / 2) {
          offsets[i] = initOffsets[i] -zzheight;
          x.updateArrayValue(widget.horIndex, i+5, true);
        } else {
          offsets[i] = initOffsets[i];
          x.updateArrayValue(widget.horIndex, i+5, false);
        }
      }
    });
  }
}
