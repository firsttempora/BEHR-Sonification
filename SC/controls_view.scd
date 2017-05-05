(

~controlsViewWidth = w.bounds.width;
~controlsViewHeight = 250;

// ~controlsViewLeftBound = 0;
// this is a hack right now; it centers the controls column in case we don't add a right column
~controlsViewLeftBound = (w.bounds.width/2.0) - 143;

~controlsView =  UserView(w, Rect(~controlsViewLeftBound,
	~mapHeight + (2*~checkBoxHeight) + ~checkBoxViewHeight + (4*~pad),
	~controlsViewWidth, ~controlsViewHeight)
);


~height = 20;
~buttonWidth = 80;
~labelWidth = 80;
~smallButWidth = 55;
~numberBoxWidth = 35;
~sliderWidth = 160;
~leftColWidth = ~labelWidth+~numberBoxWidth+~sliderWidth+(2*~pad);


// play pause button
~playPauseButton = Button(~controlsView,
    Rect(~pad, 0, ~buttonWidth, ~height))
    .states_([["play"],["pause"]])
    .action_({|button|
    if(button.value == 0, {
        if(~mainTask.notNil, {~mainTask.stop});
        "paused".postln;
    }, {
			if(~mainTask.notNil, {~taskOpts["oneStep"] = false; ~mainTask.play});
			if(~muteButton.notNil, {~muteButton.valueAction_(1)});
        "playing".postln;
    });
});

// mute/unmute button
~muteButton = Button(~controlsView,
	Rect((2*~pad)+~buttonWidth, 0, ~buttonWidth, ~height))
.states_([["muted"],["unmuted"]])
.action_({|button|
	~mute_unmute_synths.(button.value, ~no2SynthsArr, ~o3SynthsArr)
});



// loop on / off
~loopButton = Button(~controlsView,
    Rect((2*~buttonWidth)+(3*~pad), 0, ~buttonWidth, ~height))
    .states_([["no loop"],["loop"]])
    .action_({|button|
    if(button.value == 0, {
        //~loop = false;
        if(~taskOpts.notNil, {~taskOpts["doLoop"] = false;});
        "not looping".postln;
    }, {
        // ~loop = true;
        if(~taskOpts.notNil, {~taskOpts["doLoop"] = true;});
        "looping".postln;
    });
});

// speed slider
~speedLabel = StaticText(~controlsView,
	Rect(~pad, ~height+(~pad), ~labelWidth, ~height));
~speedLabel.string = "speed";
~speedSpec = ControlSpec(0.3,200,\linear, 0.1);
~speedSlider = Slider(~controlsView,
	Rect(~labelWidth+(2*~pad), ~height+(~pad), ~sliderWidth, ~height))
.action_({|v|
	~speedNumber.value = ~speedSpec.map(~speedSlider.value);
	//~timeInverval = ~speedNumber.value;
	if(~taskOpts.notNil, {~taskOpts["delay"] = 1.0/~speedNumber.value; ~taskOpts["delay"].postln;});
});
~speedNumber = NumberBox(~controlsView,
Rect(~labelWidth+~sliderWidth+(3*~pad), ~height+(~pad), ~numberBoxWidth, ~height))
.action_({|v| ~speedSlider.value = ~speedSpec.unmap(~speedNumber.value)});
~speedSlider.valueAction = ~speedSpec.unmap(1);

// time indicator (date)
~dateStart = StaticText(~controlsView,
    Rect(~pad, (3*~height)+(3*~pad), ~labelWidth, ~height));
~dateStart.string = ~locations["Cities"]["Tucson"]["StartDate"][0];

~dateCur = StaticText(~controlsView,
    Rect((~leftColWidth/2.0)-(~labelWidth/2.0), (3*~height)+(3*~pad), ~labelWidth, ~height));
~dateCur.string = ~locations["Cities"]["Tucson"]["StartDate"][0];
~dateCur.align = \center;

~dateEnd = StaticText(~controlsView,
    Rect(~leftColWidth-~labelWidth, (3*~height)+(3*~pad), ~labelWidth, ~height));
~dateEnd.string = ~locations["Cities"]["Tucson"]["EndDate"][~totalNumDataPts-1];
~dateEnd.align = \right;

// time indicator (slider)
~timeLabel = StaticText(~controlsView,
    Rect(~pad, (2*~height)+(2*~pad), ~labelWidth, ~height));
~timeLabel.string = "date";
~timeSpec = ControlSpec(0,~totalNumDataPts-1,\linear, 1);
~timeSlider = Slider(~controlsView,
	Rect(~labelWidth+(2*~pad), (2*~height)+(2*~pad), ~sliderWidth, ~height))
.action_({|v|
    ~dateCur.string = ~locations["Cities"]["Tucson"]["StartDate"][~timeSpec.map(~timeSlider.value)];
});
~timeSlider.valueAction = ~timeSpec.unmap(0);


// Time stepping controls
~rewindButton = Button(~controlsView,
	Rect(~pad, (4*~height)+(4*~pad), ~smallButWidth, ~height))
.states_([["<<"]])
.action_({~step_date_ind.(-1000, ~global_stats, ~mainTask, ~taskOpts);});

~backYearButton = Button(~controlsView,
	Rect((2*~pad)+~smallButWidth, (4*~height)+(4*~pad), ~smallButWidth, ~height))
.states_([["< 1 Yr"]])
.action_({~step_date_ind.(-12, ~global_stats, ~mainTask, ~taskOpts);});

~backMonthButton = Button(~controlsView,
	Rect((3*~pad)+(2*~smallButWidth), (4*~height)+(4*~pad), ~smallButWidth, ~height))
.states_([["< 1 Mn"]])
.action_({~step_date_ind.(-1, ~global_stats, ~mainTask, ~taskOpts);});

~forwardMonthButton = Button(~controlsView,
	Rect((4*~pad)+(3*~smallButWidth), (4*~height)+(4*~pad), ~smallButWidth, ~height))
.states_([["1 Mn >"]])
.action_({~step_date_ind.(1, ~global_stats, ~mainTask, ~taskOpts);});

~forwardYearButton = Button(~controlsView,
	Rect((5*~pad)+(4*~smallButWidth), (4*~height)+(4*~pad), ~smallButWidth, ~height))
.states_([["1 Yr >"]])
.action_({~step_date_ind.(12, ~global_stats, ~mainTask, ~taskOpts);});


// enable/disable no2
~no2Label = StaticText(~controlsView,
    Rect(~pad, (5*~height)+(5*~pad), ~labelWidth, ~height));
~no2Label.string = "NO_2";
~no2CheckBox = CheckBox.new(~controlsView,
    Rect((~labelWidth/(3.0/2))+(2*~pad), (5*~height)+(5*~pad), ~labelWidth, ~height))
.action_({|v|
        if(~taskOpts.notNil, {~taskOpts["playNO2"] = ~no2CheckBox.value;});
});
~no2CheckBox.value = true;
~no2CheckBox.string = "(on/off)";


// enable/disable 03
~o3Label = StaticText(~controlsView,
    Rect(~leftColWidth/2.0, (5*~height)+(5*~pad), ~labelWidth, ~height));
~o3Label.string = "O_3";
~o3CheckBox = CheckBox.new(~controlsView,
    Rect((~leftColWidth/2.0)+(~labelWidth/(3.0/2))+(0*~pad), (5*~height)+(5*~pad), ~labelWidth, ~height))
.action_({|v|
        if(~taskOpts.notNil, {~taskOpts["playO3"] = ~o3CheckBox.value;});
});
~o3CheckBox.value = true;
~o3CheckBox.string = "(on/off)";


// season filter (on/off)
~seasonFilterLabel = StaticText(~controlsView,
    Rect(~pad, (6*~height)+(6*~pad), ~labelWidth, ~height));
~seasonFilterLabel.string = "season filter";
~seasonFilterCheckBox = CheckBox.new(~controlsView,
	Rect(~labelWidth+(2*~pad), (6*~height)+(6*~pad), ~labelWidth, ~height))
.action_({|v|
	if(~taskOpts.notNil,{~taskOpts["seasonFilter"] = ~seasonFilterCheckBox.value;});
});
~seasonFilterCheckBox.value = false;
~seasonFilterCheckBox.string = "(on/off)";

// city/power plant same sound or not
~synthesisSoundFilterLabel = StaticText(~controlsView,
    Rect(~pad, (7*~height)+(7*~pad), ~labelWidth, ~height));
~synthesisSoundFilterLabel.string = "synth sound";
~synthesisSoundFilterCheckBox = CheckBox.new(~controlsView,
	Rect(~labelWidth+(2*~pad), (7*~height)+(7*~pad), 3*~labelWidth, ~height))
.action_({|v|
        "not implemented".error;
});
~synthesisSoundFilterCheckBox.value = false;
~synthesisSoundFilterCheckBox.string = "(based on location type)";

// relative vs absolute mapping
// scale filter (on/off)
~scaleFilterLabel = StaticText(~controlsView,
	Rect(~pad, (8*~height)+(8*~pad), ~labelWidth, ~height));
~scaleFilterLabel.string = "Scaling";

~scaleFilterButton = Button(~controlsView,
	Rect((2*~pad)+~labelWidth, (8*~height)+(8*~pad), 3*~buttonWidth, ~height))
.states_([["absolute"],["relative to individual maximum"],["relative to category maximum"]])
.action_({|thisButton|
	if(~taskOpts.notNil,{
		switch(thisButton.value,
			0, {~taskOpts["normType"]="global"},
			1, {~taskOpts["normType"]="local"},
			2, {~taskOpts["normType"]="categorical"}
		);
	});
});

// panning (on/off)
~panningLabel = StaticText(~controlsView,
    Rect(~pad, (9*~height)+(9*~pad), ~labelWidth, ~height));
~panningLabel.string = "Panning";
~panningButton = Button.new(~controlsView,
	Rect(~labelWidth+(2*~pad), (9*~height)+(9*~pad), 3*~labelWidth, ~height))
.states_([["NO2: left, O3: right"], ["Site location"]])
.action_({|thisButton|
	if(~taskOpts.notNil,{
		switch(thisButton.value,
			0, {~taskOpts["pan"]="no2Left"},
			1, {~taskOpts["pan"]="siteLocation"},
		);
	});
});
);