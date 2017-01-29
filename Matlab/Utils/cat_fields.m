function [ CattedData ] = cat_fields( AllData, fields )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

CattedData = make_empty_struct_from_cell(fields);
for a=1:numel(AllData)
    if isempty(AllData{a})
        continue
    end
    
    for b=1:numel(fields)
        CattedData.(fields{b}) = cat(1, CattedData.(fields{b}), AllData{a}.(fields{b})(:));
    end
end

end

