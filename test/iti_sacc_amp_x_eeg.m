amps_left = []; uv_left = [];
amps_right = []; uv_right = [];

for session_i = 1:29
    amps_left = [amps_left; ttx_itiSaccade{session_i}(ttx_iti_saccade.left{session_i},4)];
    uv_left = [uv_left; nanmean(EEG_signal.np_saccade{session_i,2}(ttx_iti_saccade.left{session_i},1000+[-50:0]),2)];
    
    amps_right = [amps_right; ttx_itiSaccade{session_i}(ttx_iti_saccade.right{session_i},4)];
    uv_right = [uv_right; nanmean(EEG_signal.np_saccade{session_i,3}(ttx_iti_saccade.right{session_i},1000+[-50:0]),2)];
    
end


%%
clear test_figure
test_figure(1,1)=gramm('x',amps_left,'y',uv_left);
test_figure(1,1).stat_glm('disp_fit',true);
test_figure(1,1).geom_point('alpha',0.2);

test_figure(1,2)=gramm('x',amps_right,'y',uv_right);
test_figure(1,2).stat_glm('disp_fit',true);
test_figure(1,2).geom_point('alpha',0.2);

test_figure_out = figure('Renderer', 'painters', 'Position', [100 100 800 400]);
test_figure.draw();