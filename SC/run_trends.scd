~base_path = "/user/k/kermit/Documents/behr/BEHR-Sonification/";
//~base_path = "/Users/kermit/Documents/behr_sonification/BEHR-Sonification/";
//~base_path = "/home/josh/Dropbox/Supercollider/BEHR-Sonification";

~state_lines_path = ~base_path +/+ "data/geo_data/state_lines.csv";
~trends_path = ~base_path +/+ "data/trend_data/";


thisProcess.interpreter.executeFile(~base_path+/+"SC/funcs.scd");

thisProcess.interpreter.executeFile(~base_path+/+"SC/read_trends.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/trend_statistics.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/loc2polar.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/read_state_lines.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/plot_citys.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/make_checkboxes.scd");



(
s.waitForBoot(
    thisProcess.interpreter.executeFile(~base_path+/+"SC/synths.scd");
);
);

(
~numChans = 2;
~timeInverval = 0.2;
~f0 = 60;
);
