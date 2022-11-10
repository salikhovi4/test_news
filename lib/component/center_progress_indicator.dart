
import 'package:flutter/material.dart';

class CenterProgressIndicator extends StatelessWidget {
  const CenterProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
