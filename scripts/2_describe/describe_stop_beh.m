for session_i = 1:29
    
    ssd_list{session_i} = executiveBeh.inh_SSD{session_i};
    pnc_list{session_i} = executiveBeh.inh_pNC{session_i};
    
    RTnoncanc{session_i} = quantile(executiveBeh.RTdata.RTinfo.all{session_i}.ncRT.dist,[0.1:0.2:0.9]);   
    RTnostop{session_i} = quantile(executiveBeh.RTdata.RTinfo.all{session_i}.goRT.dist,[0.1:0.2:0.9]);
    quantile_list{session_i} = [0.1:0.2:0.9];
end



trialtype_label = [];
trialtype_label = [repmat({'1_Noncanc'},length(RTnoncanc),1);repmat({'2_Nostop'},length(RTnostop),1)];

clear stop_beh_figure
% Produce the figure, collapsed across all monkeys
stop_beh_figure(1,1)=gramm('x',[RTnoncanc';RTnostop'],'y',[quantile_list';quantile_list'],'color',trialtype_label);
stop_beh_figure(1,1).geom_line('alpha',0.1);
stop_beh_figure(1,1).stat_summary('geom',{'line','point'});
stop_beh_figure(1,1).set_color_options('map',[colors.noncanc; colors.nostop]);
stop_beh_figure(1,1).axe_property('XLim',[0 600],'YLim',[0 1]);
stop_beh_figure(1,1).no_legend();

stop_beh_figure(2,1)=gramm('x',ssd_list,'y',pnc_list);
stop_beh_figure(2,1).geom_line('alpha',0.1);
stop_beh_figure(2,1).geom_point('alpha',0.5);
% test(2,1).stat_summary('geom',{'line'},'interp_in',6);
stop_beh_figure(2,1).set_color_options('map',[0 0 0]);
stop_beh_figure(2,1).axe_property('XLim',[0 600],'YLim',[0 1]);


stop_beh_figure_out = figure('Renderer', 'painters', 'Position', [100 100 400 400]);
stop_beh_figure.draw();