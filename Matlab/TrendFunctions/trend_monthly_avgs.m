function [  ] = trend_monthly_avgs( start_date, end_date )
%TREND_MONTHLY_AVGS Compute monthly NO2 averages between start and end date

savedir = fullfile(repo_data_dir, 'intermediate_data');
curr_dnum = datenum(start_date);
end_dnum = datenum(end_date);
while curr_dnum < end_dnum
    yr = year(curr_dnum);
    mn = month(curr_dnum);
    d1 = sprintf('%04d-%02d-01', yr, mn);
    d2 = sprintf('%04d-%02d-%02d', yr, mn, eomday(yr, mn));
    fprintf('Averaging %s to %s\n', d1, d2);
    [~, NO2_GRID, LON_GRID, LAT_GRID] = no2_column_map_2014(d1, d2, [-125 -65], [25 50],...
        'clouds','omi','cloudfraccrit',0.2,'rowanomaly','XTrackFlags','rows',[1 58], 'makefig',false);
    
    savename = fullfile(savedir, sprintf('BEHR_AVG_%s_%s-%s.mat', BEHR_version, d1, d2));
    fprintf('Saving %s\n', savename);
    save(savename, 'NO2_GRID', 'LON_GRID', 'LAT_GRID');
    
    curr_dnum = datenum(d2) + 1; % end of month day + 1 = next month
end

end

