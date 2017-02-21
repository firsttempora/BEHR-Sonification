(
/* ------------------
 * ~read_behr_csv : takes a filename and parses csv file, returning a pointer to
 * the data, stored in dictionary format. The keys are the variable names from the
 * csv and the data is stored 2d arrays or arrays of 2d arrays when there is 3d data.
 */
~read_behr_csv = {|filename|
    var d, data, count, rows, columns, variableNames, threeDvariables;
    //filename.postln;
    d = CSVFileReader.read(filename);
    data = Dictionary.new;

    // store array shape and variable names
    rows = d[0][2].asInteger;
    columns = d[0][1].asInteger;
    variableNames = d[1];

    // initialize 2d arrays
    variableNames.do({|v,i|
        data[v] = Array2D.new(rows, columns);
    });

    // for each variable name, read the data into the 2d arrays
    count = 0;
    rows.do({|r, i|
        columns.do({|c, j|
            variableNames.do({|v, k|
                // count.post; ": ".post; r.post; ", ".post; c.post; " ".post; v.postln;
                data[v][r,c] = d[count+2][k].asFloat;
            });
            count = count + 1;
        });
    });

    // search variable names and find those with a hyphen
    threeDvariables = Dictionary.new;
    variableNames.do({|v|
        var temp = v.findAll("-");
        if(temp != nil, {
            var str = v[0..temp[0]-1];
            var num = v[temp[0]+1..].asInteger;
            if(threeDvariables[str].notNil, {
                threeDvariables[str][num] = data[v];
            }, {
                threeDvariables[str] = Dictionary.new;
                    threeDvariables[str][num] = data[v];
            });
        });
    });

    // remove all keys in data that correspond to a hyphenated variable
    data.keys.do({|k|
        var temp = k.findAll("-");
        if(temp != nil, {
            data[k] = nil;
        });
    });

    // add the array of 2d array version back into data
    threeDvariables.keys.do({|k|
        data[k] = Array.newClear(threeDvariables[k].size);
        data[k].do({|v,i|
            data[k][i] = threeDvariables[k][i];
        });
    });

    // return data
    data;
};

/* ------------------
 * ~getAltitudeAt : returns the 3rd dimension (altitude) of array of 2d array data
 * takes a pointer to data, and row/column indicies.
 */
~getAltitudeAt = {|arrayOf2dArrays, r, c|
    var size = arrayOf2dArrays.size;
    var vec = Array.newClear(size);
    vec.size.do({|i|
        vec[i] = arrayOf2dArrays[i][r,c];
    });
    vec;
};

/* ------------------
 * ~make_filenames : returns all the files in a directory, as an array.
 */
~make_filenames = {|base|
    var a = ("ls"+base).unixCmdGetStdOut;
    var b = a.findAll("\n");
    var c = Array.newClear(b.size);
    b = [-1, b].flat;

    (b.size-1).do({|i|
        c[i] = a[(b[i]+1)..(b[i+1]-1)];
    });
    c;
};


/* ------------------
 * ~nanMax : function that returns the maximum item in an array, and only NaN if all values
 * in the array are also nan. Assumes -inf and inf will also not be legal values
 */
~nanMax = {|array|
    var value = -inf;
    array.do({|i|
        if(i.isNaN.not and: {i > value;},
            {value = i;}
        );
    });
    if(value == -inf,
        {value = array[0];}
    );
    value;
};

/* ------------------
 * ~nanMin : function that returns the minimum item in an array, and only NaN if all values
 * in the array are also nan. Assumes -inf and inf will also not be legal values
 */
~nanMin = {|array|
    var value = inf;
    array.do({|i|
        if(i.isNaN.not and: {i < value;},
            {value = i;}
        );
    });
    if(value == inf,
        {value = array[0];}
    );
    value;
};


/* ------------------
 * ~sumarize_statistics : finds the min, median, mean, and max for each key in a dictionary
 */
~sumarize_statistics = {|dict|
    var blob = Dictionary.new;
    dict.keys.do({|k|
        blob[k] = Dictionary.new;
        // max
        if(dict[k].class == Array2D, {
            blob[k]["max"] = ~nanMax.(dict[k]);
        }, {
            var tempmax;
            tempmax = (dict[k].size.do.collect({|i| ~nanMax.(dict[k][i].asArray)}));
            blob[k]["max"] = ~nanMax.(tempmax);
        });

        // min
        if(dict[k].class == Array2D, {
            blob[k]["min"] = ~nanMin.(dict[k]);
        }, {
            var tempmin;
            tempmin = dict[k].size.do.collect({|i| ~nanMin.(dict[k][i].asArray)});
            blob[k]["min"] = ~nanMin.(tempmin);
        });

        // mean
        if(dict[k].class == Array2D, {
            blob[k]["mean"] = dict[k].mean;
        }, {
            var sum = 0.0;
            var count = 0.0;
            dict[k].size.do({|i|
                dict[k][i].asArray.do({|value|
                    if(value.isNaN, {}, {
                        sum = sum + value;
                        count = count + 1;
                    });
                });
            });
            blob[k]["mean"] = sum / count;
        });

        // median
        if(dict[k].class == Array2D, {
            blob[k]["median"] = dict[k].asArray.median;
        }, {
            var nums = List.new;
            dict[k].size.do({|i|
                dict[k][i].asArray.do({|value|
                    if(value.isNaN, {}, {
                        nums.add(value);
                    });
                });
            });
            blob[k]["median"] = nums.median;
        });
    });
    blob;
};

/* ------------------
 * ~findCellOfMinR : finds and returns the coordinates (row, col) of the minimum absolute
 * value of a 2d array.
 * Assuming that the 2d array passed in is the radius, this function finds the "center"
 * Assuming that the 2d array passed in is the angle, this function finds the cell closest to 0 degrees
 */
~findCellOfAbsMin = {|array2d|
    var minV = inf;
    var cellOfMinV;
    array2d.rows.do({|r|
        array2d.cols.do({|c|
            if(array2d[r,c].abs < minV, {
                minV = array2d[r,c].abs;
                cellOfMinV = [r, c];
            });
        });
    });
    cellOfMinV;
};

~parse_date_str = {|datestr|

	var dlist, ddict;
	dlist = datestr.split($-).asInteger;
	ddict = Dictionary.newFrom([\year, dlist[0], \month, dlist[1], \day, dlist[2]]);
	// return ddict
	ddict;
};

~read_wind_csv = {|filename|
	/* -------------
	* read_wind_csv.scd : takes a filename and parses it into an
	* array of dictionaries containing the date, wind speed, and
	* wind direction.
	*/
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
	/* ---------------------
	 * get_wind_on_date(date_in, wind_data)
	 * given a date as a string in "yyyy-mm-dd" format or
	 * as a dictionary with the keys year, month, and day, it
	 * will find and return the dictionary in wind_data (the array
	 * of dicts returned by read_wind_csv) that corresponds to
	 * that date. The result will be nil
	 */
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

"All functions successfully loaded".postln;
);

// unit testing.............................

// ~base_path = "/Users/kermit/Documents/behr_sonification/BEHR-Sonification/";
// ~data_path = "UnitTests/";
// ~file_names = ["dummy.csv", "dummy.csv"];
// ~data = ~read_behr_csv.(~base_path +/+ ~data_path +/+ ~file_names[0]);

// (
// ~data.keys.do({|k|
//     k.postln;
//     if(~data[k].class == Array2D, {
//         ~data[k].rowsDo({|r|r.postln;});
//         ~data[k].colsDo({|c|c.postln;});
//         }, {
//             ~data[k].size.do({|i|
//                 ~data[k][i].rowsDo({|r|r.postln;});
//                 ~data[k][i].colsDo({|c|c.postln;});
//             });
//     });
// });
// );
// ~data.["BEHRNO2apriori"].at(0).colsDo({|r|r.plot})