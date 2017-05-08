(
~base_path = Document.current.path.dirname +/+ ".."; // seems to require 3.7_
// ~base_path = "/home/josh/Dropbox/Supercollider/BEHR-Sonification";
// ~base_path = "/Users/kermit/Documents/behr_sonification/BEHR-Sonification/";


~state_lines_path = ~base_path +/+ "data/geo_data/state_lines.csv";
~trends_path = ~base_path +/+ "data/trend_data/";


thisProcess.interpreter.executeFile(~base_path+/+"SC/funcs.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/trend_data_funcs.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/play_funcs.scd");

thisProcess.interpreter.executeFile(~base_path+/+"SC/read_trends.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/trend_statistics.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/loc2polar.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/read_state_lines.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/plot_citys.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/make_checkboxes.scd");
thisProcess.interpreter.executeFile(~base_path+/+"SC/controls_view.scd");

~speakerConfig = "quad";
// ~speakerConfig = "stereo";

if(~speakerConfig == "stereo", {s.options.numOutputBusChannels = 2;});
if(~speakerConfig == "quad", {s.options.numOutputBusChannels = 4;});

(
s.waitForBoot(
    thisProcess.interpreter.executeFile(~base_path+/+"SC/synths.scd");
	{thisProcess.interpreter.executeFile(~base_path+/+"SC/play_main.scd")}.defer(1.5);
);
);

);