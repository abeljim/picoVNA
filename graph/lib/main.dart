import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:graph/graph.dart';
import 'package:graph/drawer.dart';
import 'package:graph/app_theme.dart';
import 'package:graph/vna_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
        return MaterialApp(
            title: 'NanoVNA',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'NanoVNA'),
            debugShowCheckedModeBanner: false,
        );
    }
}

class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
    var vna = VnaService();
    AnimationController _animationController;
    bool isPlaying = false;

    @override 
    void initState() {
        super.initState();
        _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    }

    @override
    void dispose() {
        super.dispose();
        _animationController.dispose();
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: AppTheme.transparent,
                elevation: 0,
                centerTitle: true,
                title: Container(
                    child: Text(
                        widget.title,
                        style: TextStyle(
                            color: AppTheme.darkText,
                        ),
                    ),
                ),
                iconTheme: IconThemeData(color: AppTheme.nearlyBlack),
                actions: <Widget>[
                    IconButton(
                        icon: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: _animationController),
                        onPressed: () {
                            vna.setRun(!vna.getRun());
                            _handleOnPressed();
                        },
                    ),
                ],
            ),
            body: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        LiveLineChart(vna, _animationController),
                    ],
                ),
            ),
            drawer: appDrawer(context, vna),
        );
    }

    _handleOnPressed(){
        setState(() {
            isPlaying = !isPlaying;
            isPlaying
                ? _animationController.forward()
                : _animationController.reverse();
        });
    }
}

