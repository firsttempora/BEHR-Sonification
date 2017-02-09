function [  ] = write_wind_csv( windvel, theta, dnums, filename )
%WRITE_WIND_CSV Write a csv file containing wind speed and direction 
%   WRITE_WIND_CSV( WINDVEL, THETA, DNUMS, FILENAME ) Writes a csv named
%   FILENAME in the directory specified by repo_data_dir() containing the
%   wind speeds (WINDVEL) and wind directions (THETA), the latter in
%   degrees CCW from east of the direction the wind blows towards.

outfile = fullfile(repo_data_dir, 'wind_data', filename);
fid = fopen(outfile,'w');

header = {'Date','WindVelocity','WindDirection'};
fprintf(fid,'NumberOfDays,%d\n',numel(dnums));
fprintf(fid,'%s\n',strjoin(header,','));
for a=1:numel(dnums)
    fprintf(fid,'%s,%f,%f\n', datestr(dnums(a),'yyyy-mm-dd'), windvel(a), theta(a));
end

fclose(fid);
end
