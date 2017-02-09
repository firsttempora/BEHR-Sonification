function [ windvel, theta, udnum_days, city_lon, city_lat ] = calc_city_wind_dir( city )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

switch city
    case 'Atlanta'
        city_lon = -84.39; city_lat = 33.775;
    case 'Birmingham'
        city_lon = -86.80; city_lat = 33.52;
    case 'Montgomery'
        city_lon = -86.3; city_lat = 32.37;
    case 'SF'
        city_lon = -122.42; city_lat = 37.77;
    case 'St. Louis'
        city_lon = -90.1994; city_lat = 38.9270;
    otherwise
        error('emg:city','City %s not recognized',city);
end

fpath = '/Volumes/share2/USERS/LaughnerJ/WRF/DC3/iccg_eq_2-fr_factor_1-mol_flash_500_newprof-fixedBC';
%fpath = '/media/josh/FreeAgent GoFlex Drive/WRF-DC3-Sonification';
F = dir(fullfile(fpath,'wrfout_subset*'));
dnums = [];
for a=1:numel(F)
    [s,e] = regexp(F(a).name, '\d\d\d\d-\d\d-\d\d_\d\d-\d\d-\d\d');
    dnums = cat(1,dnums, datenum(F(a).name(s:e),'yyyy-mm-dd_HH-MM-SS'));
end

dnum_days = floor(dnums);
udnum_days = unique(dnum_days);
% Because of memory concerns, we will only load the static variables
% (XLONG, XLAT, COSALPHA, and SINALPHA) once, then load each day's wind and
% go ahead and find the average wind for that day
[XLON, XLAT, COSALPHA, SINALPHA] = read_wrf_vars(fpath, F(1), {'XLONG', 'XLAT', 'COSALPHA', 'SINALPHA'}, false, 0);

windvel = nan(size(udnum_days));
theta = nan(size(udnum_days));
for a=1:numel(udnum_days)
    fprintf('Current date: %s:\n',datestr(udnum_days(a)));
    ff = subset_wrf_files(dnums, udnum_days(a), city_lon);
    if sum(ff) < 1
        continue
    end
    [U, V] = read_wrf_vars(fpath, F(ff), {'U', 'V'}, false, 0);
    
    % Lu 2015 used winds across the bottom 500 m or so
    Ubar = squeeze(nanmean(U(:,:,1:5,:),3));
    Vbar = squeeze(nanmean(V(:,:,1:5,:),3));
    [Ue, Ve] = wrf_winds_transform(Ubar, Vbar, COSALPHA, SINALPHA);
    
    [windvel_timevec, theta_timevec] = calc_avg_wind(XLON, XLAT, Ue, Ve, city_lon, city_lat);
    windvel(a) = nanmean(windvel_timevec);
    theta(a) = nanmean(theta_timevec);
end

end

function [windspd, winddir] = calc_avg_wind(xlon, xlat, U, V, clon, clat)
[xx1,yy1] = find_square_around(xlon, xlat, clon, clat, 1);
windspd = nan(1, size(U,3));
winddir = nan(1, size(U,3));
for a=1:size(U,3)
    Ubar = nanmean(reshape(U(xx1, yy1, a),[],1));
    Vbar = nanmean(reshape(V(xx1, yy1, a),[],1));
    windspd(a) = calc_wind_mag(Ubar, Vbar);
    winddir(a) = calc_wind_dir(Ubar, Vbar);
end
end

function mag = calc_wind_mag(U,V)
mag = (U.^2 + V.^2).^0.5;
end

function theta = calc_wind_dir(U,V)
theta = nan(size(U));
for b=1:numel(U)
    theta(b) = atan2d(V(b),U(b));
end
end

function [xx, yy] = find_square_around(lon, lat, center_lon, center_lat, radius)
% Finds indicies for a square of points centered on center_lon and
% center_lat. The square will have sides of length 2*radius + 1.
% Slicing lon/lat as lon(xx,yy), lat(xx,yy) will give the points.

% Check input
if ~ismatrix(lon)
    E.badinput('lon must be a 2-D array')
elseif ~ismatrix(lat)
    E.badinput('lat must be a 2-D array')
elseif ~all(size(lon) == size(lat))
    E.badinput('lon and lat must be the same size')
elseif ~isscalar(center_lat) || ~isnumeric(center_lat)
    E.badinput('center_lat must be a numeric scalar')
elseif ~isscalar(center_lon) || ~isnumeric(center_lon)
    E.badinput('center_lon must be a numeric scalar')
elseif ~isscalar(radius) || ~isnumeric(radius) || radius < 0 || mod(radius,1) ~= 0
    E.badinput('radius must be a positive scalar integer')
end

del = abs(lon - center_lon) + abs(lat - center_lat);
[~,I] = min(del(:));
[x,y] = ind2sub(size(del),I);
xx = (x-radius):(x+radius);
yy = (y-radius):(y+radius);
end

