import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppy/widgets/Custom_action_bar.dart';

class SavedTab extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      child: Stack(
        children : [
          Center(
            child: Text(" Saved Tab"),
        ),
        CustomActionBar(
          title: "Saved",
          hasBackArrow: false,
         
        ),
        ]
      )
    );
  }

}