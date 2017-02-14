(
var sb = Window.screenBounds;
w = Window.new("BEHR Error Sonification", Rect(sb.width/2-250,sb.height/2-150,500,300)).front;
w.onClose = {s.freeAll; /*CmdPeriod.run*/};
// QtGUI.palette = QPalette.dark;

~margin = 20;
~pad = 10;
~height = 20;
~buttonWidth = 80;
~sliderWidth = 250;

~sliderW = 120;
~numberW = 40;
~labelW = 80;

// ~testLabel = StaticText(w,
// Rect(~margin, ~margin+~pad+~height, ~labelW, ~height));
// ~testLabel.string = "this is a label";
// ~testSlider = Slider(w,
// Rect(~margin+~labelW+~pad, ~margin+~pad+~height, ~sliderW, ~height));
// ~testNumber = NumberBox(w,
// Rect(~margin+~labelW+~sliderW+(2*~pad), ~margin+~pad+~height, ~numberW, ~height));
//






~playPauseButton = Button(w,
    Rect(w.bounds.width - ~margin - ~buttonWidth, ~margin, ~buttonWidth, ~height))
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

~speedSlider = EZSlider(w,
    Rect(~margin, ~margin, ~sliderWidth, ~height),
    "speed",
    ControlSpec(0,1,'lin',0.01,0.25,''),
    {|v|},
    nil,
    true,
    100,
    35,
    0,
    20
);


~balanceSlider = EZSlider(w,
    Rect(~margin, ~margin+(~pad)+(~height), ~sliderWidth, ~height),
    "weights/profile",
    ControlSpec(0,1,'lin',0.01,0.5,''),
    {|v|},
    nil,
    true,
    100,
    35,
    0,
    20
);

~radiusSlider = EZSlider(w,
    Rect(~margin, ~margin+(2*(~pad+~height)), ~sliderWidth, ~height),
    "radius",
    ControlSpec(0,1,'lin',0.01,0.5,'thing'),
    {|v|
        ~setDrawCircleVis.(~radiusSlider.value, ~thetaSlider.value, ~circleVis);
    },
    nil,
    true,
    100,
    35,
    0,
    20
);

~thetaSlider = EZSlider(w,
    Rect(~margin, ~margin+(3*(~pad+~height)), ~sliderWidth, ~height),
    "angle",
    ControlSpec(-2*pi,0,'lin',0.01,pi,'thing'),
    {|v|
        ~setDrawCircleVis.(~radiusSlider.value, ~thetaSlider.value, ~circleVis);
    },
    nil,
    true,
    100,
    35,
    0,
    20
);

~prevDayButton = Button(w,
    Rect(~margin, ~margin+(4*(~pad+~height)), ~buttonWidth, ~height))
    .states_([["previous day"]])
    .action_();


~nextDayButton = Button(w,
Rect(~margin+~sliderWidth-~buttonWidth, ~margin+(4*(~pad+~height)), ~buttonWidth, ~height))
.states_([["next day"]])
.action_();


~dayField = StaticText(w,
Rect(~margin+(~sliderWidth/2)-(~buttonWidth/2), ~margin+(4*(~pad+~height)), ~buttonWidth, ~height));
~dayField.string = Date.getDate.format("%Y-%d-%e");
~dayField.align = \center;




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
    Rect(~margin+~sliderWidth+~pad, ~margin+~pad+~height, 200, 200));
~circleVis.background = Color.new255(230,230,230);
~setDrawCircleVis.(~radiusSlider.value, ~thetaSlider.value, ~circleVis);

);



