(
~init_play_array = {|locs, init_func|
	// Returns an array of arrays initialized to the size
	// [number of types][number of sites]. Initializes each
	// element by calling init_func
	var out_array;

	if (locs.class != Dictionary, {Error("locs must be a dictionary").throw});
	if (init_func.class != Function, {Error("init_func must be a function").throw});

	out_array = Array.newClear(locs.size);

	locs.keys.asArray.sort.do({|type,i|
		out_array[i] = Array.newClear(locs[type].size);
		locs[type].keys.asArray.sort.do({|locName,j|
			out_array[i][j] = init_func.();
		});
	});

	// return out_array
	out_array;
};

~site_key_to_ind = {|locs,type,name|
	var tind, nind, locTypes, locNames;
	locTypes = locs.keys.asArray.sort;
	tind = -1;
	locTypes.do({|thisType,i|
		if (thisType == type, {tind = i});
	});
	if (tind < 0, {Error("% is not a type in locs".format(type)).throw});

	locNames = locs[type].keys.asArray.sort;
	nind = -1;
	locNames.do({|thisName,i|
		if (thisName == name, {nind = i});
	});
	if (nind < 0, {Error("% is not a name in locs[%]".format(name,type)).throw});

	// return type index and name index
	[tind, nind];
};

~step_date_ind = {|step, globStats, theTask, theTaskOpts|
	var maxInd = globStats["BEHRNO2"]["minDataPts"]-1;
	"~globStats = %".format(~globStats).postln;
	~playDateInd = ~playDateInd + step;
	if(~playDateInd < 0, {~playDateInd = 0;});
	if(~playDateInd > maxInd, {~playDateInd = maxInd});
	theTaskOpts["updateGUI"] = true;
	theTaskOpts["oneStep"] = true;
	theTask.play(doReset: true);

	~playPauseButton.value = 0;
};

~mute_unmute_synths = {|val, no2Synths, o3Synths|
	no2Synths.do({|subArr|
		subArr.do({|thisSyn|
			thisSyn.set(\trig, val);
		});
	});
	o3Synths.do({|subArr|
		subArr.do({|thisSyn|
			thisSyn.set(\trig, val);
		});
	});
};


~switchSynths = {|typeOfSynth|
	// find out if the task is currently playing
	var taskStatus = ~mainTask.isPlaying;
    if(typeOfSynth == "uniform", {
        {
            ~mainTask.pause;
            ~mute_unmute_synths.(0, ~no2SynthsArr, ~o3SynthsArr);

            // free the synthes, set reference in array to nil
            ~no2SynthsArr.do({|locTypes, i|
                ~no2SynthsArr[i].do({|synth, j|
                    ~no2SynthsArr[i][j].free;
                    ~o3SynthsArr[i][j].free;
                    ~no2SynthsArr[i][j] = nil;
                    ~o3SynthsArr[i][j] = nil;
                });
            });

            // instantiate the new synths
            ~locations.keys.asArray.sort.do({|type,i|
                ~no2SynthsArr[i].do({|v, j|
                    ~no2SynthsArr[i][j] = Synth.newPaused(~taskOpts["defaultSynthName"], [\freq, 100, \amp, 0.01]);
                    ~o3SynthsArr[i][j] = Synth.newPaused(~taskOpts["defaultSynthName"], [\freq, 100, \amp, 0.01]);
                });
            });

            // unmute the synths
            ~mute_unmute_synths.(1, ~no2SynthsArr, ~o3SynthsArr);

            // resume the main task loop if it was playing
			if(taskStatus, {~mainTask.resume;});
        }.defer;
    // different synth for each location type
    }, {
        {
            ~mainTask.pause;
            ~mute_unmute_synths.(0, ~no2SynthsArr, ~o3SynthsArr);

            // free the synthes, set reference in array to nil
            ~no2SynthsArr.do({|locTypes, i|
                ~no2SynthsArr[i].do({|synth, j|
                     ~no2SynthsArr[i][j].free;
                     ~o3SynthsArr[i][j].free;
                     ~no2SynthsArr[i][j] = nil;
                     ~o3SynthsArr[i][j] = nil;
                });
            });

            // instantiate the new synths
            ~locations.keys.asArray.sort.do({|type,i|
                if(type == "Cities", {
                    ~no2SynthsArr[i].do({|v, j|
                        ~no2SynthsArr[i][j] = Synth.newPaused(~taskOpts["citySynth"], [\freq, 100, \amp, 0.01]);
                        ~o3SynthsArr[i][j] = Synth.newPaused(~taskOpts["citySynth"], [\freq, 100, \amp, 0.01]);
                    });
                });
                if(type == "PowerPlants", {
                    ~no2SynthsArr[i].do({|v, j|
                        ~no2SynthsArr[i][j] = Synth.newPaused(~taskOpts["powerPlantSynth"], [\freq, 100, \amp, 0.01]);
                        ~o3SynthsArr[i][j] = Synth.newPaused(~taskOpts["powerPlantSynth"], [\freq, 100, \amp, 0.01]);
                    });
                });
                if(type == "Rural", {
                    ~no2SynthsArr[i].do({|v, j|
                        ~no2SynthsArr[i][j] = Synth.newPaused(~taskOpts["ruralSynth"], [\freq, 100, \amp, 0.01]);
                        ~o3SynthsArr[i][j] = Synth.newPaused(~taskOpts["ruralSynth"], [\freq, 100, \amp, 0.01]);
                    });
                });

            });

            // unmute the synths
            ~mute_unmute_synths.(1, ~no2SynthsArr, ~o3SynthsArr);

            // resume the main task loop if it was playing
            if(taskStatus, {~mainTask.resume;});
        }.defer;
    });
};



~task_driver_func = {|locs, locsActive, siteStats, catStats, globStats, no2Synths, o3Synths, optsDict|
	/* This is the function that the main sound task will execute.
	* As long as the inputs are arrays (and so passed by reference)
	* you *should* be able to pass whatever variables you want to
	* it when creating the task and it will look to the right place
	* in the global scope
	*
	* Inputs:
	*    locs = the dictionary of locations by type then name that contains the data
	*    locsActive = the array of boolean values setting whether a location is playing
	*    siteStats = the dictionary of statistics by site
	*    catStats = the dictionary of statistics by category
	*    globStats = the dictionary of global statistics
	*    no2Synths = the array of synths representing NO2 values
	*    o3Synths = the array of synths representing O3 values
	*    optsDict = a dictionary of options that control how the task executes. See below for list of required options
	*/

	var req_opts = Set.newFrom(["normType","delay","playNO2","playO3","doLoop",
		"updateGUI","defaultSynthName","oneStep","pan","seasonFilter","synthSound",
        "powerPlantSynth","citySynth","ruralSynth"
    ]);
	/* normType = a string, either "global", "local", or "categorical" - controls whether the data value is normalized by the global min/max or the min/max for that site
	*  delay = time in seconds between data points
    *  playNO2, playO3 = boolean values, turn on or off NO2 and O3 sounds for all sites
    *  doLoop = boolean, true to loop back to the beginning once the end is reached, false to play once and stop.
	*/

	var statDict;
	var no2var = "BEHRNO2";
	var o3var = "O3_VMR";
	var no2freqs = [500, 8000];
	var o3freqs = [500, 8000];

	// Input checking
	if (optsDict.keys != req_opts, {Error("optsDict must have the keys: %. (Modify req_opts in this function if needed.)".format(req_opts)).throw});

	// End input checking //
	if(~playDateInd.isNil, {
		~playDateInd = 0;}
	);


    if(optsDict["updateGUI"], {
        {~speedSlider.valueAction = ~speedSpec.unmap(1.0/optsDict["delay"]);}.defer;
        {~no2CheckBox.valueAction = optsDict["playNO2"];}.defer;
        {~o3CheckBox.valueAction = optsDict["playO3"];}.defer;
        {~loopCheckBox.valueAction = optsDict["doLoop"]}.defer;

		switch(optsDict["normType"],
			"global", {{~scaleFilterPopup.valueAction = 0;}.defer;},
			"local", {{~scaleFilterPopup.valueAction = 1;}.defer;},
			"categorical", {{~scaleFilterPopup.valueAction = 2;}.defer;}
		);
    });


	inf.do({
		locs.keys.asArray.sort.do({|type,i|
			locs[type].keys.asArray.sort.do({|name, j|
				var curNO2Val, curNO2ValScaled, curO3Val, curO3ValScaled, curLocPan, curSeasonFilterScale;
				//"delay = %, optDict[delay] = %".format(delay, optsDict["delay"]).postln;
				//"%: %, %: %".format(i, type, j, name).postln;

				switch(optsDict["normType"],
					"global", {statDict = globStats},
					"categorical", {statDict = catStats[type]},
					"local", {statDict = siteStats[type][name]},
					{Error("Unrecognized value for normType: %".format(optsDict["normType"])).throw}
				);

				//"Doing normalization".postln;
				//"min = %, max = %".format(statDict[no2var]["min"], statDict[no2var]["max"]).postln;

				// Do the value normalization - NO2 first
				curNO2Val = locs[type][name][no2var][~playDateInd];
				//"%: val = %".format(name, curNO2Val).postln;

				curNO2ValScaled = curNO2Val.linexp(statDict[no2var]["min"], statDict[no2var]["max"], no2freqs[0], no2freqs[1]);
				//"%: scaled = %".format(name, curNO2ValScaled).postln;

				if(locsActive[i][j] and: optsDict["playNO2"], {
					// calculate the panning value corresponding to location
					curLocPan = ~loc2PanStereo.(locs[type][name]);
					// "%: pan = %".format(name, curLocPan).postln;

					// calculate the season filter based on month
					// {sin(((~dateCur.string.split($-)[1].asInt)-4/12)*2*pi).postln}.defer;
					curSeasonFilterScale =
					    sin(((~locations["Cities"]["Tucson"]["StartDate"][~playDateInd].split($-)[1].asInt)-4/12)*2*pi);

					curSeasonFilterScale = 2.0 * (4.0 ** (0.5 * curSeasonFilterScale));
					// "%: seasonFilter = %".format(name, curSeasonFilterScale.asString).postln;


					"Setting % no2 freq to %".format(name, curNO2ValScaled).postln;
					no2Synths[i][j].set(\freq, curNO2ValScaled);

					optsDict["pan"].postln;

					if( optsDict["pan"] == "no2Left", {
						no2Synths[i][j].set(\pan, -1);
					}, {
						no2Synths[i][j].set(\pan, curLocPan);
					});

					if(optsDict["seasonFilter"], {
						no2Synths[i][j].set(\seasonCutoff, min(curNO2ValScaled * curSeasonFilterScale, 20000));
						// "%: seasonFilter = %".format(name, min(curNO2ValScaled * curSeasonFilterScale, 20000).asString).postln;
					}, {
						no2Synths[i][j].set(\seasonCutoff, 20000);
					});

					no2Synths[i][j].run(true);
				}, {
					no2Synths[i][j].run(false);
				});

				// Then O3
				//"min = %, max = %".format(statDict[o3var]["min"], statDict[o3var]["max"]).postln;
				curO3Val = locs[type][name][o3var][~playDateInd];
				curO3ValScaled = curO3Val.linexp(statDict[o3var]["min"], statDict[o3var]["max"], o3freqs[0], o3freqs[1]);
				//"%: o3 val = %".format(name, curO3Val).postln;
				//"%: o3 scaled = %".format(name, curO3ValScaled).postln;

				if(locsActive[i][j] and: optsDict["playO3"], {
					"Setting % o3 freq to %".format(name, curO3ValScaled).postln;
					o3Synths[i][j].set(\freq, curO3ValScaled);

					if( optsDict["pan"] == "no2Left", {
						o3Synths[i][j].set(\pan, 1);
					}, {
						o3Synths[i][j].set(\pan, curLocPan);
					});

					if(optsDict["seasonFilter"], {
						o3Synths[i][j].set(\seasonCutoff, min(curO3ValScaled * curSeasonFilterScale, 20000));
						// "%: seasonFilter = %".format(name, min(curO3ValScaled * curSeasonFilterScale, 20000).asString).postln;
					}, {
						o3Synths[i][j].set(\seasonCutoff, 20000);
					});

					o3Synths[i][j].run(true);
				}, {
					o3Synths[i][j].run(false);
				});


			});
		});

        {~timeSlider.valueAction = ~timeSpec.unmap(~playDateInd);}.defer;
		optsDict["delay"].wait;

		if(optsDict["oneStep"], {
			~mainTask.stop;
			},{
				// else if not just taking one step
				~playDateInd = ~playDateInd + 1;
				if(~playDateInd >= globStats[no2var]["minDataPts"],{
					if(optsDict["doLoop"],
						{~playDateInd = 0},
						{~playDateInd = globStats[no2var]["minDataPts"]-1;
							if(~playPauseButton.notNil,
								{AppClock.sched(0.0, { ~playPauseButton.valueAction_(0);})},
								{~mainTask.stop;})
					});
				});
		});

		"~playDateInd: %".format(~playDateInd).postln;
	});

};

"All play functions loaded successfully".postln;

)
