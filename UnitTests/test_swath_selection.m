function [  ] = test_swath_selection( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
clon = -90;
clat = 35;

% Test 1: center lon/lat not in any swath
Data1 = construct_data([-89, -79; -101, -91], [25, 50; 25, 50]);
% Test 2: center lon/lat in second of three swaths
Data2 = construct_data([-84 -80; -92 -88; -100 -96], [25 50; 25 50; 25 50]);
% Test 3: center lon lat in middle of third swath, but also in second swath
Data3 = construct_data([-89 -85; -91 -87; -92 -88], [25 50; 25 50; 25 50]);

% You'll want to set breakpoints appropriately
behr_sub_array(Data1, clon, clat, 'all');
behr_sub_array(Data2, clon, clat, 'all');
behr_sub_array(Data3, clon, clat, 'all');

end

function Data = construct_data(lonlims, latlims)
for a=1:size(lonlims,1)
    lonvec = lonlims(a,1):0.2:lonlims(a,2);
    latvec = latlims(a,1):0.2:latlims(a,2);
    [lon,lat] = meshgrid(lonvec, latvec);
    Data(a).Longitude = lon;
    Data(a).Latitude = lat;
end
end