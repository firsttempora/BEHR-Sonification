function [ dpath ] = repo_data_dir( )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

mypath = fileparts(mfilename('fullpath'));
dpath = fullfile(mypath,'..','data');

end

