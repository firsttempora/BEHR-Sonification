~base_path = "/Users/kermit/Documents/behr_sonification/BEHR-Sonification/";

~data_path = "UnitTests/";
~file_names = ["dummy.csv", "dummy.csv"];

(
(
~read_behr_csv = {|filename|
    var d, data, count, rows, columns, variableNames, threeDvariables;
    //filename.postln;
    d = CSVFileReader.read(filename);
    data = Dictionary.new;

    // store array shape and variable names
    rows = d[0][1].asInteger;
    columns = d[0][2].asInteger;
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
);

~data = ~read_behr_csv.(~base_path +/+ ~data_path +/+ ~file_names[0]);
);

~data.keys
~data["BEHRColumnAmountNO2Trop"]
~data[0]
~data[1]
~data[2]
~data.[50]
~data.[5].size

t = "abcd";
t[1..2]

//~path = "/user/k/kermit/Downloads/BEHRWebTools/data/OMI_BEHR_v2-1B_20050101.txt";
~path = "/Users/kermit/Desktop/behr_josh_project/BEHRWebTools/data/OMI_BEHR_v2-1B_20050101.txt";

~data = CSVFileReader.read(~path);
~dataT = Array.newClear(~data[0].size);
~dataT.size.do{|i| ~dataT[i] = Array.newClear(~data.size-1)};
~header = ~data[0];

(
(~dataT.size).do{|i|
	(~dataT[0].size).do{|j|
		~dataT[i][j] = ~data[j+1][i].asFloat;
	};
};
);

(
~dataT.size.do{|i|
	~dataT[i].plot(~header[i]);
};
);


Date.getDate.format("%Y-%m-%d")
