function [  ] = plot_all_days( AllData, city, field, k )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

is3d = ~ismatrix(AllData{1}.(field));
minlon = Inf; maxlon = -Inf;
minlat = Inf; maxlat = -Inf;
minval = 0; maxval = 0;
for a=1:numel(AllData)
    if ~isempty(AllData{a})
        minlon = min(min(AllData{a}.Longitude(:)),minlon);
        maxlon = max(max(AllData{a}.Longitude(:)),maxlon);
        minlat = min(min(AllData{a}.Latitude(:)),minlat);
        maxlat = max(max(AllData{a}.Latitude(:)),maxlat);
        minval = min(min(AllData{a}.(field)(:)),minval);
        maxval = max(max(AllData{a}.(field)(:)),maxval);
    end
end

switch lower(city)
    case 'st. louis'
        city_lon = -90.1994;
        city_lat = 38.9270;
    otherwise
        error('behr_sonification:bad_input','The city %s is not defined',city)
end

for a=1:numel(AllData)
    if isempty(AllData{a})
        continue
    end
    if is3d
        data = squeeze(AllData{a}.(field)(k,:,:));
    else
        data = AllData{a}.(field);
    end
    lon = squeeze(AllData{a}.Loncorn(1,:,:));
    lat = squeeze(AllData{a}.Latcorn(1,:,:));
    f=figure;
    pcolor(lon, lat, data);
    colorbar
    title(field);
    xlim([minlon maxlon]); ylim([minlat maxlat])
    line(city_lon, city_lat, 'linestyle','none','marker','x','linewidth',2,'color','k');
    caxis([minval maxval])
    pause(1)
    close(f)
end



end

