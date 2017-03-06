(
var synth_name = 'spectrum_pan2';

// options dictionary used to control the task
~taskOpts = Dictionary.newFrom(["delay",5,"normType","global","doLoop",false,"playNO2",true,"playO3",true]);

// init synth arrays
~no2SynthsArr = ~init_play_array.(~locations, {Synth.newPaused(synth_name, [\freq, 100, \amp, 0.01])});
~o3SynthsArr = ~init_play_array.(~locations, {Synth.newPaused(synth_name, [\freq, 100, \amp, 0.01])});

// other persistent arrays
~locsSelected = ~init_play_array.(~locations, {false});

~mainTask = Task.new({~task_driver_func.(~locations, ~locsSelected, ~site_stats, ~global_stats, ~no2SynthsArr, ~o3SynthsArr, ~taskOpts)});
)

/*
* start/stop the task
~mainTask.play
~mainTask.stop

* modify the behavior of the synths
~locsSelected[0][1] = true
~locsSelected[2][14] = true
~taskOpts["playO3"] = true
~taskOpts["delay"]=0.5
~taskOpts["normType"]="local"
*/