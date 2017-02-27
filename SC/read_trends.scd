(
~location_types = ~make_filenames.(~trends_path);
~location_names = Array.newClear(~location_types.size);
~locations = Dictionary.new;

~location_types.size.do({|i|
    var loc_type = ~location_types[i];
    var locs = ~make_filenames.(~trends_path +/+ loc_type);
    ~location_names[i] = Dictionary.new;
    locs.size.do({|j|
        ~location_names[i][locs[j]] = CSVFileReader.read(~trends_path +/+ loc_type +/+ locs[j]);
    });
});

~location_types.do({|type, i|
    ~locations[type] = Dictionary.new;
    ~location_names[i].keys.do({|citynames|
        var cityname = citynames.replace("Trend.csv", "");
        var datasize = ~location_names[i][citynames].size-4;
        ~locations[type][cityname] = Dictionary.new;
        ~locations[type][cityname]["SiteName"] = ~location_names[i][citynames][0][1];
        ~locations[type][cityname]["SiteLongitude"] = ~location_names[i][citynames][1][1].asFloat;
        ~locations[type][cityname]["SiteLatitude"] = ~location_names[i][citynames][2][1].asFloat;
        ~locations[type][cityname]["StartDate"] = Array.newClear(datasize);
        ~locations[type][cityname]["EndDate"] = Array.newClear(datasize);
        ~locations[type][cityname]["BEHRNO2"] = Array.newClear(datasize);
        datasize.do({|j|
            var data = ~location_names[i][citynames][j+4];
            ~locations[type][cityname]["StartDate"][j] = data[0];
            ~locations[type][cityname]["EndDate"][j] = data[1];
            ~locations[type][cityname]["BEHRNO2"][j] = data[2];
        });

    });
});

"trend data successfully loaded".postln;
);

