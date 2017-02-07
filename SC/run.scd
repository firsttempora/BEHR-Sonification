//~base_path = "/Users/kermit/Documents/behr_sonification/BEHR-Sonification/";
~base_path = "/home/josh/Dropbox/Supercollider/BEHR-Sonification/";
~data_path = "data/";

thisProcess.interpreter.executeFile(~base_path+/+"SC/read_behr_csv.scd");
~file_names = ~make_filenames.(~base_path+/+~data_path);
(
~data = Array.newClear(~file_names.size);
~file_names.do({|fn, i|
    ~data[i] = ~read_behr_csv.(~base_path +/+ ~data_path +/+ fn);
});
);

(
~dataSummary = Array.newClear(~data.size);
~data.size.do({|i|
    ~dataSummary[i] = ~sumarize_statistics.(~data[i]);
});
);

a = ~getAltitudeAt.(~data[1]["BEHRNO2apriori"], 0, 0);
a = a/5e-10;

~dataSummary[1]["BEHRNO2apriori"]["median"]

~sw = ~getAltitudeAt.(~data[1]["BEHRScatteringWeights"],0,0);
~sw = ~sw/~sw.maxItem;

~plev = ~getAltitudeAt.(~data[1]["BEHRPressureLevels"],0,0);
~plev = ~plev/~plev.maxItem;
s.boot;

(
SynthDef(\spectrum, {|freq, amp|
    Out.ar(0, amp * SinOsc.ar(freq))
}).add;
);

// This is giving no sound using BEHRNO2apriori (nans?)
(
b = Array.newClear(a.size);
b.size.do({|i|
	a[i].postln;
	b[i] = Synth(\spectrum, [\freq, 75*i, \amp, ~plev[i]]);
});
);

(
b.size.do({|i|
    b[i].set(\amp, a[i]);
});
);



(
b.size.do({|i|
    b[i].free;
});
);

x = Synth(\spectrum, [\freq, 440, \amp, 0.1]);

(
b = Array.newClear(a.size);
b.size.do({|i|
	a[i].postln;
	b[i] = Synth(\spectrum, [\freq, 75*i, \amp, 0]);
});

r = Task.new({
	~data[1]["BEHRScatteringWeights"][0].colAt(0).size.do({|i|
		~data[1]["BEHRScatteringWeights"][0].rowAt(0).size.do({|j|
			[i,j].postln;
			~swij = ~getAltitudeAt.(~data[1]["BEHRScatteringWeights"],i,j);
			~swij = ~swij / ~swij.maxItem;
			b.size.do({|k|
				b[k].set(\amp, ~swij[k]);
			});
			1.wait
		});
	});
});

r.play;
);

~getAltitudeAt.(~data[1]["BEHRScatteringWeights"],0,3)

