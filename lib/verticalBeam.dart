import 'package:flutter/material.dart';

// 单独的竖梁组件
class VerticalBeam extends StatelessWidget {
  const VerticalBeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Center(
        child: Container(
          width: 5,
          color: Colors.brown, // 竖梁颜色，可根据需要修改
        ),
      ),
    );
  }
}
