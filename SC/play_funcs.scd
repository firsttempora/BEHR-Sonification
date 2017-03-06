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

~task_driver_func = {|locs, locsActive, siteStats, globStats, no2Synths, o3Synths, optsDict|
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
	*    globStats = the dictionary of global statistics
	*    no2Synths = the array of synths representing NO2 values
	*    o3Synths = the array of synths representing O3 values
	*    optsDict = a dictionary of options that control how the task executes. See below for list of required options
	*/

	var req_opts = Set.newFrom(["normType","delay","playNO2","playO3","doLoop","updateGUI"]);
	/* normType = a string, either "global" or "local" - controls whether the data value is normalized by the global min/max or the min/max for that site
	*  delay = time in seconds between data points
    *  playNO2, playO3 = boolean values, turn on or off NO2 and O3 sounds for all sites
    *  doLoop = boolean, true to loop back to the beginning once the end is reached, false to play once and stop.
	*/

	var valInd, statDict;
	var no2var = "BEHRNO2";
	var o3var = "O3_VMR";
	var no2freqs = [500, 8000];
	var o3freqs = [500, 8000];

	// Input checking
	if (optsDict.keys != req_opts, {Error("optsDict must have the keys: %. (Modify req_opts in this function if needed.)".format(req_opts)).throw});

	// End input checking //

	valInd = 0;

	inf.do({
		locs.keys.asArray.sort.do({|type,i|
			locs[type].keys.asArray.sort.do({|name, j|
				var curNO2Val, curNO2ValScaled, curO3Val, curO3ValScaled;
				//"delay = %, optDict[delay] = %".format(delay, optsDict["delay"]).postln;
				//"%: %, %: %".format(i, type, j, name).postln;

				switch(optsDict["normType"],
					"global", {statDict = globStats},
					"local", {statDict = siteStats[type][name]},
					{Error("Unrecognized value for normType: %".format(optsDict["normType"])).throw}
				);

				//"Doing normalization".postln;
				//"min = %, max = %".format(statDict[no2var]["min"], statDict[no2var]["max"]).postln;

				// Do the value normalization - NO2 first
				curNO2Val = locs[type][name][no2var][valInd];
				//"%: val = %".format(name, curNO2Val).postln;

				curNO2ValScaled = curNO2Val.linexp(statDict[no2var]["min"], statDict[no2var]["max"], no2freqs[0], no2freqs[1]);
				//"%: scaled = %".format(name, curNO2ValScaled).postln;

				if(locsActive[i][j] and: optsDict["playNO2"], {
					"Setting % no2 freq to %".format(name, curNO2ValScaled).postln;
					no2Synths[i][j].set(\freq, curNO2ValScaled);
					no2Synths[i][j].run(true);
				}, {
					no2Synths[i][j].run(false);
				});

				// Then O3
				//"min = %, max = %".format(statDict[o3var]["min"], statDict[o3var]["max"]).postln;
				curO3Val = locs[type][name][o3var][valInd];
				curO3ValScaled = curO3Val.linexp(statDict[o3var]["min"], statDict[o3var]["max"], o3freqs[0], o3freqs[1]);
				//"%: o3 val = %".format(name, curO3Val).postln;
				//"%: o3 scaled = %".format(name, curO3ValScaled).postln;

				if(locsActive[i][j] and: optsDict["playO3"], {
					"Setting % o3 freq to %".format(name, curO3ValScaled).postln;
					o3Synths[i][j].set(\freq, curO3ValScaled);
					o3Synths[i][j].run(true);
				}, {
					o3Synths[i][j].run(false);
				});


			});
		});

		optsDict["delay"].wait;

		valInd = valInd + 1;
		if(optsDict["doLoop"] and: (valInd >= globStats[no2var]["minDataPts"]), {valInd = 0});
		"valInd: %".format(valInd).postln;
	});

};

"All play functions loaded successfully".postln;

)
