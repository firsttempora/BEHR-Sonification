~base_path = "/Users/kermit/Documents/behr_sonification/BEHR-Sonification/";

~data_path = "UnitTests/";
~file_names = ["dummy.csv", "dummy.csv"];

(
(
~read_behr_csv = {|filename|
    var d, data, count;
    //filename.postln;
    d = CSVFileReader.read(filename);
    data = Dictionary.new;

    // store array shape as integer array
    data[d[0][0]] = [d[0][1].asInteger, d[0][2].asInteger];

    // store data labels as array
    data['variableNames'] = d[1];

    // initialize 2d arrays
    data['variableNames'].do({|v,i|
        data[v] = Array2D.new(data["ArrayShape"].at(0), data["ArrayShape"].at(1));
    });

    // for each variable name, read the data into the 2d arrays
    count = 0;
    data["ArrayShape"].at(0).do({|r, i|
        data["ArrayShape"].at(1).do({|c, j|
            data['variableNames'].do({|v, k|
                count.post; ": ".post; r.post; ", ".post; c.post; " ".post; v.postln;
                data[v][r,c] = d[count+2][k]
            });
            count = count + 1;
        });
    });


    data.postln;
    "\n".postln;
    // d;
    data;

};
);


~data = ~read_behr_csv.(~base_path +/+ ~data_path +/+ ~file_names[0]);
);

~data["Longitude"]
~data[0]
~data[1]
~data[2]
~data.[50]
~data.[5].size

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