
(
/* ~loc2polar: takes a location dictionary and uses the latitude and longitude
 * (and the global variables holding the max/min lon/lat values) in order to
 * compute the lat/long as a cartesian, normalized city center. This is then
 * converted to polar, and the magnitude is normalized by sqrt(2) such that the
 * point 1@1 has polar magnitude 1
 */
~loc2polar = {|loc|
	var lon = loc["SiteLongitude"];
	var lat = loc["SiteLatitude"];
	var cityCenter = (lon.linlin(~lonMin, ~lonMax, 0, 1))@(1-(lat.linlin(~latMin, ~latMax, 0,1)));
	cityCenter = cityCenter.asPolar;
	cityCenter.rho = cityCenter.rho / sqrt(2);
	cityCenter;
};


/* takes a location and computes a values (-1,1) to pan based on longitude in the stereo field */
~loc2PanStereo = {|loc|
	var lon = loc["SiteLongitude"];
	lon = lon.linlin(~lonMin, ~lonMax, -1, 1);
	lon.postln;
	lon;
};
);
