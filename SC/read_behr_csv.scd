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
 * ~sumarize_statistics : finds the min, median, mean, and max for each key in a dictionary
 */
~sumarize_statistics = {|dict|
    var blob = Dictionary.new;
    dict.keys.do({|k|
        blob[k] = Dictionary.new;
        // max
        if(dict[k].class == Array2D, {
            blob[k]["max"] = dict[k].maxItem;
        }, {
            blob[k]["max"] = dict[k].size.do.collect({|i|dict[k][i].maxItem}).maxItem;
        });

        // min
        if(dict[k].class == Array2D, {
            blob[k]["min"] = dict[k].minItem;
        }, {
            blob[k]["min"] = dict[k].size.do.collect({|i|dict[k][i].minItem}).minItem;
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