(
// summarize no2 statistics
// eventually, this should be turned into a function
{
	var minNo2 = inf;
	var maxNo2 = -inf;
	var countNo2 = 0;
	var sumNo2 = 0;
	~locations.keys.do({|type|
		~locations[type].keys.do({|loc|
			~locations[type][loc]["BEHRNO2"].do({|no2val|
				if(isNaN(no2val).not, {
					if(no2val < minNo2, {minNo2 = no2val});
					if(no2val > maxNo2, {maxNo2 = no2val});
					countNo2 = countNo2 + 1;
					sumNo2 = sumNo2 + no2val;
				},{
					"found a nan in the data so far".warn;
				});
			});
		});
	});
	~no2Summary = Dictionary.new;
	~no2Summary["min"] = minNo2;
	~no2Summary["max"] = maxNo2;
	~no2Summary["avg"] = sumNo2 / countNo2.asFloat;
	~no2Summary["range"] = maxNo2 - minNo2;

}.value;
"summary computed".postln;
);