function [  ] = write_trend_csv( filename, site_name, short_name, lon, lat, varargin )
%WRITE_TREND_CSV Write a trend .csv file for a single site
%   WRITE_TREND_CSV( FILENAME, SITE_NAME, LON, LAT, ... ) Writes a .csv
%   file at FILENAME. Writes the SITE_NAME, LON, and LAT in the header. The
%   following inputs must alternate variable names as strings and variable
%   values as arrays.

E = JLLErrors;

if numel(varargin) < 2
    E.badinput('Input at least one variable name and value')
elseif mod(numel(varargin),2) ~= 0
    E.badinput('Must input data for each variable name')
end

n = numel(varargin);
var_names = varargin(1:2:end);
var_vals = varargin(2:2:end);

n_vals = numel(varargin{2});
formats = cell(1,n/2);
for a=1:numel(var_vals)
    if iscellstr(var_vals{a})
        formats{a} = '%s';
    else
        formats{a} = '%.4g';
    end
    if numel(var_vals{a}) ~= n_vals
        E.badinput('All data inputs should have the same number of elements')
    end
end

format_spec = sprintf('%s\n', strjoin(formats,','));
    
fid = fopen(filename,'w');
fprintf(fid, 'SiteName,%s\n', site_name);
fprintf(fid, 'ShortName,%s\n', short_name);
fprintf(fid, 'SiteLongitude,%.4f\n', lon);
fprintf(fid, 'SiteLatitude,%.4f\n',lat);

fprintf(fid, '%s\n', strjoin(var_names, ','));
n = numel(var_vals);
for a=1:n_vals
    val_cell = cell(1,n);
    for b=1:n
        if iscell(var_vals{b})
            val_cell{b} = var_vals{b}{a};
        else
            val_cell{b} = var_vals{b}(a);
        end
    end
    fprintf(fid, format_spec, val_cell{:});
end

fclose(fid);

end

