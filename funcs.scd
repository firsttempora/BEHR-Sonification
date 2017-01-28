~path = "/user/k/kermit/Downloads/BEHRWebTools/data/OMI_BEHR_v2-1B_20050101.txt";

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