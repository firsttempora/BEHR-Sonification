function [  ] = interactive_plot_trend(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

a = 1;
while true
    [fname,pname] = uigetfile('*.csv','Pick a .csv file to plot', fullfile(repo_data_dir,'trend_data'));
    locs(a) = read_trend_csv(fullfile(pname,fname));
    fig=figure;
    plot_site_trend(locs(a));
    if ask_yn('Keep this site?')
        a=a+1;
    end
    close(fig)
    if ~ask_yn('Add another?')
        break
    end
end

%combine_plots(figs, 'dims', size(figs));
figure;
for a=1:numel(locs)
    subplot(numel(locs),1,a);
    plot_site_trend(locs(a));
end
ch = get(gcf,'children');
for a=1:numel(ch)
    ch(a).FontSize = 10;
end

end

