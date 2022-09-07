import 'package:flutter/material.dart';

import '../../../utils/SizeConfig.dart';
import 'MyCol.dart';
import 'Properties.dart';
import 'ScreenMedia.dart';

class MyRow extends StatelessWidget {
  final List<MyCol> children;
  final Color boxBorderColor;
  final WrapAlignment wrapAlignment;
  final WrapCrossAlignment wrapCrossAlignment;
  final Map<ScreenMediaType,int>? defaultFlex;
  final double spacing,runSpacing;


  const MyRow({Key? key, this.boxBorderColor = Colors.transparent, this.children = const [], this.wrapAlignment = WrapAlignment.start, this.defaultFlex = const {}, this.wrapCrossAlignment = WrapCrossAlignment.start, this.spacing = 0, this.runSpacing =10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        ScreenMediaType screenMediaType =
            ScreenMedia.getScreenMediaType(constraints.maxWidth);

        List<Widget> innerChildren = [];

        for(MyCol col in children){
          if(getDisplayValue(col.display)[screenMediaType]==DisplayType.Block) {
            innerChildren.add(Container(
              padding: Spacing.x(spacing??8),
              width: getWidthFromFlex(constraints.maxWidth,
                  getFlexValue(col.flex)[screenMediaType] ?? 0),
              child: col,
            ));
          }
        }
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: boxBorderColor)
          ),
          child: Wrap(
            crossAxisAlignment: wrapCrossAlignment??WrapCrossAlignment.start,
            alignment: wrapAlignment??WrapAlignment.start,
            runSpacing: runSpacing??16,
            children: innerChildren,
          ),
        );

      },
    );
  }

  double getWidthFromFlex(double width,int flex){
    return 4.1666666666 * width * flex /100;
  }

   Map<ScreenMediaType,int> getFlexValue(Map<ScreenMediaType,int>? flex){
     Map<ScreenMediaType,int>? flexValue = flex;
     if(flexValue==null) {
      Map<ScreenMediaType,int> flextemp =  {ScreenMediaType.XS:ScreenMedia.GRID_COLUMNS};
      flexValue = defaultFlex ?? flextemp;

    }
    if(flexValue[ScreenMediaType.XS] == null){
      Map<ScreenMediaType,int> flextemp =  defaultFlex ?? {};

      final newMap = Map.of(flexValue);
      newMap[ScreenMediaType.XS] = flextemp.isNotEmpty ? flextemp[ScreenMediaType.XS]??ScreenMedia.GRID_COLUMNS : ScreenMedia.GRID_COLUMNS;

      flexValue = newMap;
    }

    flexValue[ScreenMediaType.SM] = (flexValue[ScreenMediaType.SM]??flexValue[ScreenMediaType.XS])!;
    flexValue[ScreenMediaType.MD] = flexValue[ScreenMediaType.MD]??flexValue[ScreenMediaType.SM]!;
    flexValue[ScreenMediaType.LG] = flexValue[ScreenMediaType.LG]??flexValue[ScreenMediaType.MD]!;
    flexValue[ScreenMediaType.XL] = flexValue[ScreenMediaType.XL]??flexValue[ScreenMediaType.LG]!;
    flexValue[ScreenMediaType.XXL] = flexValue[ScreenMediaType.XXL]??flexValue[ScreenMediaType.XL]!;
    flexValue[ScreenMediaType.XXXL] = flexValue[ScreenMediaType.XXXL]??flexValue[ScreenMediaType.XXL]!;
    flexValue[ScreenMediaType.XXXXL] = flexValue[ScreenMediaType.XXXXL]??flexValue[ScreenMediaType.XXXL]!;

    return flexValue;
  }

  Map<ScreenMediaType,DisplayType> getDisplayValue(Map<ScreenMediaType,DisplayType>? display){
    print("errrorrrr ; ${display}");
    if(display == null){
      Map<ScreenMediaType,DisplayType> dispalyTemp = {ScreenMediaType.XS:DisplayType.Block};
      display = dispalyTemp;
    }
    print("errrorrrr ; ${display}");

    // display ??= {ScreenMediaType.XS:DisplayType.Block};
    if(display[ScreenMediaType.XS]==null) {
      display[ScreenMediaType.XS] = DisplayType.Block;
    }

    display[ScreenMediaType.SM] = display[ScreenMediaType.SM]??display[ScreenMediaType.XS]!;
    display[ScreenMediaType.MD] = display[ScreenMediaType.MD]??display[ScreenMediaType.SM]!;
    display[ScreenMediaType.LG] = display[ScreenMediaType.LG]??display[ScreenMediaType.MD]!;
    display[ScreenMediaType.XL] = display[ScreenMediaType.XL]??display[ScreenMediaType.LG]!;
    display[ScreenMediaType.XXL] = display[ScreenMediaType.XXL]??display[ScreenMediaType.XL]!;
    display[ScreenMediaType.XXXL] = display[ScreenMediaType.XXXL]??display[ScreenMediaType.XXL]!;
    display[ScreenMediaType.XXXXL] = display[ScreenMediaType.XXXXL]??display[ScreenMediaType.XXXL]!;



    return display;
  }
}


