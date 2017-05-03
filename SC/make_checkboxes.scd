(
~pad = 5;
~checkBoxWidth = w.bounds.width/3.0 - (4*~pad);
~checkBoxHeight = 15;
~checkBoxViewWidth = w.bounds.width;
~checkBoxViewHeight = 200;

);

(
/* Define helper function that will be used to set an entire category active or inactive */
~set_category_status = {|cbArray, val|
	cbArray.do({|cb|
		cb.valueAction_(val);
	});
};
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
~checkBoxView = ScrollView(w, Rect(0, ~mapHeight + (2*~checkBoxHeight) + (3*~pad), ~checkBoxViewWidth, ~checkBoxViewHeight));


(/* make the location checkboxes, then go back and make the all on/all off buttons */
~checkBoxDict = Dictionary.new;
{
	var topOfLocBoxes = 0;
	var xPos = ~pad;
	var yPos = topOfLocBoxes;
	var cbArray;

	~locations.keys.asArray.sort.do({|type, i|
		cbArray = Array.newClear(~locations[type].size);
		~locations[type].keys.asArray.sort.do({|loc, j|
			var cb = CheckBox.new(~checkBoxView, Rect(xPos,yPos,~checkBoxWidth,~checkBoxHeight));
            cb.string = ~locations[type][loc]["ShortName"];
			cb.action = {
				~locsSelected[i][j] = cb.value;
				~markStatus.(~locsViews[i][j], cb.value);
			};
			yPos = yPos + ~checkBoxHeight + ~pad;
			cbArray[j] = cb;
		});

		yPos = topOfLocBoxes;
		xPos = xPos + ~checkBoxWidth + ~pad;
		~checkBoxDict[type] = cbArray;
	});
}.value;

/* finally, now that we have the array of checkboxes, make the category on/off buttons */
{
	var xPos = ~pad;
	var yPos = ~mapHeight + ~checkBoxHeight + ~pad;
	var buttonWidth = ~checkBoxWidth / 2.0;
	~locations.keys.asArray.sort.do({|type|
		Button.new(w, Rect(xPos, yPos, buttonWidth, ~checkBoxHeight)).states_([["All On"]]).action_({~set_category_status.(~checkBoxDict[type], true)});
		Button.new(w, Rect(xPos+buttonWidth, yPos, buttonWidth, ~checkBoxHeight)).states_([["All Off"]]).action_({~set_category_status.(~checkBoxDict[type], false)});
		xPos = xPos + (2*buttonWidth) + ~pad;
	});
}.value;

);
