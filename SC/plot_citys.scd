// this should probably be converted into a function that takes a user view, clears it, and draws the cities on top of it
// also, should have a way of designating which locations are active in the sonification or not

(
/* sets up a view over the map, draws dots where the various locations are */
~cityView = UserView(w, Rect(0, 0, ~mapWidth, ~mapHeight));
~cityView.drawFunc = { |vv|
	~locations.keys.do({|type|
		case
		{type == "PowerPlants"} {
			Pen.fillColor = Color.new255(238, 106, 80).alpha_(0.5);
			Pen.strokeColor = Color.black;
		}
		{type == "Cities"} {
			Pen.fillColor = Color.new255(205, 201, 165).alpha_(0.5);
			Pen.strokeColor = Color.red;
		};

		~locations[type].keys.do({|loc|
			var lon = ~locations[type][loc]["SiteLongitude"];
			var lat = ~locations[type][loc]["SiteLatitude"];
			var cityCenter = (lon.linlin(~lonMin, ~lonMax, 0, ~mapWidth))@((lat.linlin(~latMin, ~latMax, 0,~mapHeight))*(-1)+~mapHeight);

			Pen.addOval(Rect.fromPoints(cityCenter+~cityRadius, cityCenter-~cityRadius));
		});
		Pen.fillStroke;
	});
};
);



(
/* sets up a user view, centered over each location dot */
~locsViews = Array.newClear(~locations.size);
~locations.keys.asArray.sort.do({|type, i|
	~locsViews[i] = Array.newClear(~locations[type].size);
	~locations[type].keys.asArray.sort.do({|loc, j|
		var lon = ~locations[type][loc]["SiteLongitude"];
		var lat = ~locations[type][loc]["SiteLatitude"];
		var cityCenter = (lon.linlin(~lonMin, ~lonMax, 0, ~mapWidth))@((lat.linlin(~latMin, ~latMax, 0,~mapHeight))*(-1)+~mapHeight);
		~locsViews[i][j] = UserView(w, Rect.fromPoints(cityCenter+~cityRadius, cityCenter-~cityRadius));
	});
});
);

(
/* function to mark a city that is supposed to play, and clear a city that is not supposed to play */
~markStatus = {|locView, status|
	if(status, {
		locView.drawFunc = { |vv|
			var center = (locView.bounds.width/2)@(locView.bounds.height/2);
			var radius = ((locView.bounds.width + locView.bounds.height)/2) * 0.3;
			Pen.fillColor = Color.black;
			Pen.strokeColor = Color.black;
			Rect.fromPoints(center+radius, center-radius).postln;
			Pen.addOval(Rect.fromPoints(center+radius, center-radius));
			Pen.fillStroke;
		};
	}, {
		locView.drawFunc = {};
	});
	locView.refresh;
};

);





