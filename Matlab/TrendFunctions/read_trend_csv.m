function [ locs ] = read_trend_csv( filename )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

E = JLLErrors;

[~,~,ext] = fileparts(filename);
if ~strcmpi('.csv',ext)
    E.badinput('FILENAME must point to a .csv file')
elseif ~exist(filename,'file')
    E.badinput('%s does not exist',filename);
end

n_header_rows = 4;

fid = fopen(filename,'r');

[locs, varnames] = read_header_and_vars(fid, n_header_rows);
tline = fgetl(fid);
while ischar(tline)
    vals = strsplit(tline,',');
    for a=1:numel(vals)
        ival = str2double(vals{a});
        if isnan(ival) && ~strcmpi(vals{a},'nan')
            % Test if it matches date format, otherwise assume that it's
            % just a string
            if ~isempty(regexp(vals{a},'\d\d\d\d-\d\d-\d\d','once'))
                ival = datenum(vals{a},'yyyy-mm-dd');
            else
                ival = vals{a};
            end
        end
        locs.(varnames{a}) = cat(1, locs.(varnames{a}), ival);
    end
    tline = fgetl(fid);
end
fclose(fid);

end

function [locs, varnames] = read_header_and_vars(fid, n_head_rows)
headers_names = cell(1, n_head_rows);
for a=1:n_head_rows
    tmp = strsplit(fgetl(fid),',');
    headers_names{a} = tmp{1};
    locs.(tmp{1}) = tmp{2};
end
vars = fgetl(fid);
varnames = strsplit(vars,',');
for a=1:numel(varnames)
    locs.(varnames{a}) = [];
end
end