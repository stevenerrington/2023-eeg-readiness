%% Analyse: Extract ERP for left and right no-stop trials

 [ttx_canc_lat, ttx_noncanc_lat] = get_canclattrials(executiveBeh);

% For each session
for session_i = 1:29
    % Find the lateral channels
    for ch_index = 2:3
        channel = channel_list{ch_index};
        
        % Latency matching for canceled and no-stop
        clear ns_left* ns_right* c_left* c_right*
        n_ssds = length(executiveBeh.inh_SSD{session_i});
        
        for ssd_i = 1:n_ssds
            ns_left_x(ssd_i,:) = nanmean( EEG_signal.stopSignal{session_i,ch_index}(executiveBeh.ttm_CGO{session_i,ssd_i}.GO_matched_l,:));
            c_left_x(ssd_i,:)  = nanmean( EEG_signal.stopSignal{session_i,ch_index}(executiveBeh.ttm_CGO{session_i,ssd_i}.C_matched_l,:));
            ns_right_x(ssd_i,:) = nanmean( EEG_signal.stopSignal{session_i,ch_index}(executiveBeh.ttm_CGO{session_i,ssd_i}.GO_matched_r,:));
            c_right_x(ssd_i,:)  = nanmean( EEG_signal.stopSignal{session_i,ch_index}(executiveBeh.ttm_CGO{session_i,ssd_i}.C_matched_r,:));
            
        end
        
        EEG_stopping_left{ch_index}(session_i,:) = nanmean( EEG_signal.stopSignal{session_i,ch_index}(ttx_canc_lat.left{session_i},:));
        EEG_stopping_right{ch_index}(session_i,:) = nanmean( EEG_signal.stopSignal{session_i,ch_index}(ttx_canc_lat.right{session_i},:));
        
        EEG_stopping_left_nc{ch_index}(session_i,:) = nanmean( EEG_signal.stopSignal{session_i,ch_index}(ttx_noncanc_lat.left{session_i},:));
        EEG_stopping_right_nc{ch_index}(session_i,:) = nanmean( EEG_signal.stopSignal{session_i,ch_index}(ttx_noncanc_lat.right{session_i},:));
        
        EEG_latencyMatched_left_c{ch_index}(session_i,:) = nanmean(c_left_x);
        EEG_latencyMatched_left_ns{ch_index}(session_i,:) = nanmean(ns_left_x);
        EEG_latencyMatched_right_c{ch_index}(session_i,:) = nanmean(c_right_x);
        EEG_latencyMatched_right_ns{ch_index}(session_i,:) = nanmean(ns_right_x);
        
    end
end


%% Figure: Population EEG for left/right target

for session_i = 1:29
    % Canceled trials
    plot_EEG_AD02_canceled(session_i,:)  = EEG_stopping_left{2}(session_i,:);
    plot_EEG_AD03_canceled(session_i,:) =  EEG_stopping_right{3}(session_i,:);
    
    % Noncanceled trials
    plot_EEG_AD02_noncanceled(session_i,:)  = EEG_stopping_left_nc{2}(session_i,:);
    plot_EEG_AD03_noncanceled(session_i,:) =  EEG_stopping_right_nc{3}(session_i,:);
    
    % Latency-matched canceled trials
    plot_EEG_AD02_canceled_lm(session_i,:)  = EEG_latencyMatched_left_c{2}(session_i,:);
    plot_EEG_AD03_canceled_lm(session_i,:) =  EEG_latencyMatched_right_c{3}(session_i,:);    
    
    % Latency-matched no-stop trials
    plot_EEG_AD02_nostop_lm(session_i,:)  = EEG_latencyMatched_left_ns{2}(session_i,:);
    plot_EEG_AD03_nostop_lm(session_i,:) =  EEG_latencyMatched_right_ns{3}(session_i,:);      
    
end

%% Extract: convert data for figure input
input_sdf_AD02_canceled = num2cell(plot_EEG_AD02_canceled, 2);
input_sdf_AD03_canceled = num2cell(plot_EEG_AD03_canceled, 2);
input_sdf_AD02_noncanceled = num2cell(plot_EEG_AD02_noncanceled, 2);
input_sdf_AD03_noncanceled = num2cell(plot_EEG_AD03_noncanceled, 2);

input_sdf_AD02_canceled_lm = num2cell(plot_EEG_AD02_canceled_lm, 2);
input_sdf_AD03_canceled_lm = num2cell(plot_EEG_AD03_canceled_lm, 2);
input_sdf_AD02_nostop_lm = num2cell(plot_EEG_AD02_nostop_lm, 2);
input_sdf_AD03_nostop_lm = num2cell(plot_EEG_AD03_nostop_lm, 2);

%% Figure: define parameters
xlim_input = [-200 600];
ylim_input = [-0.010 0.010];
timewins.sdf = -999:2000;

labels_value = [repmat({'Canceled'},length(input_sdf_AD02_canceled),1);repmat({'Noncanceled'},length(input_sdf_AD02_noncanceled),1)];
labels_value_lm = [repmat({'Canceled'},length(input_sdf_AD02_canceled),1);repmat({'Nostop'},length(input_sdf_AD02_nostop_lm),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];

%% Figure: generate figure
clear stopsignal_ERP_fig
% Figure: stopping - canceled x noncanceled %%%%%%%%%%%%%%%%%%%%%%%%%%%
stopsignal_ERP_fig(1,1)=gramm('x',timewins.sdf,'y',[input_sdf_AD02_canceled;input_sdf_AD02_noncanceled],'color',labels_value);
stopsignal_ERP_fig(1,1).stat_summary();
stopsignal_ERP_fig(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
stopsignal_ERP_fig(1,1).set_names('x','Time from Stop-Signal (ms)','y','EEG (uV)');
stopsignal_ERP_fig(1,1).set_color_options('map',[colors.canceled;colors.noncanc]);

stopsignal_ERP_fig(2,1)=gramm('x',timewins.sdf,'y',[input_sdf_AD03_canceled;input_sdf_AD03_noncanceled],'color',labels_value);
stopsignal_ERP_fig(2,1).stat_summary();
stopsignal_ERP_fig(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
stopsignal_ERP_fig(2,1).set_names('x','Time from Stop-Signal (ms)','y','EEG (uV)');
stopsignal_ERP_fig(2,1).set_color_options('map',[colors.canceled;colors.noncanc]);
stopsignal_ERP_fig(2,1).facet_grid([],monkey_label);

% Figure: stopping - canceled x no-stop %%%%%%%%%%%%%%%%%%%%%%%%%%%
stopsignal_ERP_fig(1,2)=gramm('x',timewins.sdf,'y',[input_sdf_AD02_canceled_lm;input_sdf_AD02_nostop_lm],'color',labels_value_lm);
stopsignal_ERP_fig(1,2).stat_summary();
stopsignal_ERP_fig(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
stopsignal_ERP_fig(1,2).set_color_options('map',[colors.canceled;colors.nostop]);
stopsignal_ERP_fig(1,2).set_names('x','Time from Stop-Signal (ms)','y','EEG (uV)');

stopsignal_ERP_fig(2,2)=gramm('x',timewins.sdf,'y',[input_sdf_AD03_canceled_lm;input_sdf_AD03_nostop_lm],'color',labels_value_lm);
stopsignal_ERP_fig(2,2).stat_summary();
stopsignal_ERP_fig(2,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
stopsignal_ERP_fig(2,2).set_names('x','Time from Stop-Signal (ms)','y','EEG (uV)');
stopsignal_ERP_fig(2,2).set_color_options('map',[colors.canceled;colors.nostop]);
stopsignal_ERP_fig(2,2).facet_grid([],monkey_label);

stopsignal_ERP_fig_out = figure('Renderer', 'painters', 'Position', [100 100 1000 500]);
stopsignal_ERP_fig.draw();

%% Export: Save figure
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','pop_figure_stopsignal_ERP.pdf');
set(stopsignal_ERP_fig_out,'PaperSize',[20 10]); %set the paper size to what you want
print(stopsignal_ERP_fig_out,filename,'-dpdf') % then print it
close(stopsignal_ERP_fig_out)

clear stopsignal_ERP_fig input_sdf_* plot_EEG_*
