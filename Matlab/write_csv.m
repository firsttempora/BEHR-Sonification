function [  ] = write_csv( Data, filedate, outfile )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

filename = sprintf('OMI_BEHR_subset_%s.csv', datestr(filedate, 'yyyy-mm-dd'));
if ~exist('outfile','var')
    outfile = fullfile(repo_data_dir, filename);
elseif ~exist(fileparts(outfile),'dir')
    error('write_csv:dir_dne','Output path %s does not exist',outfile);
end




fns = fieldnames(Data);
% Will force latitude and longitude to be at the beginning
xx = ismember(fns, {'Latitude','Longitude'});
fns(xx) = [];
is3d = false(size(fns));
varnames = {};
for a=1:numel(fns)
    if ~ismatrix(Data.(fns{a}))
        is3d(a) = true;
        for b=1:size(Data.(fns{a}),1)
            varnames{end+1} = sprintf('%s-%02d',fns{a},b);
        end
    else
        varnames{end+1} = fns{a};
    end
end

ar_sh = size(Data.Longitude);
ar_sh_line = sprintf('ArrayShape,%d,%d',ar_sh(1),ar_sh(2));
header=[{'AlongTrackInd','AcrossTrackInd','Latitude','Longitude'}, varnames];

fid = fopen(outfile,'w');
fprintf(fid, '%s\n', ar_sh_line);
fprintf(fid, '%s\n', strjoin(header,','));
npix = numel(Data.Longitude);
sz = size(Data.Longitude);
for a=1:npix
    % Write the indices and lat/lon first, then iterate over the variables
    [x,y] = ind2sub(sz, a);
    fprintf(fid,'%d,%d,%.4f,%.4f',x-1,y-1,Data.Latitude(a),Data.Longitude(a));
    
    for b=1:numel(fns)
        if is3d(b)
            for c=1:size(Data.(fns{b}),1)
                fprintf(fid,',%.4g', Data.(fns{b})(c,a));
            end
        else
            fprintf(fid,',%.4g',Data.(fns{b})(a));
        end
    end
    
    fprintf(fid,'\n');
end
fclose(fid);

end

