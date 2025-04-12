import 'package:flutter/material.dart';
import 'package:fluttertest/soroban/ChuProvider.dart';
import 'package:fluttertest/soroban/kuaizhao.dart';
import 'package:fluttertest/soroban/stateProvider.dart';
import 'package:fluttertest/value.dart';
import 'package:fluttertest/verticalBeam.dart';
import 'package:provider/provider.dart';
import './base-atos.dart';
class LinkedDraggableContainers extends StatefulWidget {
  kzArrayProvider kz;
  final int horIndex;
  ChuProvider counterPro;
  double zzheight;
  double zzwidth;
  LinkedDraggableContainers(this.zzheight , this.zzwidth, this.horIndex, this.counterPro,this.kz );
  @override
  _LinkedDraggableContainersState createState() => _LinkedDraggableContainersState();
}

class _LinkedDraggableContainersState extends State<LinkedDraggableContainers> {
  double zzheight = 0;
  List<double> initOffsets = [0,0,0,0,0];
  List<double> offsets = [0,0,0,0,0];
  @override
  void initState() {
    _updateOffsets();
  }
  @override
  void didUpdateWidget(LinkedDraggableContainers oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.zzheight != widget.zzheight) {
      _updateOffsets();
    }
  }

  void _updateOffsets() {
    zzheight = widget.zzheight;
    for(int i =1; i< 5;i++) {
      initOffsets[i] = initOffsets[i-1]+zzheight;
      offsets[i] = offsets[i-1]+zzheight;
    }
  }

  @override
  Widget build(BuildContext context) {

    if(widget.counterPro.chu) {
      for(int i =0; i < 5; i++) {

          offsets[i] = initOffsets[i];

      }
    }
    if(widget.counterPro.chu && widget.horIndex == 12) {

      widget.counterPro.chu = false;
    }
    if(widget.kz.kzClick) {
      List<bool> kz = widget.kz.getDown(widget.horIndex);
      for(int i =0;i<5;i++) {
        offsets[i] = kz[i] ==true ? initOffsets[i]+zzheight: initOffsets[i];
      }
    }
    if(widget.kz.kzClick && widget.horIndex == 12) {
      widget.kz.kzClick = false;
    }

    return Stack(
          children: [
            const VerticalBeam(),
            ...List.generate(offsets.length, (index) {
              return _buildDraggableContainer(index, Key('draggable_container_$index'));
            }),
          ],
        );
  }

  Widget _buildDraggableContainer(int index, Key key) {
    return Selector<CountProvider, CountProvider>(
      selector: (ctx, provider) => provider,
      shouldRebuild: (pre, next) => false,
      builder: (ctx, counterPro, child) {
        return AnimatedPositioned(
          key: key,
            left: 0,
            bottom: offsets[index],
            duration: Duration(microseconds: 0),
          child:
          GestureDetector(
            onVerticalDragUpdate: (details) => _handleDrag(index, details.delta.dy),
            onVerticalDragEnd: (_) => _handleSnap(index, counterPro),
              child:  AbacusBead(width: widget.zzwidth, height: widget.zzheight),
            ),
          );
      },
    );
  }

  void _handleDrag(int index, double deltaY) {
    setState(() {
      // 更新当前 Container 位置（限制在父容器范围内）
      double newOffset = (offsets[index] - deltaY).clamp(initOffsets[index],initOffsets[index]+zzheight);
     offsets[index] = newOffset;

      // 强制后续所有 Container 跟随移动
      double newNextOffset = 0.0;
      if(deltaY > 0) {
        for(int i = index -1; i >= 0; i--) {
          if(offsets[i+1]- initOffsets[i+1] < offsets[i]-initOffsets[i]) {
            newNextOffset = offsets[i+1]-zzheight;
            offsets[i] = newNextOffset.clamp(initOffsets[i], initOffsets[i]+zzheight);
          }
        }
        return;
      }
      for (int i = index + 1; i < offsets.length; i++) {
        if(offsets[i-1]-initOffsets[i-1] > offsets[i]-initOffsets[i]) {
          newNextOffset = offsets[i-1]+zzheight;
          offsets[i] = newNextOffset.clamp(initOffsets[i],initOffsets[i]+zzheight);
        }
      }

    });
  }

void _handleSnap(int index, CountProvider x) {
  setState(() {
    for(int i = 0; i < offsets.length; i++) {
      if(offsets[i]-initOffsets[i] > zzheight / 2) {
        offsets[i] = initOffsets[i] +zzheight;
        x.updateArrayValue(widget.horIndex, i, true);
      } else {
        offsets[i] = initOffsets[i];
        x.updateArrayValue(widget.horIndex, i, false);
      }
    }
  });
}
}
