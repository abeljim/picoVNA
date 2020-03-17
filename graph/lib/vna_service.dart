import 'package:grpc/grpc.dart';
import 'package:graph/grpc/pico_vna.pb.dart';
import 'package:graph/grpc/pico_vna.pbgrpc.dart';

class VnaService{

    static PicoGrpcClient client;
    bool _running;
	num _startFreq = 100;
	num _stopFreq = 300;
	num _yMin = -40;
	num _yMax = -20;

    VnaService() {
        var channel = ClientChannel('192.168.4.1', port: 50051, options: const ChannelOptions(credentials: ChannelCredentials.insecure()));
        client = PicoGrpcClient(channel, options: CallOptions(timeout: Duration(seconds: 5)));
        this._running = false;
    }

    Future<ScanReply> getScan() async {
        var input = ScanRequest();
        input.start = (_startFreq * 1000000).round();
        input.stop = (_stopFreq * 1000000).round();
        return client.requestScan(input);
    }

    void setRun(bool control) {
        this._running = control;
    }

    bool getRun() {
        return this._running;
    }

	bool setStartFreq(num freq) {
		if(freq >= 1 && freq <= 900) {
			if(freq < this._stopFreq){
				this._startFreq = freq;
			}
			return true;
		}
		return false;
	}

	num getStartFreq() {
		return this._startFreq;
	}

	bool setStopFreq(num freq) {
		if(freq >= 1 && freq <= 900) {
			if(freq > this._startFreq){
				this._stopFreq = freq;
			}
			return true;
		}
		return false;
	}

	num getStopFreq() {
		return this._stopFreq;
	}

	double getYMax() {
		return this._yMax.roundToDouble();
	}

	double getYmin() {
		return this._yMin.roundToDouble();
	}

	bool setYmax(num input) {
		if(input >= -20 && input <= 20) {
			this._yMax = input;
			return true;
		}
		return false;
	}

	bool setYmin(num input) {
		if(input >= -60 && input <= -30) {
			this._yMin = input;
			return true;
		}
		return false;
	}
}