for session_i = 1:29
    
    RT_session = [];
    RT_session = executiveBeh.TrialEventTimes_Overall{session_i}(:,4) - ...
        executiveBeh.TrialEventTimes_Overall{session_i}(:,2);
    
    
    RT_left = []; RT_right = [];
    RT_left = RT_session(ttx_matched.left{session_i});
    RT_right = RT_session(ttx_matched.right{session_i});
    
    rt_quantile_right{session_i,1} = quantile(RT_right,[0.1:0.2:0.9]);
    rt_quantile_left{session_i,1} = quantile(RT_left,[0.1:0.2:0.9]);
    rt_quantile_p{session_i,1} = [0.1:0.2:0.9];
end


direction_label = [];
direction_label = [repmat({'1_Left'},length(rt_quantile_left),1);repmat({'2_Right'},length(rt_quantile_right),1)];

clear test
% Produce the figure, collapsed across all monkeys
test(1,1)=gramm('x',[rt_quantile_left;rt_quantile_right],'y',[rt_quantile_p;rt_quantile_p],'color',direction_label);
test(1,1).geom_line('alpha',0.1);
test(1,1).stat_summary('geom',{'line','point'});
test(1,1).axe_property('XLim',[0 500],'YLim',[0 1]);

RP_A_figure_out = figure('Renderer', 'painters', 'Position', [100 100 400 400]);
test.draw();


%%
for session_i = 1:29
    
    left_iti_saccade_RT = [];
    right_iti_saccade_RT = [];
    
    left_iti_saccade_RT = ttx_itiSaccade{session_i}(ttx_iti_saccade.left{session_i},2)-ttx_itiSaccade{session_i}(ttx_iti_saccade.left{session_i},5);
    right_iti_saccade_RT = ttx_itiSaccade{session_i}(ttx_iti_saccade.right{session_i},2)-ttx_itiSaccade{session_i}(ttx_iti_saccade.right{session_i},5);

    rt_quantile_right{session_i,1} = quantile(right_iti_saccade_RT,[0.1:0.2:0.9]);
    rt_quantile_left{session_i,1} = quantile(left_iti_saccade_RT,[0.1:0.2:0.9]);
    rt_quantile_p{session_i,1} = [0.1:0.2:0.9];
end


direction_label = [];
direction_label = [repmat({'1_Left'},length(rt_quantile_left),1);repmat({'2_Right'},length(rt_quantile_right),1)];

clear test
% Produce the figure, collapsed across all monkeys
test(1,1)=gramm('x',[rt_quantile_left;rt_quantile_right],'y',[rt_quantile_p;rt_quantile_p],'color',direction_label);
test(1,1).geom_line('alpha',0.1);
test(1,1).stat_summary('geom',{'line','point'});
test(1,1).axe_property('XLim',[0 1500],'YLim',[0 1]);

RP_A_figure_out = figure('Renderer', 'painters', 'Position', [100 100 400 400]);
test.draw();