function [ o3_surf, o3_column, start_date, end_date ] = generate_o3_trends( locname )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

du2mpsc = 2.69e16;

locname = strsplit(locname, ',');
locname = regexprep(locname{1}, '\W', '_');

%[globe_alt, globe_lon, globe_lat] = load_globe_alts([-125 -65],[25 50]);
G = load(fullfile(repo_data_dir,'geo_data','globe_alts.mat'));
o3_pres = omo3pr_pres;
o3_pres = o3_pres(:);
pp = o3_pres >= 200; % tropospheric column indicies

o3_bin_dir = fullfile(repo_data_dir, 'intermediate_data', 'Ozone');
F = dir(fullfile(o3_bin_dir,'*.mat'));

o3_surf = nan(size(F));
o3_column = nan(size(F));
start_date = cell(size(F));
end_date = cell(size(F));

for a=1:numel(F)
    O = load(fullfile(o3_bin_dir, F(a).name));
    o3 = O.o3;
    filedate = datenum(regexp(F(a).name,'\d\d\d\d\d\d','match','once'),'yyyymm');
    start_date{a} = datestr(filedate,'yyyy-mm-dd');
    end_date{a} = datestr(eomdate(filedate),'yyyy-mm-dd');
    
    % Find the site that we're considering and calculate the surface
    % average concentration and the tropospheric subcolumn. For the latter,
    % since the profile measurements are given in DU I "think" we can just
    % add them, though I will convert to molec./cm^2
    site = o3.(locname);
    surf_o3_du = site.o3(1,:);
    pres_edge = o3_pres(1:2);
    surf_o3_vmr = nan(size(surf_o3_du));
    for b=1:numel(site.lon)
        surfalt = interp2(G.globe_lon, G.globe_lat, G.globe_alt, site.lon(b), site.lat(b));
        pres_edge(1) = 1013*exp(-surfalt/7400); % standard scale height conversion to pressure. globe_alt in meters.
        surf_o3_vmr(b) = o3_du2vmr(surf_o3_du(b), pres_edge);
    end
    o3_surf(a) = nanmean(surf_o3_vmr);
    % do sum so that any nan in the profile results in whole profile being
    % nan'ed but nanmean so that we get a valid average if one of the
    % profiles is bad.
    o3_column(a) = nanmean(sum(site.o3(pp,:),1))*du2mpsc; 
end

end

function vmr = o3_du2vmr(o3_du, pres_edge)
% see
% https://disc.gsfc.nasa.gov/Aura/data-holdings/OMI/documents/v003/OMO3PRO_README.shtml
% for calculation
vmr = 1.2672 .* o3_du / abs(diff(pres_edge));
end