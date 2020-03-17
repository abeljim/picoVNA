import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:graph/app_theme.dart';
import 'package:graph/vna_service.dart';
import 'package:graph/grpc/pico_vna.pb.dart';
import 'package:graph/grpc/pico_vna.pbgrpc.dart';
import 'package:complex/complex.dart';

Timer timer;

//ignore: must_be_immutable
class LiveLineChart extends StatefulWidget {
   LiveLineChart(this.vna, this.ac);
   VnaService vna;
   AnimationController ac;

  @override
  _LiveLineChartState createState() => _LiveLineChartState(vna, ac);
}

class _LiveLineChartState extends State<LiveLineChart> {
  _LiveLineChartState(this.vna, this.ac);
  VnaService vna;
  AnimationController ac;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  } 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FrontPanel(vna, ac);
  }
}


SfCartesianChart getLiveLineChart(VnaService vna, [List<_ChartData> chartData]) {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(majorGridLines: MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0),
            maximum: vna.getYMax(),
            minimum: vna.getYmin(),
        ),
        series: <LineSeries<_ChartData, double>>[
            LineSeries<_ChartData, double>(
                dataSource: chartData,
                color: AppTheme.dark_grey,
                xValueMapper: (_ChartData sales, _) => sales.mag,
                yValueMapper: (_ChartData sales, _) => sales.freq,
                animationDuration: 0,
                dataLabelSettings: DataLabelSettings(
                    isVisible: false, labelAlignment: ChartDataLabelAlignment.top),
            )
        ],
        trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            lineType: TrackballLineType.vertical,
            tooltipSettings: InteractiveTooltip(format: '{point.x} : {point.y}')
        ),
    );
}


class FrontPanel extends StatefulWidget {
  //ignore: prefer_const_constructors_in_immutables
  FrontPanel(this.vna, this.ac);
  final VnaService vna;
  final AnimationController ac;

  @override
  _FrontPanelState createState() => _FrontPanelState(vna, ac);
}

class _FrontPanelState extends State<FrontPanel> {
    _FrontPanelState(this.vna, this.ac) {
        timer = Timer.periodic(const Duration(milliseconds: 100), updateDataSource);
    }
    
    Timer timer;
    VnaService vna;
	AnimationController ac;
    List<_ChartData> chartData;
    bool loading = false;
    
    void updateDataSource(Timer timer) async {
        if(vna.getRun() && loading == false) {
            loading = true;
			var result;

			try {
            	result = await vna.getScan();
				chartData = _dataConvert(result);
				setState(() {
              		loading = false;
            	});
			}
			catch(e) {
				print('ERROR: $e');
				AlertDialog alert = AlertDialog(
					content: Text("Reboot Nano VNA"),
					actions: <Widget>[
					FlatButton(
						onPressed: (){
							Navigator.of(context).pop();
							vna.setRun(false);
							setState(() {
              					loading = false;
								ac.reverse();
            				});
						}, 
						child: Text('OK'))
					],									
				);
				showDialog(context: context, builder: (BuildContext context) {
					return alert;
				});
			}
			
        }
    }

    @override
    void dispose() {
        timer?.cancel();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return getLiveLineChart(vna, chartData);
    }
}


class _ChartData {
  _ChartData(this.freq, this.mag);
  final num freq;
  final num mag;
}

List<_ChartData> _dataConvert(ScanReply input) {
    List<_ChartData> newData = new List();

    for(var i = 0; i < input.freqs.length; i++) {
        num real = input.s11Data[i].real;
        num imag = input.s11Data[i].im;
        var complex = Complex(real,imag);
        num abs = complex.abs();
        num log10 = math.log(abs)/math.log(10);
        var mag = 20 * log10;
        var temp = _ChartData(mag ,input.freqs[i] / 1000000);
        newData.add(temp);
    }

    return newData;
}