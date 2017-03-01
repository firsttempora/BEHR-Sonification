(
~numChans = 2;
~timeInverval = 0.2;
~f0 = 60;
);

(
~synths = Array.newClear(~locations.size);
~locations.keys.asArray.sort.do({|type, i|
	~synths[i] = Array.newClear(~locations[type].size);
	~locations[type].keys.asArray.sort.do({|loc, j|
		~synths[i][j] = Synth.newPaused(\spectrum_pan2, [\freq, 100, \amp, 0.01]);
	});
});


~t = Task.new({
	~totalNumDataPts.do({|valInd|
		~locations.keys.asArray.sort.do({|type, i|
			~locations[type].keys.asArray.sort.do({|loc, j|
				var curVal = ~locations[type][loc]["BEHRNO2"][valInd];
				var curValScaled = curVal.linlin(~no2Summary["min"], ~no2Summary["max"], 500, 8000);
				if(~locsSelected[i][j], {
					~synths[i][j].set(\freq, curValScaled);
					~synths[i][j].run(true);
				}, {
					~synths[i][j].run(false);
					//~synths[i][j].set(\freq, 0);
				});
			});
		});
		~timeInverval.wait;
	});


	~timeInverval.wait;

	~synths.size.do({|i|
		~synths[i].size.do({|j|
			~synths[i][j].free;
		});
	});

}).play;
);

