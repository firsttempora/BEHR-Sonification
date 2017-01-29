function [ varargout ] = convert_all_hdf_to_csv( city, varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;
p.addParameter('vars','all');
p.addParameter('cldtype','omi');
p.addParameter('cldcrit',0.2);
p.addParameter('savecsv',true);
p.addParameter('subdims',[10 5]);

p.parse(varargin{:});
pout = p.Results;

vars = pout.vars;
cldtype = pout.cldtype;
cldcrit = pout.cldcrit;
savecsv = pout.savecsv;
subdims = pout.subdims;

if ~ischar(vars) && ~iscellstr(vars)
    error('behr_sonification:bad_input', 'VARS must be a string or cell array of strings');
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
all_datas = cell(size(F));

for a=1:numel(F)
    Data = behr_read_hdf(fullfile(hdf_dir, F(a).name));
    try
        subData = behr_sub_array(Data, city_lon, city_lat, cldtype, 'subdims', subdims);
    catch err
        if strcmp(err.identifier,'behr_sonification:swath_assignment')
            continue
        else
            rethrow(err)
        end
    end
    
    subData = calculate_trop_scds(subData);
    subData = filter_clouds_rowanom(subData, cldtype, cldcrit);
    subData = nan_below_ground_profile(subData);
    dnum = datenum(regexp(F(a).name,'\d\d\d\d\d\d\d\d','match','once'),'yyyymmdd');
    
    if ~strcmpi(vars,'all')
        if ~ismember('Latitude',vars);
            vars = [{'Latitude'}; vars(:)];
        end
        if ~ismember('Longitude',vars)
            vars = [{'Longitude'}; vars(:)];
        end
        data_fields = fieldnames(subData);
        xx = ~ismember(data_fields, vars);
        subData = rmfield(subData, data_fields(xx));
    end
    if savecsv
        write_csv(subData,dnum);
    else
        all_datas{a} = subData;
    end
    
end

if nargout > 0
    varargout{1} = all_datas;
end

end

function Data = nan_below_ground_profile(Data)
for a=1:numel(Data.Longitude)
    pvec = Data.BEHRPressureLevels(:,a);
    pTerr = Data.GLOBETerpres(a);
    pp = pvec > pTerr;
    Data.BEHRNO2apriori(pp,a) = nan;
end
end
