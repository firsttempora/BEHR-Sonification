(
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
