(

~controlsViewWidth = w.bounds.width;
~controlsViewHeight = 200;

~controlsView =  UserView(w, Rect(0, ~mapHeight + ~checkBoxHeight + ~checkBoxViewHeight + (3*~pad),
	~controlsViewWidth, ~controlsViewHeight)
);


~height = 20;
~buttonWidth = 80;
~labelWidth = 70;
~numberBoxWidth = 35;
~sliderWidth = 160;
~leftColWidth = ~labelWidth+~numberBoxWidth+~sliderWidth+(2*~pad);


// play pause button
~playPauseButton = Button(~controlsView,
    Rect(~pad, 0, ~leftColWidth, ~height))
    .states_([["play"],["pause"]])
    .action_({|button|
    if(button.value == 0, {
        //~t.pause;
        "paused".postln;
    }, {
        //~t.play;
        "playing".postln;
    });
});

// speed slider
~speedLabel = StaticText(~controlsView,
	Rect(~pad, ~height+(~pad), ~labelWidth, ~height));
~speedLabel.string = "speed";
~speedSpec = ControlSpec(0,3,\linear, 0.005);
~speedSlider = Slider(~controlsView,
	Rect(~labelWidth+(2*~pad), ~height+(~pad), ~sliderWidth, ~height))
.action_({|v|
	~speedNumber.value = ~speedSpec.map(~speedSlider.value);
	~timeInverval = ~speedNumber.value;
});
~speedNumber = NumberBox(~controlsView,
Rect(~labelWidth+~sliderWidth+(3*~pad), ~height+(~pad), ~numberBoxWidth, ~height));
~speedSlider.valueAction = ~speedSpec.unmap(1);



// time indicator

// loop on / off

// o3 and no2 checkboxes

// season filter on/off

// relative vs absolute mapping

// city/power plant same sound or not






);