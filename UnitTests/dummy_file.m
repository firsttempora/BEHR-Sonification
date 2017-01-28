function [  ] = dummy_file(  )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

ar_sh=[10,5];
header = {'AlongTrackInd', 'AcrossTrackInd', 'Latitude', 'Longitude', 'Var1', 'Var2', 'Var3','Var4-01','Var4-02','Var4-03'};

along_track_inds = (1:ar_sh(1))';
along_track_inds = repmat(along_track_inds,1,ar_sh(2));
across_track_inds = 1:ar_sh(2);
across_track_inds = repmat(across_track_inds,ar_sh(1),1);

lat = linspace(30,40,ar_sh(1))';
lon = linspace(-70,-80,ar_sh(2))';
lat = repmat(lat,1,ar_sh(2));
lon = repmat(lon,ar_sh(1),1);

var1 = rand(ar_sh);
var1(5) = nan;
var2 = rand(ar_sh);
var2(5) = nan;
var3 = rand(ar_sh);
var3(5) = nan;
var4 = rand([3, ar_sh]);
var4(:,5) = nan;

fid = fopen('dummy.csv','w');
fprintf(fid, 'ArrayShape,%d,%d\n',ar_sh(1),ar_sh(2));
fprintf(fid, '%s\n', strjoin(header, ','));
for a=1:numel(lon)
    fprintf(fid,'%d,%d,%.4g,%.4g,%.4g,%.4g,%.4g,%.4g,%.4g,%.4g\n',...
        along_track_inds(a),across_track_inds(a),lat(a),lon(a),var1(a),var2(a),var3(a),...
        var4(1,a), var4(2,a), var4(3,a));
end
fclose(fid);

end

