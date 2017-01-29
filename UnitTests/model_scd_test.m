function [  ] = model_scd_test(  )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

mypath = fileparts(mfilename('fullpath'));
D = load(fullfile(mypath,'OMI_BEHR_v2-1C_20130610.mat'),'Data');
Data = D.Data(2);

test_scd = nan(size(Data.BEHRModelSCDInit));
true_scd = Data.BEHRModelSCDInit;

for a=1:numel(Data.Longitude)
    no2vec = Data.BEHRNO2apriori(:,a);
    swvec = Data.BEHRScatteringWeights(:,a);
    pvec = Data.BEHRPressureLevels(:,a);
    notnans = ~isnan(pvec);
    pTerr = Data.GLOBETerpres(a);
    test_scd(a) = apply_aks_to_prof(no2vec(notnans), pvec(notnans), swvec(notnans), pvec(notnans), pTerr);
end

notnans = ~isnan(test_scd) & ~isnan(true_scd);
figure; scatter(true_scd(notnans), test_scd(notnans));


end

