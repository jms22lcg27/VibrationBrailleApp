import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'braille.dart';

class CameraExample extends StatefulWidget {
  const CameraExample({Key? key}) : super(key: key);

  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  File? _image;
  final picker = ImagePicker();
  String parsedtext = '';

  //--------------------------------------------------
  Future<bool> _getStatuses() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage, Permission.camera].request();

    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }
  //-------------------------------------------------

  // 갤러리에서 이미지를 가져오기
  Future getImage(ImageSource imageSource) async {
    await _getStatuses();
    final image = await picker.pickImage(source: imageSource);
    if (image == null) return;

    setState(() {
      _image = File(image.path);
    });

    //OCR API를 사용하기위해 파일 변환
    var bytes = File(image.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    //OCR API 사용
    var url = 'https://api.ocr.space/parse/image';
    var payload = {
      "base64Image": "data:image/jpg;base64,${img64.toString()}",
      "language": "kor"
    };
    var header = {"apikey": "KEY"};

    var post = await http.post(Uri.parse(url), body: payload, headers: header);
    var result = jsonDecode(post.body);
    // 추출된 텍스트 가져오기
    setState(() {
      parsedtext = result['ParsedResults'][0]['ParsedText'];
    });
    //진동 함수 호출
    vibration(parsedtext);
  }

  //----------------------------

  //진동 나타내기
  Future vibration(String parsedtext) async {
    Vibration.vibrate(pattern: Braille(parsedtext.trim()));
  }

  //-----------------------------

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('이미지를 선택해 주세요 :)')
                : Image.file(File(_image!.path))));
  }

  @override
  Widget build(BuildContext context) {
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        backgroundColor: const Color(0xfff4f3f9),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 25.0),
            showImage(),
            SizedBox(
              height: 50.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // 갤러리에서 이미지를 가져오는 버튼
                FloatingActionButton(
                  child: Icon(Icons.wallpaper),
                  tooltip: 'pick Iamge',
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            //텍스트 상자
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color.fromARGB(255, 245, 233, 168),
                ),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(50),
                child: Center(child: Text(parsedtext.trim()))),
          ],
        ));
  }
}
