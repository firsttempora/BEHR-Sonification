(
// read the state line data
~sl = CSVFileReader.read(~state_lines_path);
// cast it as float, and remove the text heading
~sl = ~sl[1..].asFloat;

// get the lons and lats into variables
~lon = Array.newClear(~sl.size);
~lat = Array.newClear(~sl.size);
~sl.size.do({|i|
	~lon[i] = ~sl[i][0];
	~lat[i] = ~sl[i][1];
});

// min the min/max of those, so we can normalize when plotting
~lonMin = ~lon.minItem;
~lonMax = ~lon.maxItem;
~latMin = ~lat.minItem;
~latMax = ~lat.maxItem;
~lon2latRatio = (~lonMax-~lonMin)/(~latMax-~latMin);

w = Window("BEHR Sonification", Rect(Window.screenBounds.width/2-250, Window.screenBounds.height, 500, 750));
w.onClose = ({if(~cityView.notNil, {~cityView = nil;});});

~mapWidth = w.bounds.width;
~mapHeight = ~mapWidth/~lon2latRatio;
~cityRadius = 5;

~mapView = UserView(w, Rect(0, 0, ~mapWidth, ~mapHeight));
~mapView.background = Color.new255(160, 160, 160);

~mapView.drawFunc = { |vv|
	Pen.fillColor = Color.clear;
    Pen.strokeColor = Color.black;
	(~sl.size-1).do({|i|
		if((~lon[i]+~lon[i+1]).isNaN.not, {
			Pen.line(
				(~lon[i].linlin(~lonMin, ~lonMax, 0, ~mapWidth))@((~lat[i].linlin(~latMin, ~latMax, 0,~mapHeight))*(-1)+~mapHeight),
				(~lon[i+1].linlin(~lonMin, ~lonMax, 0, ~mapWidth))@((~lat[i+1].linlin(~latMin, ~latMax, 0,~mapHeight))*(-1)+~mapHeight)
			);
		});
	});
	Pen.fillStroke;
};

);
