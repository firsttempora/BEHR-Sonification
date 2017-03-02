function [ pres ] = omo3pr_pres(  )
%OMO3PR_PRES Pressure levels used in the omo3pr retrievals.
%   PRES = OMO3PR_PRES Returns the edges of the pressure bins (in hPa) for
%   the OMO3PR ozone profile retrieval. NOTE: The first edge should be
%   surface pressure, so replace the 1013 there with the actual surface
%   pressure if you can for the best accuracy.

pres = [1013, 700, 500, 300, 200, 150, 100, 70, 50, 30, 20, 10, 7, 5, 3, 2, 1, 0.5, 0.3];

end

