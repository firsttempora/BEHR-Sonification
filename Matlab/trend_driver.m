function [ cities, plants ] = trend_driver( )
%TREND_DRIVER Drivers overall creation of trend files from BEHR_AVG files


cities = read_trend_loc_xls('Cities');
cities = make_loc_trend_files(cities, 'Cities');

plants = read_trend_loc_xls('PowerPlants');
plants = make_loc_trend_files(plants,'PowerPlants');

%rural = read_trend_loc_xls('RuralAreas');
%make_loc_trend_files(rural,'Rural');

end

function locs = make_loc_trend_files(locs, data_subdir)
save_dir = fullfile(repo_data_dir, 'trend_data', data_subdir);
for a=1:numel(locs)
    % Quick check against misstypes
    if locs(a).Longitude < -125 || locs(a).Longitude > -65
        error('trend_driver:longitude', 'Longitude for %s outside of [-125 -65]', locs(a).Location);
    elseif locs(a).Latitude < 25 || locs(a).Latitude > 50
        error('trend_driver:latitude', 'Latitude for %s outside of [25 50]', locs(a).Location);
    end
    [no2, dstart, dend] = generate_no2_trends(locs(a).Longitude, locs(a).Latitude, locs(a).Radius);
    
    tmp_str = strsplit(locs(a).Location, ',');
    tmp_str = strrep(tmp_str{1},' ','');
    save_name = fullfile(save_dir, sprintf('%sTrend.csv',tmp_str));
    loc_name = strrep(locs(a).Location, ',','');
    write_trend_csv(save_name,loc_name,locs(a).Longitude,locs(a).Latitude,'StartDate',dstart,'EndDate',dend,'BEHRNO2',no2);
    
    locs(a).no2 = no2;
    locs(a).date_start = dstart;
    locs(a).date_end = dend;
end
end