function [  ] = convert_all_hdf_to_csv( city, varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;
p.addParameter('vars','all');
p.addParameter('cldtype','omi');
p.addParameter('cldcrit',0.2);

p.parse(varargin{:});
pout = p.Results;

variables = pout.vars;
cldtype = pout.cldtype;
cldcrit = pout.cldcrit;

if ~ischar(variables) && ~iscellstr(variables)
    error('behr_sonification:bad_input', 'VARIABLES must be a string or cell array of strings');
end
allowed_clds = {'omi','modis','rad'};
if ~ismember(cldtype, allowed_clds)
    error('behr_sonification:bad_input','%s is not a valid value for CLDTYPE; allowed values are %s',cldtype, strjoin(allowed_clds,', '));
end
if ~isscalar(cldcrit) || ~isnumeric(cldcrit) || cldcrit < 0 || cldcrit > 1
    error('behr_sonification:bad_input','CLDCRIT must be between 0 and 1')
end
    

switch lower(city)
    case 'st. louis'
        city_lon = -90.1994;
        city_lat = 38.9270;
    otherwise
        error('behr_sonification:bad_input','The city %s is not defined',city)
end


hdf_dir = '/home/josh/Documents/MATLAB/BEHR/Data/HDF-Native'; %getenv('BEHR_HDFDIR');
F = dir(fullfile(hdf_dir, '*.hdf'));

for a=1:numel(F)
    Data = behr_read_hdf(fullfile(hdf_dir, F(a).name));
    try
        subData = behr_sub_array(Data, city_lon, city_lat, variables, cldtype);
    catch err
        if strcmp(err.identifier,'behr_sonification:swath_assignment')
            continue
        else
            rethrow(err)
        end
    end
    
    subData = filter_clouds_rowanom(subData, cldtype, cldcrit);
    dnum = datenum(regexp(F(a).name,'\d\d\d\d\d\d\d\d','match','once'),'yyyymmdd');
    write_csv(subData,dnum);
    
end

end

