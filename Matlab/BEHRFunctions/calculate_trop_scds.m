function [ Data ] = calculate_trop_scds( Data )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


Data.BEHRSlantColumnAmountNO2Trop = Data.ColumnAmountNO2Trop .* Data.AMFTrop;
Data.ModelSCD = nan(size(Data.Longitude));
for a=1:numel(Data.Longitude)
    no2vec = Data.BEHRNO2apriori(:,a);
    swvec = Data.BEHRScatteringWeights(:,a);
    pvec = Data.BEHRPressureLevels(:,a);
    notnans = ~isnan(pvec);
    pTerr = Data.GLOBETerpres(a);
    Data.ModelSCD(a) = apply_aks_to_prof(no2vec(notnans), pvec(notnans), swvec(notnans), pvec(notnans), pTerr);
end

end

