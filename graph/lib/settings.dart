import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graph/app_theme.dart';
import 'package:graph/vna_service.dart';

class SettingsPage extends StatefulWidget {
	
	SettingsPage(this.vna);
	final VnaService vna;
	
	@override
	_SettingsPageState createState() => _SettingsPageState(vna); 
}

class _SettingsPageState extends State<SettingsPage> {

	_SettingsPageState(this.vna);
	VnaService vna;
	String _tempStart;
	String _tempStop;
	String _tempYMax;
	String _tempYMin;

	@override
	void dispose() {
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		_tempStart = vna.getStartFreq().toString();
		_tempStop = vna.getStopFreq().toString();
		_tempYMax = vna.getYMax().toString();
		_tempYMin = vna.getYmin().toString();
		return Scaffold(
			appBar: AppBar(
                backgroundColor: AppTheme.transparent,
                elevation: 0,
                centerTitle: true,
				iconTheme: IconThemeData(color: AppTheme.nearlyBlack),
				leading: Builder(
    				builder: (BuildContext context) {
      					return IconButton(
        					icon: const Icon(Icons.arrow_back),
        					onPressed: () { 
								Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
							},
      					);
    				},
  				),
                title: Container(
                    child: Text(
                        "Settings",
                        style: TextStyle(
                            color: AppTheme.darkText,
                        ),
                    ),
                ),
			),
			body: Container(
          		padding: const EdgeInsets.only(top: 5, bottom: 5, left: 60, right: 60),
          		child: ListView(
					shrinkWrap: true,
        			children: <Widget>[
          				TextFormField(
            				decoration: InputDecoration(labelText: "Start Frequency: Mhz"),
            				keyboardType: TextInputType.number,
           					inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
							initialValue: vna.getStartFreq().toString(),
							onChanged: (input) {
								_tempStart = input;
								
							},
						),
          				TextFormField(
            				decoration: InputDecoration(labelText: "Stop Frequency: Mhz"),
            				keyboardType: TextInputType.number,
           					inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
							initialValue: vna.getStopFreq().toString(),
							onChanged: (input) {
								_tempStop = input;
							},
						),
          				TextFormField(
            				decoration: InputDecoration(labelText: "Y Max"),
            				keyboardType: TextInputType.number,
           					//inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
							initialValue: vna.getYMax().toString(),
							onChanged: (input) {
								_tempYMax = input;
							},
						),
          				TextFormField(
            				decoration: InputDecoration(labelText: "Y Min"),
            				keyboardType: TextInputType.number,
           					//inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
							initialValue: vna.getYmin().toString(),
							onChanged: (input) {
								_tempYMin = input;
							},
						),								
					],
				),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () {
					return showDialog(
						context: context,
						builder: (context) {
							if(vna.setStartFreq(double.parse(_tempStart)) && vna.setStopFreq(double.parse(_tempStop)) && vna.setYmax(double.parse(_tempYMax)) && vna.setYmin(double.parse(_tempYMin))) {
								return AlertDialog(
									content: Text("Applied"),
									actions: <Widget>[
										FlatButton(
											onPressed: (){Navigator.of(context).pop();}, 
											child: Text('OK'))
									],
								);
							}
							else {
								return AlertDialog(
									content: Text("Failed"),
									actions: <Widget>[
										FlatButton(
											onPressed: (){Navigator.of(context).pop();}, 
											child: Text('OK'))
									],									
								);
							}
						}
					);
				},
				child: Icon(Icons.check),
			),
		);
	}
}