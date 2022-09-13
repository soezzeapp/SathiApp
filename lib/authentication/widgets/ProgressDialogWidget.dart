import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDialogWidget extends StatefulWidget {
  const ProgressDialogWidget({Key? key}) : super(key: key);

  @override
  _ProgressDialogWidgetState createState() => _ProgressDialogWidgetState();
}

class _ProgressDialogWidgetState extends State<ProgressDialogWidget> {
  late Subscription subscription;
  double? progress;
  @override void initState() {
    super.initState();
    subscription = VideoCompress.compressProgress$
    .subscribe((progress)=>
        setState(()=>this.progress = progress)
    );
  }

  @override
  void dispose() {
    VideoCompress.cancelCompression();
    subscription.unsubscribe;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final value = progress ==null?progress:progress!/100;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Compressing Video',
            style:TextStyle(fontSize: 20)
        ),
        SizedBox(height:20),
        LinearProgressIndicator(
          value: value,
          minHeight: 12,
        ),
        ElevatedButton(
            onPressed: ()=>VideoCompress.cancelCompression(),
            child: Text('Cancel'))
      ],
    );
  }
}
