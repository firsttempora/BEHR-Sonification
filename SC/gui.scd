(
var sb = Window.screenBounds;
w = Window.new("BEHR Error Sonification", Rect(sb.width/2-250,sb.height/2-100,500,250)).front;
w.onClose = {s.freeAll; /*CmdPeriod.run*/};
// QtGUI.palette = QPalette.dark;

~margin = 20;
~pad = 10;
~height = 20;
~buttonWidth = 80;

~labelWidth = 70;
~numberBoxWidth = 35;
~sliderWidth = 160;
~leftColWidth = ~labelWidth+~numberBoxWidth+~sliderWidth+(2*~pad);

~viewWidth = w.bounds.width - (2*~margin) - ~leftColWidth - ~pad;
~viewHeight = ~viewWidth;


// play pause button
~playPauseButton = Button(w,
    Rect(~margin, ~margin, ~leftColWidth, ~height))
    .states_([["play"],["pause"]])
    .action_({|button|
    if(button.value == 0, {
        // pause task
        // pause synths
        "paused".postln;
    }, {
        //start task
        //play task
        "playing".postln;
    });
});

// speed slider
~speedLabel = StaticText(w,
	Rect(~margin, ~margin+~pad+~height, ~labelWidth, ~height));
~speedLabel.string = "speed";
~speedSpec = ControlSpec(0,5,\linear, 0.01);
~speedSlider = Slider(w,
	Rect(~margin+~pad+~labelWidth, ~margin+~pad+~height, ~sliderWidth, ~height))
    .action_({|v|
	    ~speedNumber.value = ~speedSpec.map(~speedSlider.value);
    });
~speedNumber = NumberBox(w,
	Rect(~margin+~labelWidth+~sliderWidth+(2*~pad), ~margin+~pad+~height, ~numberBoxWidth, ~height));
~speedSlider.valueAction = ~speedSpec.unmap(1);

// balance slider
~balanceLabel = StaticText(w,
	Rect(~margin, ~margin+(2*~pad)+(2*~height), ~labelWidth, ~height));
~balanceLabel.string = "balance";
~balanceSpec = ControlSpec(0,1,\linear, 0.01);
~balanceSlider = Slider(w,
	Rect(~margin+~pad+~labelWidth, ~margin+(2*~pad)+(2*~height), ~sliderWidth, ~height))
    .action_({|v|
	    ~balanceNumber.value = ~balanceSpec.map(~balanceSlider.value);
    });
~balanceNumber = NumberBox(w,
	Rect(~margin+~labelWidth+~sliderWidth+(2*~pad), ~margin+(2*~pad)+(2*~height), ~numberBoxWidth, ~height));
~balanceSlider.valueAction = ~balanceSpec.unmap(0.5);

// radius slider
~radiusLabel = StaticText(w,
	Rect(~margin, ~margin+(3*~pad)+(3*~height), ~labelWidth, ~height));
~radiusLabel.string = "radius";
~radiusSpec = ControlSpec(0,1,\linear, 0.01);
~radiusSlider = Slider(w,
	Rect(~margin+~pad+~labelWidth, ~margin+(3*~pad)+(3*~height), ~sliderWidth, ~height))
    .action_({|v|
	    ~radiusNumber.value = ~radiusSpec.map(~radiusSlider.value);
	    ~setDrawCircleVis.(~radiusNumber.value, ~thetaNumber.value, ~circleVis);
    });
~radiusNumber = NumberBox(w,
	Rect(~margin+~labelWidth+~sliderWidth+(2*~pad), ~margin+(3*~pad)+(3*~height), ~numberBoxWidth, ~height));
~radiusSlider.valueAction = ~radiusSpec.unmap(0.5);

// theta slider
~thetaLabel = StaticText(w,
	Rect(~margin, ~margin+(4*~pad)+(4*~height), ~labelWidth, ~height));
~thetaLabel.string = "angle";
~thetaSpec = ControlSpec(-2*pi,0,\linear, 0.01);
~thetaSlider = Slider(w,
	Rect(~margin+~pad+~labelWidth, ~margin+(4*~pad)+(4*~height), ~sliderWidth, ~height))
    .action_({|v|
	    ~thetaNumber.value = ~thetaSpec.map(~thetaSlider.value);
	    ~setDrawCircleVis.(~radiusNumber.value, ~thetaNumber.value, ~circleVis);
    });
~thetaNumber = NumberBox(w,
	Rect(~margin+~labelWidth+~sliderWidth+(2*~pad), ~margin+(4*~pad)+(4*~height), ~numberBoxWidth, ~height));
~thetaSlider.valueAction = ~thetaSpec.unmap(pi);

// move through day controls
~prevDayButton = Button(w,
	Rect(~margin, ~margin+(5*~pad)+(5*~height), ~leftColWidth/3-~pad, ~height))
    .states_([["previous"]])
    .action_();

~nextDayButton = Button(w,
	Rect(~margin+(~leftColWidth/3*2)+(~pad), ~margin+(5*~pad)+(5*~height), ~leftColWidth/3-~pad, ~height))
    .states_([["next"]])
    .action_();

~dayField = StaticText(w,
	Rect(~margin+(~leftColWidth/3)+(~pad), ~margin+(5*~pad)+(5*~height), ~leftColWidth/3-~pad, ~height));
~dayField.string = Date.getDate.format("%Y-%d-%e");
~dayField.align = \center;

// write some extra info?
~windInfoField = StaticText(w,
	Rect(~margin, ~margin+(6*~pad)+(6*~height), ~leftColWidth, ~height));
~windInfoField.string = "wind speed: 10mph, wind direction: NNW";

~setDrawCircleVis = {|radius, theta, view|
    var pixelScale = 150;
    var middleDotRadius = 2.5;
    var endDotRadius = 5;

    view.drawFunc = {|vv|
        var center = (view.bounds.width/2)@(view.bounds.height/2);
        var pointOnCircle = (radius*pixelScale/2*cos(theta)+center.x)@(radius*pixelScale/2*sin(theta)+center.y);

        // draw the outer circle (radius wide)
        Pen.fillColor = Color.white;
        Pen.strokeColor = Color.red;
        Pen.addOval(Rect.fromPoints(center-(pixelScale*radius/2), center+(pixelScale*radius/2)));

        // draw the line (in the theta direction)
        Pen.line(center, pointOnCircle);
        Pen.fillStroke;

        // draw the doo hicky on the end of the line
        Pen.fillColor = Color.black;
        Pen.addOval(Rect.fromPoints(pointOnCircle-endDotRadius, pointOnCircle+endDotRadius));
        // draw the dot in the center
        Pen.addOval(Rect.fromPoints(center-middleDotRadius, center+middleDotRadius));
        Pen.fillStroke;
    };
    view.refresh;
};

~circleVis = UserView(w,
    Rect(~margin+~leftColWidth+~pad, ~margin, ~viewHeight, ~viewWidth));
~circleVis.background = Color.new255(230,230,230);
~setDrawCircleVis.(~radiusNumber.value, ~thetaNumber.value, ~circleVis);


);


