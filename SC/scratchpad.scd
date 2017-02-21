(
var dataField = "BEHRNO2apriori";
// var dataField = "BEHRScatteringWeights";
var hardcodedcenterpixelRow = 2;
var hardcodedcenterpixelCol = 1;

~t = Task.new({
    var curNO2apriori = Array.newClear(3);
    var amps = Array.newClear(3);
    ~synths = Array.newClear(3);

    // initialize the variables
    curNO2apriori.size.do({|i|
        curNO2apriori[i] = ~getAltitudeAt.(~data[0][dataField], 0, 0);
        amps[i] = (curNO2apriori[i] / ~dataSummary[0][dataField]["max"]);
        ~synths[i] = Array.newClear(curNO2apriori[0].size);
        ~synths[i].size.do({|j|
            ~synths[i][j] = Synth(\spectrum_pan2, [\freq, ~f0*j, \amp, 0, \chan, 0, \pan, i-1]);
        });
    });

    // iterate over dates and listen to hard coded pixels
    ~data.size.do({|date|
        curNO2apriori.size.do({|i|
            curNO2apriori[i] =
                ~getAltitudeAt.(~data[date][dataField],
                    hardcodedcenterpixelRow, hardcodedcenterpixelCol-i+1);
            amps[i] = (curNO2apriori[i] / ~dataSummary[date][dataField]["max"]);
            {plot(~destroyNans.(amps[0]))}.defer;
            ~synths[i].size.do({|j|
                (amps[i][j]/amps[i].size).postln;
                if(amps[i][j].isNaN, {
                    ~synths[i][j].set(\amp, 0);
                },{
                        ~synths[i][j].set(\amp, amps[i][j]);
                });
            });
            "playing pixel: ".post;
            date.post; " ".post;
            hardcodedcenterpixelRow.post; " ".post;
            (hardcodedcenterpixelCol-i+1).postln;

            ~timeInverval.wait;
        });
    });

    // free the synths
    curNO2apriori.size.do({|i|
        ~synths[i].size.do({|j|
            ~synths[i][j].free;
            ~synths[i][j] = nil;
        });
    })

}).play;
);