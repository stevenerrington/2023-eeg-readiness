%%
EEG_saccade_left = [];
EEG_saccade_right = [];

for session = 1:29
    for ch_index = 2:3
                
        channel = channel_list{ch_index};
        
        EEG_target_left{ch_index}(session,:) = nanmean( EEG_signal.target{session,ch_index}(executiveBeh.ttx.GO_Left{session},:));
        EEG_target_right{ch_index}(session,:) = nanmean( EEG_signal.target{session,ch_index}(executiveBeh.ttx.GO_Right{session},:));
        
        EEG_saccade_left{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(executiveBeh.ttx.GO_Left{session},:));
        EEG_saccade_right{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(executiveBeh.ttx.GO_Right{session},:));
        
        EEG_saccade_right_nc{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(executiveBeh.ttx.NC_Right{session},:));
        EEG_saccade_left_nc{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(executiveBeh.ttx.NC_Left{session},:));
         
    end
end




%%

for session = 1:29
    plot_EEG_left_A(session,:)  = EEG_saccade_left{2}(session,:);
    plot_EEG_right_A(session,:) = EEG_saccade_right{2}(session,:);
    
    plot_EEG_left_B(session,:)  = EEG_saccade_left{3}(session,:);
    plot_EEG_right_B(session,:) = EEG_saccade_right{3}(session,:);
    
    plot_EEG_left_B_nc(session,:)  = EEG_saccade_left_nc{3}(session,:);
    plot_EEG_right_B_nc(session,:) = EEG_saccade_right_nc{3}(session,:);
    
end




%% Figure: Population EEG for left/right target

input_sdf_left_A = num2cell(plot_EEG_left_A, 2);
input_sdf_right_A = num2cell(plot_EEG_right_A, 2);
input_sdf_left_B = num2cell(plot_EEG_left_B, 2);
input_sdf_right_B = num2cell(plot_EEG_right_B, 2);

xlim_input = [-600 200];
ylim_input = [-10 10];
timewins.sdf = -999:2000;

labels_value = [repmat({'1_Left'},length(input_sdf_left_A),1);repmat({'2_Right'},length(input_sdf_right_A),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];

% Produce the figure, collapsed across all monkeys
RP_A_figure(1,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
RP_A_figure(1,1).stat_summary();
RP_A_figure(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
RP_A_figure(1,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

RP_A_figure(2,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
RP_A_figure(2,1).stat_summary();
RP_A_figure(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
RP_A_figure(2,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
RP_A_figure(2,1).facet_grid([],monkey_label);

RP_A_figure(1,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
RP_A_figure(1,2).stat_summary();
RP_A_figure(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
RP_A_figure(1,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');

RP_A_figure(2,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
RP_A_figure(2,2).stat_summary();
RP_A_figure(2,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
RP_A_figure(2,2).set_names('x','Time from Saccade (ms)','y','EEG (uV)');
RP_A_figure(2,2).facet_grid([],monkey_label);

RP_A_figure_out = figure('Renderer', 'painters', 'Position', [100 100 1500 800]);
RP_A_figure.draw();

% Once we're done with a page, save it and close it.
filename = fullfile('D:\projectCode\2023-eeg-readiness','results','pop_figure_rp.pdf');
set(RP_A_figure_out,'PaperSize',[20 10]); %set the paper size to what you want
print(RP_A_figure_out,filename,'-dpdf') % then print it
close(RP_A_figure_out)





%%
clear RP_A_figure

input_sdf_left_ns = num2cell(plot_EEG_left_B, 2);
input_sdf_right_ns = num2cell(plot_EEG_right_B, 2);
input_sdf_left_nc = num2cell(plot_EEG_left_B_nc, 2);
input_sdf_right_nc = num2cell(plot_EEG_right_B_nc, 2);

xlim_input = [-600 200];
ylim_input = [-10 10];
timewins.sdf = -999:2000;

labels_value = [repmat({'1_Left_GO'},length(input_sdf_left_ns),1);...
    repmat({'2_Right_GO'},length(input_sdf_right_ns),1);...
    repmat({'3_Left_NC'},length(input_sdf_left_nc),1);...
    repmat({'4_Right_NC'},length(input_sdf_right_nc),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,4,1)];

% Produce the figure, collapsed across all monkeys
RP_A_figure(1,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_ns;input_sdf_right_ns;input_sdf_left_nc;input_sdf_right_nc],'color',labels_value);
RP_A_figure(1,1).stat_summary();
RP_A_figure(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
RP_A_figure(1,1).set_names('x','Time from Saccade (ms)','y','EEG (uV)');


RP_A_figure_out = figure('Renderer', 'painters', 'Position', [100 100 800 400]);
RP_A_figure.draw();


% Once we're done with a page, save it and close it.
filename = fullfile('D:\projectCode\2023-eeg-readiness','results','pop_figure_rp_go-nc.pdf');
set(RP_A_figure_out,'PaperSize',[20 10]); %set the paper size to what you want
print(RP_A_figure_out,filename,'-dpdf') % then print it
close(RP_A_figure_out)


%%






for session = 1:29
    
    figure('Renderer', 'painters', 'Position', [100 100 800 800]);
    subplot(2,2,1); hold on
    plot(-999:2000, EEG_target_left{2}(session,:))
    plot(-999:2000, EEG_target_right{2}(session,:))
    xlim([-100 600]); vline(0,'k');
    title(['Monkey ' executiveBeh.nhpSessions.monkeyNameLabel{session}(1:2) ': AD01'])
    xlabel('Time from Target (ms)'); ylabel('EEG Voltage');
    
    subplot(2,2,2); hold on
    plot(-999:2000, EEG_saccade_left{2}(session,:))
    plot(-999:2000, EEG_saccade_right{2}(session,:))
    xlim([-500 200]); vline(0,'k'); title('AD02')
    xlabel('Time from Saccade (ms)');
    
    subplot(2,2,3); hold on
    plot(-999:2000, EEG_target_left{3}(session,:))
    plot(-999:2000, EEG_target_right{3}(session,:))
    xlim([-100 600]); vline(0,'k'); title('AD03')
    xlabel('Time from Target (ms)');
    
    subplot(2,2,4); hold on
    plot(-999:2000, EEG_saccade_left{3}(session,:))
    plot(-999:2000, EEG_saccade_right{3}(session,:))
    xlim([-500 200]); vline(0,'k'); title('AD04')
    xlabel('Time from Saccade (ms)');
    legend({'Left','Right'})
    
end




%%

params.baselinewindow = [-600:-500]+1000;
input_left = []; input_left = EEG_saccade_left{2};
baseline_average = nanmean(input_left(:,params.baselinewindow),2);
baseline_std = nanstd(input_left(:,params.baselinewindow),[],2);

input_left = bsxfun(@minus,input_left,baseline_average(:));
input_left = bsxfun(@ldivide,input_left,baseline_std(:));

input_right = []; input_right = EEG_saccade_right{2};
[max_uv,~] = max(abs(input_right(:,params.normWindow)),[],2);
input_right = bsxfun(@rdivide,input_right,max_uv(:));

figure
subplot(2,1,1)
imagesc('XData',-1000:2000,'YData',1:length(input_left),'CData',input_left)
xlim([-600 0]); ylim([1 length(input_left)]);
caxis([-2 2])


subplot(2,1,2)
imagesc('XData',-1000:2000,'YData',1:length(input_right),'CData',input_right)
xlim([-600 0]); ylim([1 length(input_right)]);