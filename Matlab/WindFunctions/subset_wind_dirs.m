function [ windvel_sub, theta_sub, dnums_sub ] = subset_wind_dirs( windvel, theta, dnums, city_lon )
%SUBSET_WIND_DIRS Averages wind speed and directions for 3 hours prior to OMI overpass
%   [ WINDVEL_SUB, THETA_SUB, DNUMS_SUB ] = SUBSET_WIND_DIRS( WINDVEL,
%   THETA, DNUMS, CITY_LON ) This function will find all wind velocity
%   (WINDVEL) and direction (THETA) data points from 3 hours prior to OMI
%   overpass based on the date numbers (DNUMS) given, which must have date
%   and time components. This adjusts for the UTC time of overpass based on
%   CITY_LON.

% How many hours prior to OMI overpass we will average
hours2avg = 3;

% OMI overpass is approximately 1330-1400 local standard time. Estimate the
% UTC time that this corresponds to.
utc_offset = round(city_lon/15);
utc_overpass = 14 - utc_offset;

dnum_dates = floor(dnums);
dnums_sub = unique(dnum_dates);
dnum_hour = (dnums - dnum_dates)*24;

hh = dnum_hour >= utc_overpass - hours2avg & dnum_hour <= utc_overpass;

windvel_sub = nan(size(dnums_sub));
theta_sub = nan(size(dnums_sub));
for a=1:numel(dnums_sub)
    xx = dnum_dates == dnums_sub(a);
    windvel_sub(a) = nanmean(windvel(xx & hh));
    theta_sub(a) = angle_meand(theta(xx & hh));
end



end

