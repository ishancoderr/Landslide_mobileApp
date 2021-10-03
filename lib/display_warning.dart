import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';


late final double predValue;
class displaywarning extends StatefulWidget {
  final predValue;


  const displaywarning({Key? key, required  this.predValue}) : super(key: key);

  @override
  _displaywarningState createState() => _displaywarningState();
}

class _displaywarningState extends State<displaywarning> {
  late MapShapeSource _shapeSource;
  late List<MapModel> _mapData;
  late double risk;
  late double finalprob;
  late String riskclass="Moderate Risk";

  applycondition() {

    if(riskclass=="High Risk"){
      finalprob=double.parse(widget.predValue)*0.9*100;
    }else if(riskclass=="Moderate Risk"){
      finalprob= double.parse(widget.predValue)*0.7*100;
    }else if(riskclass=="Low Risk"){
      finalprob=double.parse(widget.predValue)*0.6*100;

    }else if(riskclass=="Very Low Risk"){
      finalprob= double.parse(widget.predValue)*0.3*100;

    }


  }

  @override
  void initState() {
    _mapData=_getMapData();

    _shapeSource =MapShapeSource.asset('assets/Inventory.json',shapeDataField: 'value'
    ,dataCount: _mapData.length,
    primaryValueMapper: (int index)=>_mapData[index].state,
    dataLabelMapper:(int index)=>_mapData[index].stateCode,
      shapeColorValueMapper:(int index)=>_mapData[index].color,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(children: <Widget>[
        Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text('Your Risk Condition',style: TextStyle(color: Colors.black87,fontSize: 25,fontWeight: FontWeight.bold),
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child:TextButton.icon(
              icon: Icon(Icons.alarm_on),

              label:Text('Click Me To Calculate Your Risk'),
              onPressed: (){
                applycondition();
                showDialog(
                  context: context,
                  builder:(context){
                    return AlertDialog(
                      content: Text('Acording to your entered Rainfall data and your positining data , you are in '
                          '$finalprob%  Risk position',style: TextStyle(color: Colors.blueAccent ,fontSize: 25,fontWeight: FontWeight.bold)),

                    );
                  }
                  );

              },





            )



        ),



        Expanded(
          child:Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
          child: SfMaps(
            layers: [MapShapeLayer(
                source: _shapeSource,
              showDataLabels: true,
                legend: MapLegend(MapElement.shape),



                markerBuilder:(BuildContext context,int index) {
                   return MapMarker(
                      longitude: 81.0557,
                      latitude: 6.9895,
             );
           }
            ),



            ],

          ),


        ),
        )
      ],)
    );
  }
  static List<MapModel> _getMapData(){
    return <MapModel>[
      MapModel('High Risk', 'High Risk '
          ''  , Colors.purple),
      MapModel('Moderate Risk', 'Moderate Risk'  , Colors.deepOrange),
      MapModel('Low Risk', 'Low Risk'  , Colors.yellow),
      MapModel('Very Low Risk', 'Very Low Risk'  , Colors.green),

    ];
  }


}


class MapModel{
  MapModel(this.state,this.stateCode,this.color);
  String state;
  String stateCode;
  Color color;
}