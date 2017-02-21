(
/* -------------
 * read_wind_csv.scd : takes a filename and parses it into a array of dictionaries
 * containing the date, wind speed, and wind direction.
 */
~parse_date_str = {|datestr|
	var dlist, ddict;
	dlist = datestr.split($-).asInteger;
	ddict = Dictionary.newFrom([\year, dlist[0], \month, dlist[1], \day, dlist[2]]);
	// return ddict
	ddict;
};

~read_wind_csv = {|filename|
	var d, data, ndays, varNames, thisDict;
	d = CSVFileReader.read(filename);

	// store number of days and the variables names
	ndays = d[0][1].asInteger;
	varNames = d[1];

	data = Array.newClear(ndays);
	ndays.do({|i|
		thisDict = Dictionary.new;
		varNames.do({|varName,k|
			if(varName.asSymbol == \Date, {
				thisDict[varName.asSymbol] = ~parse_date_str.(d[i+2][k]);
				//ddict.postln;
			},{
				thisDict[varName.asSymbol] = d[i+2][k].asFloat;
			});
		});
		//thisDict.postln;
		data[i] = thisDict;
	});

	// return data
	data;
};

~get_wind_on_date = {|date_in, wind_data|
	var windOut, dIn;
	switch(date_in.class,
		String, {dIn = ~parse_date_str.(date_in)},
		Dictionary, {dIn = date_in}
	);

	wind_data.do({|data,i|
		if(data[\Date] == dIn, {windOut = data});
	});
	// return windOut
	windOut;
};
)

