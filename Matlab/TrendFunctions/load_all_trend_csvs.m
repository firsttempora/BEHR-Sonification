function [ locs ] = load_all_trend_csvs(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

types = dir(fullfile(repo_data_dir,'trend_data'));
i = 1;
for a=1:numel(types)
    if isempty(regexp(types(a).name,'\w*','once'))
        % Skip . and ..
        continue
    end
    
    subdir = fullfile(repo_data_dir, 'trend_data', types(a).name);
    F = dir(fullfile(subdir, '*.csv'));
    for b=1:numel(F)
        locs(i) = read_trend_csv(fullfile(subdir,F(b).name));
        i=i+1;
    end
end

end

