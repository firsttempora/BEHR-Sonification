(
// options dictionary used to control the task
~taskOpts = Dictionary.newFrom(["delay",0.3,"normType","global","doLoop",true,
    "playNO2",true,"playO3",true,"updateGUI",true, "synthName",\spectrum_pan2]);

// init synth arrays
~no2SynthsArr = ~init_play_array.(~locations, {Synth.newPaused(~taskOpts["synthName"], [\freq, 100, \amp, 0.01])});
~o3SynthsArr = ~init_play_array.(~locations, {Synth.newPaused(~taskOpts["synthName"], [\freq, 100, \amp, 0.01])});

// other persistent arrays
~locsSelected = ~init_play_array.(~locations, {false});

~mainTask = Task.new({~task_driver_func.(~locations, ~locsSelected, ~site_stats, ~category_stats, ~global_stats, ~no2SynthsArr, ~o3SynthsArr, ~taskOpts)});
)

/*
* start/stop the task
~mainTask.reset

~mainTask.play
~mainTask.stop

* modify the behavior of the synths
~locsSelected[0][1] = true
~locsSelected[2][14] = true
~taskOpts["playO3"] = true
~taskOpts["delay"]=0.5
~taskOpts["normType"]="local"
*/