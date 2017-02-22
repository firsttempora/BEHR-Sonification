function [  ] = dummy_trend_file(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

M = fliplr(combinations(1:12, 2005:2015));
years = M(:,1);
months = M(:,2);

start_dates = cell(size(M,1),1);
end_dates = cell(size(M,1),1);

for a=1:size(M,1)
    start_dates{a} = sprintf('%04d-%02d-%02d', years(a), months(a), 1);
    end_dates{a} = sprintf('%04d-%02d-%02d', years(a), months(a), eomday(years(a),months(a)));
end

sin_comp = 2e15 * sin((1:size(M,1))*pi/6);
slope = -5e15/(12*11);

no2 = 1e16 + slope*(1:12*11) + sin_comp;

mydir = fileparts(mfilename('fullpath'));
dummy_file = fullfile(mydir, 'dummy_trends.csv');
write_trend_csv(dummy_file, 'TestCity', -90, 35, 'StartDate',start_dates,'EndDate',end_dates,'BEHRNO2',no2)

end

