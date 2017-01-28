function [  ] = dummy_file(  )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

ar_sh = [10,5];

lat = linspace(30,40,ar_sh(1))';
lon = linspace(-70,-80,ar_sh(2));
Data.Latitude = repmat(lat,1,ar_sh(2));
Data.Longitude = repmat(lon,ar_sh(1),1);

Data.CloudFraction = rand(size(Data.Longitude));
Data.BEHRColumnAmountNO2Trop = reshape((1:numel(Data.Longitude))*1e15, size(Data.Longitude));
Data.BEHRColumnAmountNO2Trop(7) = nan;
Data.BEHRNO2apriori = coord_mat(4,size(Data.Longitude,1),size(Data.Longitude,2))*1e-9;
Data.BEHRNO2apriori(:,7) = nan;

mypath = fileparts(mfilename('fullpath'));
write_csv(Data,[],fullfile(mypath,'dummy.csv'));

end

function matrix_out = coord_mat(varargin)

dims = [varargin{:}];
if numel(dims) == 1
    dims(2) = 1;
end
matrix_out = zeros(prod(dims),1);
place = 10.^(0:numel(dims)-1);
for a=1:prod(dims)
    C = cell(1,numel(dims));
    [C{:}] = ind2sub(dims,a);
    C = [C{:}];
    matrix_out(a) = sum(C .* place);
end
matrix_out = reshape(matrix_out,dims);
end