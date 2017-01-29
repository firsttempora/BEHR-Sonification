~base_path = "/Users/kermit/Documents/behr_sonification/BEHR-Sonification/";
~data_path = "data/";

thisProcess.interpreter.executeFile(~base_path+/+"SC/read_behr_csv.scd");
~file_names = ~make_filenames.(~base_path+/+~data_path);

~data = ~read_behr_csv.(~base_path +/+ ~data_path +/+ ~file_names[0]);

