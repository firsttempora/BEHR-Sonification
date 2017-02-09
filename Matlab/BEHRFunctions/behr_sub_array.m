function [ Data_out ] = behr_sub_array( Data, center_lon, center_lat, cldtype, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% INPUT CHECKING %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
p = inputParser;
p.addParameter('subdims',[10 5]);
p.parse(varargin{:});
pout = p.Results;

sub_dims = pout.subdims;

if ~isstruct(Data) || any(~isfield(Data,{'Latitude','Longitude'}))
    error('behr_sonification:bad_input','DATA must be a structure with fields Latitude and Longitude')
elseif ~isnumeric(center_lon) || ~isscalar(center_lon) || center_lon < -125 || center_lon > -65
    error('behr_sonification:bad_input','CENTER_LON must be a scalar number between -125 and -65')
elseif ~isnumeric(center_lat) || ~isscalar(center_lat) || center_lat < 25 || center_lat > 50
    error('behr_sonification:bad_input','CENTER_LAT must be a scalar number between 25 and 50')
end

if ~isnumeric(sub_dims) || numel(sub_dims) ~= 2
    error('behr_sonification:bad_input','SUB_DIMS must be a two element numeric vector')
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% MAIN FUNCTION %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
switch cldtype
    case 'omi'
        cldfield = 'CloudFraction';
    case 'rad'
        cldfield = 'CloudRadianceFraction';
    case 'modis'
        cldfield = 'MODISCloud';
    otherwise
        error('behr_sonification:bad_input','%s is not an allowable cldtype.',cldtype);
end

earth = referenceEllipsoid('wgs84','km');
swath = find_best_swath(Data, center_lon, center_lat, earth);
if isempty(swath)
    error('behr_sonification:swath_assignment','Could not find a swath')
end
[x,y] = find_closest_pixel(Data(swath), center_lon, center_lat);
[xx,yy] = get_subarray_inds(size(Data(swath).Longitude), x, y, sub_dims);

variables = fieldnames(Data(swath));
for v=1:numel(variables)
    if ismatrix(Data(swath).(variables{v}))
        Data_out.(variables{v}) = Data(swath).(variables{v})(xx,yy);
    else
        Data_out.(variables{v}) = Data(swath).(variables{v})(:,xx,yy);
    end
end

Data_out.r = sqrt((Data_out.Longitude - center_lon).^2 + (Data_out.Latitude - center_lat).^2);
Data_out.theta = atan2d(Data_out.Latitude - center_lat, Data_out.Longitude - center_lon);

end

function fns = numeric_fields(Data)
fns = fieldnames(Data);
keep = true(size(fns));
for f=1:numel(fns)
    if ~isnumeric(Data(1).(fns{f}))
        keep(f) = false;
    end
end
fns = fns(keep);
end

function s = find_best_swath(Data, center_lon, center_lat, earth)
% Finds the swath where the given lon/lat is furthest from the swath edges
% and in the swath.

inds = 1:numel(Data);
swath_edges = nan(numel(Data),2);
for a=1:numel(Data)
    if any(isnan(Data(a).Latitude(:))) || any(isnan(Data(a).Longitude(:)))
        continue
    end
    west_lon = interp1(Data(a).Latitude(:,1), Data(a).Longitude(:,1), center_lat);
    east_lon = interp1(Data(a).Latitude(:,end), Data(a).Longitude(:,end), center_lat);
    swath_edges(a,:) = [west_lon, east_lon];
end

in = center_lon >= swath_edges(:,1) & center_lon <= swath_edges(:,2);
swath_edges = swath_edges(in,:);
inds = inds(in);

% If the center lat/lon is only in one swath, then we've found out swath.
% If it's not in ANY swath, return empty. Otherwise we have to test which
% swath it is furthest from the edge in.
if sum(in) <= 1
    s = inds;
    return
end

distances = nan(sum(in),1);
for a=1:sum(in)
    distances(a) = min(distance(center_lat, swath_edges(a,1), center_lat, center_lon, earth),...
        distance(center_lat, swath_edges(a,2), center_lat, center_lon, earth));
end
[~,m] = max(distances);
s = inds(m);

end

function [x,y] = find_closest_pixel(Data, center_lon, center_lat)
del = (Data.Longitude - center_lon).^2 + (Data.Latitude - center_lat).^2;
[~,m] = min(del(:));
[x,y] = ind2sub(size(Data.Longitude),m);
end

function [xx, yy] = get_subarray_inds(sz, x, y, dims)
dims_diff = ceil((dims - 1)/2);
xx = (x-dims_diff(1)):(x+dims_diff(1));
yy = (y-dims_diff(2)):(y+dims_diff(2));

if min(xx) < 1 || max(xx) > sz(1) || min(yy) < 1 || max(yy) > sz(2)
    % Can catch this error in calling function if we want to just skip the
    % day instead of crashing
    error('behr_sonification:swath_assignment','A %d x %d sub array goes out of bounds',dims(1),dims(2));
end
end