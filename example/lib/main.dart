import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:snacknload/snacknload.dart';
import 'package:example/custom_animation.dart';

void main() {
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  SnackNLoad.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = IndicatorType.fadingCircle
    ..loadingStyle = LoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withValues(alpha: 0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackNLoad Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MyHomePage(title: 'SnackNLoad Example'),
      builder: SnackNLoad.init(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({this.title});

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  Timer? _timer;
  late double _progress;

  @override
  void initState() {
    super.initState();
    SnackNLoad.addStatusCallback((status) {
      if (status == LoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    SnackNLoad.showSuccess('Use in initState');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Wrap(
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text('Dismiss'),
                    onPressed: () async {
                      _timer?.cancel();
                      await SnackNLoad.dismiss();
                    },
                  ),
                  TextButton(
                    child: Text('Show'),
                    onPressed: () async {
                      _timer?.cancel();
                      await SnackNLoad.show(
                        status: 'loading...',
                        maskType: MaskType.black,
                      );
                    },
                  ),
                  TextButton(
                    child: Text('Show Toast'),
                    onPressed: () {
                      _timer?.cancel();
                      SnackNLoad.showToast(
                        'Toast',
                      );
                    },
                  ),
                  TextButton(
                    child: Text('Show Snackbar'),
                    onPressed: () {
                      _timer?.cancel();
                      SnackNLoad.showSnackBar(
                        'Welcome in year 2025!\nMay this year will full fill your all dreams and provide you happiness moment',
                        type: Type.success,
                        showIcon: true,
                        position: Position.top,
                      );
                    },
                  ),
                  TextButton(
                    child: Text('Show Dialog'),
                    onPressed: () {
                      _timer?.cancel();
                      SnackNLoad.showDialog(
                        title: "Hello",
                        dismissOnTap: true,
                        useAdaptive: true,
                        contentWidget: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 12,
                          ),
                          child: Text(
                              "I'm dialog content powered by SnackNLoad. SnackNLoad is an flutter package published by Subhash Chandra Shukla."),
                        ),
                        actionConfigs: [
                          ActionConfig(
                            label: "OK",
                            onPressed: () {
                              print("action tap");
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  TextButton(
                    child: Text('Show Success'),
                    onPressed: () async {
                      _timer?.cancel();
                      await SnackNLoad.showSuccess('Great Success!');
                    },
                  ),
                  TextButton(
                    child: Text('Show Error'),
                    onPressed: () {
                      _timer?.cancel();
                      SnackNLoad.showError('Failed with Error');
                    },
                  ),
                  TextButton(
                    child: Text('Show Info'),
                    onPressed: () {
                      _timer?.cancel();
                      SnackNLoad.showInfo('Useful Information.');
                    },
                  ),
                  TextButton(
                    child: Text('Show Progress'),
                    onPressed: () {
                      _progress = 0;
                      _timer?.cancel();
                      _timer = Timer.periodic(const Duration(milliseconds: 100),
                          (Timer timer) {
                        SnackNLoad.showProgress(_progress,
                            status: '${(_progress * 100).toStringAsFixed(0)}%');
                        _progress += 0.03;

                        if (_progress >= 1) {
                          _timer?.cancel();
                          SnackNLoad.dismiss();
                        }
                      });
                    },
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(
                  30,
                ),
                child: Column(
                  children: <Widget>[
                    Text('Style'),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: CupertinoSegmentedControl<LoadingStyle>(
                        selectedColor: Colors.blue,
                        children: {
                          LoadingStyle.dark: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('dark'),
                          ),
                          LoadingStyle.light: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('light'),
                          ),
                          LoadingStyle.custom: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('custom'),
                          ),
                        },
                        onValueChanged: (value) {
                          SnackNLoad.instance.loadingStyle = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(
                  30,
                ),
                child: Column(
                  children: <Widget>[
                    Text('Mask Type'),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: CupertinoSegmentedControl<MaskType>(
                        selectedColor: Colors.blue,
                        children: {
                          MaskType.none: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('none'),
                          ),
                          MaskType.clear: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('clear'),
                          ),
                          MaskType.black: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('black'),
                          ),
                          MaskType.custom: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('custom'),
                          ),
                        },
                        onValueChanged: (value) {
                          SnackNLoad.instance.maskType = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(
                  30,
                ),
                child: Column(
                  children: <Widget>[
                    Text('Toast Position'),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: CupertinoSegmentedControl<Position>(
                        selectedColor: Colors.blue,
                        children: {
                          Position.top: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('top'),
                          ),
                          Position.center: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('center'),
                          ),
                          Position.bottom: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('bottom'),
                          ),
                        },
                        onValueChanged: (value) {
                          SnackNLoad.instance.position = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(
                  30,
                ),
                child: Column(
                  children: <Widget>[
                    Text('Animation Style'),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child:
                          CupertinoSegmentedControl<SnackNLoadAnimationStyle>(
                        selectedColor: Colors.blue,
                        children: {
                          SnackNLoadAnimationStyle.opacity: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('opacity'),
                          ),
                          SnackNLoadAnimationStyle.offset: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('offset'),
                          ),
                          SnackNLoadAnimationStyle.scale: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('scale'),
                          ),
                          SnackNLoadAnimationStyle.custom: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('custom'),
                          ),
                        },
                        onValueChanged: (value) {
                          SnackNLoad.instance.animationStyle = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(
                  30,
                ),
                child: Column(
                  children: <Widget>[
                    Text('IndicatorType(total: 23)'),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: CupertinoSegmentedControl<IndicatorType>(
                        selectedColor: Colors.blue,
                        children: {
                          IndicatorType.circle: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('circle'),
                          ),
                          IndicatorType.wave: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('wave'),
                          ),
                          IndicatorType.ring: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('ring'),
                          ),
                          IndicatorType.pulse: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('pulse'),
                          ),
                          IndicatorType.cubeGrid: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('cubeGrid'),
                          ),
                          IndicatorType.threeBounce: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('threeBounce'),
                          ),
                        },
                        onValueChanged: (value) {
                          SnackNLoad.instance.indicatorType = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
