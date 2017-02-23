function [ no2, date_start, date_end ] = generate_no2_trends( lon, lat, radius )
%GENERATE_NO2_TRENDS Extract NO2 trends from BEHR_AVG files
%   [ NO2, DATE_START, DATE_END ] = GENERATE_NO2_TRENDS( LON, LAT, RADIUS )
%   loads all BEHR_AVG files in turn and finds the grid cells centered on
%   LON and LAT that fall within RADIUS (in kilometers). Returns the
%   average NO2 column from those grid cells in the vector NO2 and the
%   beginning and end date for each averaging period in DATE_START and
%   DATE_END.

data_dir = fullfile(repo_data_dir,'intermediate_data');
F = dir(fullfile(data_dir,'BEHR_AVG*'));

% Load the first average file and use it to find the relevant grid cells
D = load(fullfile(data_dir, F(1).name));

% First cut down the grid points to test by finding entire rows and columns
% that are definitely too far away
xx = calc_dist(D.LON_GRID(1,:), lat, lon, lat) < radius * 1.5;
yy = calc_dist(lon, D.LAT_GRID(:,1), lon, lat) < radius * 1.5;

in = false(size(D.NO2_GRID));
dist = calc_dist(D.LON_GRID(yy,xx), D.LAT_GRID(yy,xx), lon, lat);
sub_in = dist <= radius;

in(yy,xx) = sub_in;

no2 = nan(size(F));
date_start = cell(size(F));
date_end = cell(size(F));
for a=1:numel(F)
    D = load(fullfile(data_dir, F(a).name));
    dates = regexp(F(a).name, '\d\d\d\d-\d\d-\d\d','match');
    
    no2(a) = nanmean(D.NO2_GRID(in));
    date_start(a) = dates(1);
    date_end(a) = dates(2);
end
end

function dist = calc_dist(lonq, latq, lonc, latc)
if isscalar(lonq)
    lonq = repmat(lonq, size(latq));
end
if isscalar(latq)
    latq = repmat(latq, size(lonq));
end

dist = nan(size(lonq));
for a=1:numel(dist)
    dist(a) = m_lldist([lonq(a), lonc], [latq(a), latc]);
end

end