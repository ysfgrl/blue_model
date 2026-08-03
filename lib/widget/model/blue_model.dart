import 'package:blue_model/blue_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'types.dart';
class BlueModel<MType extends BaseModel> extends StatelessWidget {
  final ModelBloc<MType> bloc;
  final Widget loadingWidget;
  // final ModelErrorBuilder errorBuilder;
  const BlueModel({
    super.key,
    required this.bloc,
    this.loadingWidget = const Center(child: CircularProgressIndicator(),),
  });

  @override
  Widget build(BuildContext context) {
    return Center();
  }



}