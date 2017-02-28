function [  ] = bin_omo3pr_to_sites(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%omo3pr_dir = '/Volumes/share-sat/SAT/OMI/OMO3PR/download_staging';
omo3pr_dir = '/home/josh/Downloads';
omo3pr_fields = {'AerosolOpticalThickness','EffectiveCloudFractionUV1',...
    'EffectiveCloudFractionUV2','O3','ReflectanceCostFunction'};
cities = read_trend_loc_xls('Cities');
power_plants = read_trend_loc_xls('PowerPlants');

cities = make_short_names(cities);
power_plants = make_short_names(power_plants);

substruct = make_empty_struct_from_cell({'o3','lon','lat','dnum'});
short_names = [{cities.ShortName}, {power_plants.ShortName}];

F = dir(fullfile(omo3pr_dir, 'OMI-Aura_L2-OMO3PR*.he5'));
for a=1:numel(F)
    % Get the month from the file name
    filedate = date_from_file(F(a).name);
    if a == 1 || month(filedate) ~= last_month
        if a > 1
            save_o3(o3, filedate);
        end
        o3 = make_empty_struct_from_cell(short_names, substruct);
        last_month = month(filedate);
    end
    Data = read_hdf5(fullfile(omo3pr_dir, F(a).name), {'Longitude','Latitude'}, omo3pr_fields);
    rejects = omo3pr_reject_pixel(Data);
    Data.O3(:,rejects) = nan;
    
    o3 = bin_ozone(Data, o3, [cities; power_plants], filedate);
end
save_o3(o3,filedate);

end

function o3 = bin_ozone(Data, o3, sites, filedate)
for a=1:numel(sites)
    % Find all valid (not all NaNs) profiles within 50 km. Be a little
    % sneaky about doing the distance calculation to save time - m_lldist
    % takes more time than a simple magnitude calc, but the difference in
    % Haversine distance between 25 and 50 N matters.
    
    r = sqrt((Data.Longitude - sites(a).Longitude).^2 + (Data.Latitude - sites(a).Latitude).^2);
    xx = find(r < 1); % 1 degree is more than 50 km even at 50N
    
    for b=1:numel(xx)
        dist = m_lldist([Data.Longitude(xx(b)), sites(a).Longitude],...
            [Data.Latitude(xx(b)), sites(a).Latitude]);
        if dist > 50; continue;
        elseif all(isnan(Data.O3(:,xx(b)))); continue; 
        end
        
        o3.(sites(a).ShortName).o3(:,end+1) = Data.O3(:,xx(b));
        o3.(sites(a).ShortName).lon(end+1) = Data.Longitude(xx(b));
        o3.(sites(a).ShortName).lat(end+1) = Data.Latitude(xx(b));
        o3.(sites(a).ShortName).dnum(end+1) = filedate;
    end
end
end

function dnum = date_from_file(filename)
dstr = regexp(filename,'(?<=OMO3PR_)\d\d\d\dm\d\d\d\dt\d\d\d\d','match','once');
dstr = strrep(dstr,'m','');
dstr = strrep(dstr,'t','_');
dnum = datenum(dstr, 'yyyymmdd_HHMM');
end

function S = make_short_names(S)
for a=1:numel(S)
    tmp = strsplit(S(a).Location,',');
    tmp = regexprep(tmp, '\W', '_');
    S(a).ShortName = tmp{1};
end
end

function save_o3(o3, dnum) %#ok<INUSL>
savedir = fullfile(repo_data_dir,'intermediate_data','Ozone');
savename = sprintf('OMO3PR_%s.mat',datestr(dnum,'yyyymm'));
save(fullfile(savedir, savename), 'o3');
end