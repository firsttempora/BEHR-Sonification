~base_path = "/Users/kermit/Documents/behr_sonification/BEHR-Sonification/";
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

~dataSummary[0]["BEHRPressureLevels"]
~data[1].keys


//~getAltitudeAt.(~data[1]["BEHRNO2apriori"], 0, 0);
//a = a/a.maxItem;


s.boot;

(
SynthDef(\spectrum, {|freq, amp|
    Out.ar(0, amp * SinOsc.ar(freq))
}).add;
);

(
b = Array.newClear(a.size);
b.size.do({|i|
    b[i] = Synth(\spectrum, [\freq, 75*i, \amp, a]);
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

a



