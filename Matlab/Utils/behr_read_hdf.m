function [ Data ] = behr_read_hdf( hdf_file )
%BEHR_READ_HDF Reads an HDF BEHR file back into a Matlab data structure
%   Data = BEHR_READ_HDF( HDF_FILE ) Given the name of a BEHR HDF file
%   (with appropriate path), will return a Data structure with each swath
%   as an element of the Data structure and the datasets as fields. Any
%   fill values will be replaced with NaNs.

hi = h5info(hdf_file);

dsets = {hi.Groups.Groups(1).Datasets.Name};
Data = make_empty_struct_from_cell(dsets);

for a=1:numel(hi.Groups.Groups)
    group = hi.Groups.Groups(a);
    for b=1:numel(dsets)
        curr_dset = group.Datasets(b);
        val = read_dset(hi.Filename, group, b);
        Data(a).(curr_dset.Name) = val;
    end
end

end

function val = read_dset(filename, group, ind)
dset = group.Datasets(ind);
val = h5read(filename, strcat(group.Name,'/',dset.Name));
fill_val = dset.FillValue;
if ~isnan(fill_val)
    % Replace fill values with NaNs if they aren't already
    xx = abs(val ./ fill_val - 1) < 0.01;
    val(xx) = NaN;
end
end