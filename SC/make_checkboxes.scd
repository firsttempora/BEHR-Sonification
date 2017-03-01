(
~pad = 5;
~checkBoxWidth = 180;
~checkBoxHeight = 15;
~checkBoxViewWidth = w.bounds.width;
~checkBoxViewHeight = 200;

);

~checkBoxView = ScrollView(w, Rect(0, ~mapHeight + ~pad, ~checkBoxViewWidth, ~checkBoxViewHeight));


({
var xPos = ~pad;

~locations.keys.asArray.sort.do({|type|
	var cb = CheckBox.new(~checkBoxView, Rect(xPos,0,~checkBoxWidth,~checkBoxHeight));
	cb.string = type;
	xPos = xPos + ~checkBoxWidth + ~pad;
});
}.value;

);


({
	var topOfLocBoxes = ~checkBoxHeight + (2*~pad);
	var xPos = ~pad;
	var yPos = topOfLocBoxes;


	~locations.keys.asArray.sort.do({|type, i|
		~locations[type].keys.asArray.sort.do({|loc, j|
			var cb = CheckBox.new(~checkBoxView, Rect(xPos,yPos,~checkBoxWidth,~checkBoxHeight));
			cb.string = loc;
			cb.action = {
				~locsSelected[i][j] = cb.value;
			};
			yPos = yPos + ~checkBoxHeight + ~pad;
		});

		yPos = topOfLocBoxes;
		xPos = xPos + ~checkBoxWidth + ~pad;
	});
}.value;

);

// ({
// 	var topOfLocBoxes = ~mapHeight + ~checkBoxHeight + (3*~pad);
// 	var xPos = ~pad;
// 	var yPos = topOfLocBoxes;
//
// 	~locations.keys.asArray.sort.do({|type|
// 		~locations[type].keys.asArray.sort.do({|loc|
// 			var cb = CheckBox.new(w, Rect(xPos,yPos,~checkBoxWidth,~checkBoxHeight));
// 			cb.string = loc;
//
// 			if((yPos+~pad+~checkBoxHeight+~pad)> w.bounds.height, {
// 				yPos = topOfLocBoxes;
// 				xPos = xPos + ~checkBoxWidth + ~pad;
// 				}, {
// 					yPos = yPos + ~checkBoxHeight + ~pad;
//
// 			});
// 		});
// 	});
// }.value;
//
//);

