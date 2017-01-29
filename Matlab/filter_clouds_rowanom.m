function [ Data ] = filter_clouds_rowanom( Data, cldtype, cldcrit )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

allowed_clds = {'omi','modis','rad'};
if ~ismember(cldtype, allowed_clds)
    error('behr_sonification:bad_input','%s is not a valid value for CLDTYPE; allowed values are %s',cldtype, strjoin(allowed_clds,', '));
end
if ~isscalar(cldcrit) || ~isnumeric(cldcrit) || cldcrit < 0 || cldcrit > 1
    error('behr_sonification:bad_input','CLDCRIT must be between 0 and 1')
end

switch cldtype
    case 'omi'
        cldfield = 'CloudFraction';
    case 'rad'
        cldfield = 'CloudRadianceFraction';
    case 'modis'
        cldfield = 'MODISCloud';
    otherwise
        error('behr_sonification:bad_input','%s is not an allowable cldtype.',cldtype);
end

fields_for_clds = {'BEHRColumnAmountNO2Trop','BEHRColumnAmountNO2TropVisOnly','ColumnAmountNO2Trop',...
    'ColumnAmountNO2','ColumnAmountNO2Strat','ColumnAmountNO2TropStd','SlantColumnAmountNO2'};
fields_for_row = [fields_for_clds, {'CloudFraction','CloudPressure','CloudRadianceFraction'}];

xx_cld = Data.(cldfield) > cldcrit;
xx_bad = mod(Data.vcdQualityFlags,2) ~= 0 | Data.XTrackQualityFlags ~= 0;

for a=1:numel(fields_for_clds)
    Data.(fields_for_clds{a})(xx_cld) = nan;
end
for a=1:numel(fields_for_row)
    Data.(fields_for_row{a})(xx_bad) = nan;
end

end

