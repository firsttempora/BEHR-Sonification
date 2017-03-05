function [ax] = plot_site_trend( loc )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%fig=figure; 
%[ax,h1,h2] = plotyy(loc.StartDate, loc.BEHRNO2, loc.StartDate, loc.O3_tVCD);
[ax,h1,h2] = plotyy(loc.StartDate, loc.BEHRNO2, loc.StartDate, loc.O3_VMR);

ax(1).YColor='b';
ax(1).YLabel.String='NO_2 tVCD (molec. cm^{-2})';
ax(1).FontSize=14;
h1.Color='b';
ax(2).YColor='r';
%ax(2).YLabel.String='O_3 tVCD (molec. cm^{-2})';
ax(2).YLabel.String='O_3 VMR (ppmv)';
ax(2).FontSize=14;
h2.Color='r';
datetick(ax(1),'x','mmm yy');
ax(1).Position(3) = 0.725;
title(loc.SiteName)
end

