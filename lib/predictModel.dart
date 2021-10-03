import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'display_warning.dart';

class PredModel extends StatefulWidget {
  @override
  _PredModelState createState() => _PredModelState();
}

class _PredModelState extends State<PredModel> {

  var predValue = "";
  double intensity=0.0;
  int hours=0;
  int miniutes=0;
  double totaltime=0.0;
  var lat=0.00;
  var lon=0.00;
  //late String valueChoose;
  final RainCondition = [
    "Very Light Rainfall (0.1 to 2.4 mm)",
    "Light Rainfall (2.5 to 15.5 mm)",
    "Moderate (15.6 to 64.4 mm)",
    "Heavy Rainfall (64.5 to 115.5 mm)",
    "Very Heavy Rainfall (115.6 to 204.4 mm)",
    "Extreamly Heavy Rainfall (>204 mm )",

  ];


  var locationMessage = "";

  String? value;

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    var lastPosition = await Geolocator.getLastKnownPosition();
     lat = position.latitude;
     lon = position.longitude ;
    setState(() {
      locationMessage = "Latitude : $lat ,Longitude : $lon";
    });
  }

  @override
  void initState() {
    super.initState();
    //predValue = "click predict button";
  }

  Future<void> predData() async {
    final interpreter = await Interpreter.fromAsset('tf_lite_model.tflite');
    totaltime=hours+miniutes*(1/60);
    print(intensity);
    print(totaltime);
    var input = [

      [totaltime*intensity, totaltime,intensity ]
    ];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    print(output[0][0]);

    this.setState(() {
      predValue = output[0][0].toString();
    });
  }

  

  Widget build(BuildContext context) {
    return Scaffold(
    resizeToAvoidBottomInset:false ,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 46,
                color: Colors.blue,

              ),
              SizedBox(height: 10,),
              Text("Get your Location",
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text(locationMessage),
              FlatButton(

                onPressed: () {
                  getCurrentLocation();
                }
                ,
                color: Colors.black,
               // height: 30,

                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                child: Text(
                  "Press For Get Location", style: TextStyle(color: Colors.white),),

              ),
              SizedBox(height: 10,),
              Container(
                width: 500,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black,width:4),
                  borderRadius: BorderRadius.circular(12),

                ),
                child:DropdownButtonHideUnderline(
                child: DropdownButton<String>(

                  value: value,
                  isExpanded: true,
                  iconSize: 36,
                  icon: Icon(Icons.arrow_drop_down_circle_rounded),
                  items: RainCondition.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() {
                    this.value = value;
                  print(value);
                  randomGenarator( value!);
                  }),
                  hint: Text("Select Rain Intensity (mm/hr)",style:TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold,fontSize: 22.0,)),
                ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0,
                ),
                child: Form(child:Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        autovalidate: true,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Hours can not be Empty';


                          }else if(value.length<=2){
                            hours=int.parse(value);
                            //print(hours);

                          }
                          return null;

                        },
                        decoration: InputDecoration(
                          labelText: 'Enter Rain hours (hr) ',
                          hintText: 'Input as integer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(

                        autovalidate: true,
                        validator: (value){
                          if(value!.isEmpty){
                            return 'minutes can not be Empty';


                          }else if(value.length<=2){
                            miniutes=int.parse(value);
                           // print(miniutes);

                          }
                          return null;

                        },
                        decoration: InputDecoration(
                          labelText: 'Enter Rain miniutes (min) ',
                          hintText: 'Input as integer ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              Container(
                child:IconButton(
                  iconSize: 60,
                  onPressed: () {
                    if( intensity>0.0&& hours>0 && miniutes>0 && lat>0) {
                      predData();
                      //print(predValue);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            displaywarning(predValue: predValue)),);
                    }else{
                      showDialog(
                          context: context,
                          builder:(context){
                            return AlertDialog(
                              content: Text('Please Give All Data '
                                  ,style: TextStyle(color: Colors.blueAccent ,fontSize: 25,fontWeight: FontWeight.bold)),

                            );
                          }


                      );
                    }

                  },
                  icon: Icon(Icons.arrow_forward),
                  color: Colors.blue,


                )
              ),
            ],
          )

      ),
    );


  }
  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );

  void randomGenarator( String val) {

    if (val=="Very Light Rainfall (0.1 to 2.4 mm)"){
      intensity=1.0;

    }else if(val=="Light Rainfall (2.5 to 15.5 mm)"){
      intensity=6.5;
      print(num);
    }else if(val=="Moderate (15.6 to 64.4 mm)"){
      intensity=48.8;
    }
    else if(val=="Heavy Rainfall (64.5 to 115.5 mm)"){
      intensity=90.0;

    }
    else if(val=="Very Heavy Rainfall (115.6 to 204.4 mm)"){
      intensity=159.9;

    }else{
      intensity=220.0;
    }

  }

}
