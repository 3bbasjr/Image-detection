import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/main.dart';
import 'package:tflite/tflite.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage>
{
  bool isWorking = false;
  String result = '';
  CameraController? cameraController;
  CameraImage? imgCamera;

    loadModel()
    async{
      await Tflite.loadModel(
        labels: 'assets/mobilenet_v1_1.0_224.txt',
        model: 'assets/mobilenet_v1_1.0_224.tflite',
      );
    }
    initCamera(){
      cameraController= CameraController(cameras![0],ResolutionPreset.medium );
      cameraController?.initialize().then((value) {
        if(!mounted)
          {
            return;
          }
        setState(() {
          cameraController?.startImageStream((imageFromStream) =>
          {
          if(!isWorking){
            isWorking = true,
            imgCamera = imageFromStream,
            runModelonStreamFrames(),
          }
          });
        });
      });
    }
  runModelonStreamFrames() async{
      if(imgCamera != null){
        var recognitions = await Tflite.runModelOnFrame(
            bytesList: imgCamera!.planes.map((plane)
            {
          return plane.bytes;
        }).toList(),
          imageHeight: imgCamera!.height,
          imageWidth: imgCamera!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true
        );
        result = '';
        recognitions?.forEach((response)
        {
          result += response["label"] + "   " + (response["confidence"] as double).toStringAsFixed(2) + "\n\n";
        });
        setState(() {
          result;
        });
        isWorking = false;
      }
  }

    @override
  void initState() {
    super.initState();
    loadModel();
  }
  @override
  void dispose() async{
    super.dispose();
    await Tflite.close();
    cameraController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/jarvis.jpg'))
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          color: Colors.black,
                          height: 320,
                          width: 360,
                          child: Image.asset('assets/camera.jpg'),
                        ),
                      ),
                      Center(
                        child: TextButton(
                            onPressed: (){
                              initCamera();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 35),
                              height: 270,
                              width: 360,
                              child: imgCamera == null
                                  ? Container(
                                height: 270,
                                width: 360,
                                child: Icon(Icons.photo_camera_rounded, color: Colors.blueAccent,size: 40,),
                              ) :AspectRatio(
                                aspectRatio: cameraController!.value.aspectRatio,
                                child: CameraPreview(cameraController!),

                              ) ,
                            )),
                      )
                    ],
                  ),

                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 55),
                      child: SingleChildScrollView(
                        child: Text(result,
                        style: TextStyle(
                          backgroundColor: Colors.black,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
