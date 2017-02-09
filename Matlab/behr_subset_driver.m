function [  ] = behr_subset_driver(  )
%BEHR_SUBSET_DRIVER Driver function for subsetting BEHR data to csv's

subset_dimensions = [10, 5];
convert_all_hdf_to_csv('St. Louis', 'subdims', subset_dimensions);

end

