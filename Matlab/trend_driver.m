function [ cities, plants ] = trend_driver( )
%TREND_DRIVER Drivers overall creation of trend files from BEHR_AVG files

%o3 = load_all_ozone();

cities = read_trend_loc_xls('Cities');
cities = make_loc_trend_files(cities, 'Cities');

plants = read_trend_loc_xls('PowerPlants');
plants = make_loc_trend_files(plants,'PowerPlants');

rural = read_trend_loc_xls('RuralAreas');
make_loc_trend_files(rural,'Rural');

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
    [o3_surf, o3_tvcd, dstart_o3, dend_o3] = generate_o3_trends(locs(a).ShortName);
    xx = o3_no2_inds_matchup(datenum(dstart), datenum(dend), datenum(dstart_o3), datenum(dend_o3));
    o3_surf = o3_surf(xx);
    o3_tvcd = o3_tvcd(xx);
    
    tmp_str = strrep(locs(a).ShortName,' ','');
    save_name = fullfile(save_dir, sprintf('%sTrend.csv',tmp_str));
    loc_name = strrep(locs(a).Location, ',','');
    write_trend_csv(save_name,loc_name,locs(a).ShortName,locs(a).Longitude,locs(a).Latitude,...
        'StartDate',dstart,'EndDate',dend,'BEHRNO2',no2,'O3_VMR',o3_surf,'O3_tVCD',o3_tvcd);
    
    locs(a).no2 = no2;
    locs(a).date_start = dstart;
    locs(a).date_end = dend;
end
end

function xx = o3_no2_inds_matchup(no2_dst, no2_dend, o3_dst, o3_dend)
xx = nan(size(no2_dst));
for a=1:numel(no2_dst)
    i = find(o3_dst == no2_dst(a) & o3_dend == no2_dend(a));
    if isempty(i)
        error('trend_driver:no_matching_o3','No O3 data for time period %s to %s', datestr(no2_dst,'yyyy-mm-dd'), datestr(no2_dend, 'yyyy-mm-dd'))
    end
    xx(a) = i;
end
end

% function o3 = load_all_ozone()
% F = fullfile(repo_data_dir,'intermediate_data','Ozone','OMO3PR*.mat');
% o3 = 
% end