# Sonification of NO<sub>2</sub> and O<sub>3</sub> trends

This repository is largely broken down into 3 components.
1. Matlab code to generate Supercollider readable CSV files
2. Supercollider code to sonify the trends in the CSV files
3. Latex document for submission to ICAD 2017

The most relevant parts of this are the Matlab code to generate the trend CSVs
and the SC code to run the sonification.

## Matlab code to generate trend files
### Preprocessing

Monthly files need to be generated before the trend CSV files can be. This is
done separately with two functions in Matlab/TrendFunctions

1. trend_monthly_avgs.m - generates the NO<sub>2</sub> monthly averages from
BEHR .mat files. This relies on utilities in the private BEHR repository, BEHR
Classes repository, and Utils repository, plus access to the BEHR .mat files.
One could make use of the gridded HDF files available at
http://behr.cchem.berkeley.edu/DownloadBEHRData.aspx to the same end, but some
modification of the code would be required.
2. bin_omo3pr_to_sites.m - this generates monthly files containing the OMI
O<sub>3</sub> profiles binned to sites. The HDF5 files for the OMO3PR product
can be downloaded from Mirador (https://mirador.gsfc.nasa.gov/). This also has
several dependencies on private repos currently.

Running each of these functions will save .mat files under
data/intermediate_files. These .mat files are used by trend_driver.m to generate
the CSV files needed by Supercollider. This division was designed because the
generation of monthly files takes substantially longer that the CSV files, so it
was sensible to allow those steps to be independent.


## Supercollider program to present trends sonically
The Supercollider program is driven by the run_trends.scd file. The only
configuration necessary is to modify the base_path variable at the top of the
file to the location of this repository. Execute the run_trends.scd file to open
the interactive GUI to control the presentation of the NO<sub>2</sub> and
O<sub>3</sub> trends.
