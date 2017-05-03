(
~compute_var_stats = {|data|
	// Given an array of data, returns a dictionary with fields
	// "min", "max", "avg", and "range". Ignores NaNs in the data.
	var minVal = inf;
	var maxVal = -inf;
	var countVal = 0;
	var sumVal = 0;
	var dataSummary = Dictionary.new;

	if( data.class != Array, {Error("data must be an instance of Array").throw} );
	data.do({|val|
		if (isNaN(val).not, {
			if(val < minVal, {minVal = val});
			if(val > maxVal, {maxVal = val});
			countVal = countVal + 1;
			sumVal = sumVal + val;
		},{
			"found a nan in the data".warn;
		});
	});

	dataSummary["min"] = minVal;
	dataSummary["max"] = maxVal;
	dataSummary["avg"] = sumVal / countVal.asFloat;
	dataSummary["range"] = maxVal - minVal;

	// return the summary
	dataSummary;
};

~generate_all_site_stats = {|locs, varsToDo|
	// Generates a dictionary containing statistics for each individual site
	// Input: locs, varsToDo
	//    locs = a dictionary of dicts, should have the hierarchy siteType/siteName/variables
	//    varsToDo = an array of variable names that statistics should be done on

	var locsStats = Dictionary.new;
	var locsVars;
	// Input checking
	if( locs.class != Dictionary, {Error("locs must be a dictionary").throw} );
	if( varsToDo.class != Array, {Error("varsToDo must be an array").throw} );
	locs.do({|val|
		if ( val.class != Dictionary, {Error("locs must contain dictionaries").throw} );
	}); // there should probably be more checks here, but I got tired of writing them


	locs.keys.do({|locType|
		locsStats[locType] = Dictionary.new;
		locs[locType].keys.do({|locName|
			locsStats[locType][locName] = Dictionary.new;
			varsToDo.do({|varName|
				locsStats[locType][locName][varName] = ~compute_var_stats.(locs[locType][locName][varName]);
			});
		});
	});

	// return locsStats
	locsStats;
};

~generate_type_stats = {|locs, varsToDo|
	var typeStats = Dictionary.new;
	var typeMin, typeMax, typeCount, typeSum, typeNpoints, data;

	// Input checking
	if( locs.class != Dictionary, {Error("locs must be a dictionary").throw} );
	if( varsToDo.class != Array, {Error("varsToDo must be an array").throw} );
	locs.do({|val|
		if ( val.class != Dictionary, {Error("locs must contain dictionaries").throw} );
	}); // there should probably be more checks here, but I got tired of writing them

	locs.keys.do({|locType|
		typeStats[locType] = Dictionary.new;

		varsToDo.do({|varName|
			typeMin = inf;
			typeMax = -inf;
			typeCount = 0;
			typeSum = 0;
			typeNpoints = inf;

			locs[locType].keys.do({|locName|
				data = locs[locType][locName][varName];
				data.do({|val|
					if (data.size < 10, {Error("Pass the dictionary of locations (not the summary) to generate_global_stats").throw});
					if (isNaN(val).not, {
						if(val < typeMin, {typeMin = val});
						if(val > typeMax, {typeMax = val});
						typeCount = typeCount + 1;
						typeSum = typeSum + val;
					},{"generate_type_stats: found a nan in the data".warn});
				});

				if(data.size < typeNpoints, {typeNpoints = data.size});
			});

			typeStats[locType][varName] = Dictionary.new;
			typeStats[locType][varName]["min"] = typeMin;
			typeStats[locType][varName]["max"] = typeMax;
			typeStats[locType][varName]["avg"] = typeSum / typeCount.asFloat;
			typeStats[locType][varName]["range"] = typeMax - typeMin;
			typeStats[locType][varName]["minDataPts"] = typeNpoints;
		});
	});

	// return typeStats
	typeStats;
};

~generate_global_stats = {|summary, varsToDo|
	var globalSummary = Dictionary.new;
	var varSummary, data;
	var globMin, globMax, globCount, globSum, globNpoints;

	varsToDo.do({|varName|

		globMin = inf;
		globMax = -inf;
		globCount = 0;
		globSum = 0;
		globNpoints = inf;

		summary.keys.do({|locType|
			summary[locType].keys.do({|locName|
				data = summary[locType][locName][varName];
				data.do({|val|
					if (data.size < 10, {Error("Pass the dictionary of locations (not the summary) to generate_global_stats").throw});

					if (isNaN(val).not, {
					if(val < globMin, {globMin = val});
					if(val > globMax, {globMax = val});
					globCount = globCount + 1;
					globSum = globSum + val;
						},{
					"generate_global_stats: found a nan in the data".warn;
					});
				});

				if (data.size < globNpoints, {globNpoints = data.size});
			});
		});
		varSummary = Dictionary.new;
		varSummary["min"] = globMin;
		varSummary["max"] = globMax;
		varSummary["avg"] = globSum / globCount.asFloat;
		varSummary["range"] = globMax - globMin;
		varSummary["minDataPts"] = globNpoints;


		globalSummary[varName] = varSummary;
	});

	// return globalSummary
	globalSummary;
};

"All functions in trend_data_funcs.scd loaded".postln;
)