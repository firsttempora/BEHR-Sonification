function [ locs ] = read_trend_loc_xls( sheet )
%READ_TREND_LOC_XLS Read specified sheet of the trend location XLSX file
%   LOCS = READ_TREND_LOC_XLS( SHEET ) Reads SHEET in trend_locations.xlsx
%   and returns LOCS, a structure with each location as an element and each
%   column in the xlsx file as a field. Note that sheet needs to be
%   specified as a case-sensitive string matching the sheet name in the
%   file.

[~,~,xls_cell] = xlsread(fullfile(repo_data_dir, 'geo_data','trend_locations.xlsx'), sheet);
locs = make_empty_struct_from_cell(xls_cell(1,:));
locs = repmat(locs,size(xls_cell,1)-1,1);

for a=2:size(xls_cell,1)
    for b=1:size(xls_cell,2)
        locs(a-1).(xls_cell{1,b}) = xls_cell{a,b};
    end
end

end

