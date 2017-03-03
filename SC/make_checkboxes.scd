(
~pad = 5;
~checkBoxWidth = 180;
~checkBoxHeight = 15;
~checkBoxViewWidth = w.bounds.width;
~checkBoxViewHeight = 200;

);

(/* write the city/powerplant etc labels into GUI */
{
var xPos = ~pad;

~locations.keys.asArray.sort.do({|type|
	var str = StaticText.new(w, Rect(xPos,~mapHeight+~pad,~checkBoxWidth,~checkBoxHeight));
	str.string = type;
	str.align = \center;
	xPos = xPos + ~checkBoxWidth + ~pad;
});
}.value;

);

// a view to hold checkboxes
~checkBoxView = ScrollView(w, Rect(0, ~mapHeight + ~checkBoxHeight + (2*~pad), ~checkBoxViewWidth, ~checkBoxViewHeight));


(/* make the location checkboxes */
{
	var topOfLocBoxes = 0;
	var xPos = ~pad;
	var yPos = topOfLocBoxes;

	~locations.keys.asArray.sort.do({|type, i|
		~locations[type].keys.asArray.sort.do({|loc, j|
			var cb = CheckBox.new(~checkBoxView, Rect(xPos,yPos,~checkBoxWidth,~checkBoxHeight));
            cb.string = ~locations[type][loc]["ShortName"];
			cb.action = {
				~locsSelected[i][j] = cb.value;
				~markStatus.(~locsViews[i][j], cb.value);
			};
			yPos = yPos + ~checkBoxHeight + ~pad;
		});

		yPos = topOfLocBoxes;
		xPos = xPos + ~checkBoxWidth + ~pad;
	});
}.value;

);
