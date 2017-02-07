~data[0].keys.asArray.sort.do{|k|k.postln;};
~data[0]["r"]
~data[0]["theta"]


(
~data.size.do({|i|
    var temp = ~findCellOfAbsMin.(~data[i]["theta"]);
    if(temp == [2,5], {
        [-1,0,1].do({|j|
            [-1,0,1].do({|k|
                ~data[i]["theta"][2+j,5+k].postln;
            });
        });
    });
    // ~data[i]["theta"][temp[0], temp[1]].postln;
});


);

