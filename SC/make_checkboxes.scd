
(
~pad = 5;
~checkBoxWidth = 120;
~checkBoxHeight = 12;

);

({
var topOfTypeBoxes = ~mapHeight + ~pad;
var xPos = ~pad;

~locations.keys.asArray.sort.do({|type|
	var cb = CheckBox.new(w, Rect(xPos,topOfTypeBoxes,~checkBoxWidth,~checkBoxHeight));
	cb.string = type;
	xPos = xPos + ~checkBoxWidth + ~pad;
});
}.value;

);

({
var topOfLocBoxes = ~mapHeight + ~checkBoxHeight + (3*~pad);
var xPos = ~pad;
var yPos = topOfLocBoxes;

~locations.keys.asArray.sort.do({|type|
	~locations[type].keys.asArray.sort.do({|loc|
		var cb = CheckBox.new(w, Rect(xPos,yPos,~checkBoxWidth,~checkBoxHeight));
		cb.string = loc;

		if((yPos+~pad+~checkBoxHeight+~pad)> w.bounds.height, {
			yPos = topOfLocBoxes;
			xPos = xPos + ~checkBoxWidth + ~pad;
		}, {
			yPos = yPos + ~checkBoxHeight + ~pad;

		});
	});
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
// 			yPos = yPos + ~checkBoxHeight + ~pad;
// 		});
//
// 		yPos = topOfLocBoxes;
// 		xPos = xPos + ~checkBoxWidth + ~pad;
// 	});
// }.value;
//
// );