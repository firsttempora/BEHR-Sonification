function [  ] = wind_driver(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

city = 'StLouis';

% Find .mat file with the city name in its name. Generate with
% calc_city_wind_dir
data_dir = fullfile(repo_data_dir, 'intermediate_data');
F = dir(fullfile(data_dir, sprintf('*%s*',city)));
if numel(F) < 1
    error('behr_sonification:file_not_found','Wind .mat file for %s not found',city);
elseif numel(F) > 1
    error('behr_sonification:ambiguous_file','Multiple wind .mat files for %s found',city);
end

W = load(fullfile(data_dir, F));
[windvel, theta, dnums] = subset_wind_dirs(W.windvel, W.theta, W.dnums, W.city_lon);
write_wind_csv(windvel, theta, dnums, sprintf('%s-winds.csv',city));

end

