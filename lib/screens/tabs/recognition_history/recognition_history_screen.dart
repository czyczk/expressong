import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:provider/provider.dart';

import '../../../providers/recognition_records_impl.dart';
import '../../../providers/emotion_detector_impl.dart';
import '../../../providers/stub/dummy_recognition_records.dart';
import '../../../providers/stub/dummy_emotion_detector.dart';
import '../../../models/recognition_record.dart';
import '../widgets/recognition_record_item.dart';
import '../../recognition_result/recognition_result_screen.dart';

class RecognitionHistoryScreen extends StatelessWidget {
  Future<void> _takePictureAndDetectEmotion(BuildContext context) async {
    var imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 100,
      maxHeight: 100,
    );

    if (imageFile == null) return;

    imageFile =
        await FlutterExifRotation.rotateAndSaveImage(path: imageFile.path);

    // Show busy indicator
    showDialog(
      context: context,
      child: AlertDialog(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('照片正在上传和检测')]),
        content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[CircularProgressIndicator()]),
      ),
    );

    // Determine an emotion
    final base64Encoded = base64Encode(imageFile.readAsBytesSync());
    final detectionResult =
        await Provider.of<EmotionDetectorImpl>(context, listen: false)
            .determineEmotion(base64Encoded);
    Navigator.of(context).pop();

    // TODO: Error handling

    // Show the result screen
    Navigator.of(context).pushNamed(RecognitionResultScreen.routeName,
        arguments: detectionResult);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          child: Container(
            width: double.infinity,
            height: 120,
            child: Icon(
              Icons.camera_alt,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onTap: () {
            _takePictureAndDetectEmotion(context);
          },
        ),
        Divider(
          height: 0,
        ),
        FutureBuilder<void>(
          future: Provider.of<RecognitionRecordsImpl>(context, listen: false)
              .loadRecognitionRecords(),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 32,
                        ),
                        CircularProgressIndicator(),
                      ],
                    )
                  : Consumer<RecognitionRecordsImpl>(
                      builder: (ctx, recognitionRecordsProvider, child) {
                        final recognitionRecords =
                            recognitionRecordsProvider.recognitionRecords;
                        return recognitionRecords.length > 0
                            ? Expanded(
                                child: ListView.separated(
                                    itemBuilder: (ctx, index) {
                                      return RecognitionRecordItem(
                                        recognitionRecords[index],
                                        isDeletable: true,
                                      );
                                    },
                                    separatorBuilder: (ctx, index) =>
                                        Divider(height: 0),
                                    itemCount: recognitionRecords.length),
                              )
                            : child;
                      },
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 32,
                          ),
                          child: const Text(
                            '暂无历史数据',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}
