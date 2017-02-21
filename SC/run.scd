~base_path = "/Users/kermit/Documents/behr_sonification/BEHR-Sonification/";
//~base_path = "/home/josh/Dropbox/Supercollider/BEHR-Sonification";
~data_path = "data/BEHR_subsets";

thisProcess.interpreter.executeFile(~base_path+/+"SC/funcs.scd");
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

(
s.waitForBoot(
    thisProcess.interpreter.executeFile(~base_path+/+"SC/synths.scd");
);
);

(
~numChans = 2;
~timeInverval = 0.2;
~f0 = 60;
);


(
var dataField = "BEHRScatteringWeights";
~t = Task.new({
    var curNO2apriori = ~getAltitudeAt.(~data[0][dataField], 0, 0);
    var amps = (curNO2apriori / ~dataSummary[0][dataField]["max"]);
    ~synths = Array.newClear(curNO2apriori.size);
    ~synths.size.do({|i|
        [75*i, amps[i]].postln;
        ~synths[i] = Synth(\spectrum, [\freq, ~f0*i, \amp, 0]);
    });

    ~data[0][dataField][0].rows.do({|r|
        ~data[0][dataField][0].cols.do({|c|
            curNO2apriori = ~getAltitudeAt.(~data[0][dataField], r, c);
            //amps = (curNO2apriori / ~nanMax.(curNO2apriori));
            amps = (curNO2apriori / ~dataSummary[0][dataField]["max"]);


            ~synths.size.do({|i|
                amps[i].postln;
                if(amps[i].isNaN, {
                    ~synths[i].set(\amp, 0);
                }, {
                    ~synths[i].set(\amp, amps[i]);
                });

            });
            ~timeInverval.wait;
            "\n".postln;
        });
    });


    ~timeInverval.wait;
    ~synths.size.do({|i|
        ~synths[i].free;
    });


}).play;


);

