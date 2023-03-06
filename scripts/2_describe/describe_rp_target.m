
%% Analyse: Extract ERP for left and right no-stop trials
% Initialize the arrays
EEG_saccade_left = [];
EEG_saccade_right = [];

% For each session
for session = 1:29
    % Find the lateral channels
    for ch_index = 2:3

        channel = channel_list{ch_index};

        EEG_target_left{ch_index}(session,:) = nanmean( EEG_signal.target{session,ch_index}(executiveBeh.ttx.GO_Left{session},:));
        EEG_target_right{ch_index}(session,:) = nanmean( EEG_signal.target{session,ch_index}(executiveBeh.ttx.GO_Right{session},:));

        EEG_saccade_left{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(executiveBeh.ttx.GO_Left{session},:));
        EEG_saccade_right{ch_index}(session,:) = nanmean( EEG_signal.saccade{session,ch_index}(executiveBeh.ttx.GO_Right{session},:));

    end
end


%% Figure: Population EEG for left/right target

for session = 1:29
    plot_EEG_left_A(session,:)  = EEG_target_left{2}(session,:);
    plot_EEG_right_A(session,:) = EEG_target_right{2}(session,:);

    plot_EEG_left_B(session,:)  = EEG_target_left{3}(session,:);
    plot_EEG_right_B(session,:) = EEG_target_right{3}(session,:);

end

input_sdf_left_A = num2cell(plot_EEG_left_A, 2);
input_sdf_right_A = num2cell(plot_EEG_right_A, 2);
input_sdf_left_B = num2cell(plot_EEG_left_B, 2);
input_sdf_right_B = num2cell(plot_EEG_right_B, 2);

xlim_input = [-200 600];
ylim_input = [-0.010 0.010];
timewins.sdf = -999:2000;

labels_value = [repmat({'1_Left'},length(input_sdf_left_A),1);repmat({'2_Right'},length(input_sdf_right_A),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];

% Produce the figure, collapsed across all monkeys
rp_erp_target(1,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
rp_erp_target(1,1).stat_summary();
rp_erp_target(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
rp_erp_target(1,1).set_names('x','Time from Target (ms)','y','EEG (uV)');

rp_erp_target(2,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
rp_erp_target(2,1).stat_summary();
rp_erp_target(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
rp_erp_target(2,1).set_names('x','Time from Target (ms)','y','EEG (uV)');
rp_erp_target(2,1).facet_grid([],monkey_label);

rp_erp_target(1,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
rp_erp_target(1,2).stat_summary();
rp_erp_target(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
rp_erp_target(1,2).set_names('x','Time from Target (ms)','y','EEG (uV)');

rp_erp_target(2,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
rp_erp_target(2,2).stat_summary();
rp_erp_target(2,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
rp_erp_target(2,2).set_names('x','Time from Target (ms)','y','EEG (uV)');
rp_erp_target(2,2).facet_grid([],monkey_label);

RP_A_figure_out = figure('Renderer', 'painters', 'Position', [100 100 1500 800]);
rp_erp_target.draw();

%%
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','pop_figure_rp_target.pdf');
set(RP_A_figure_out,'PaperSize',[20 10]); %set the paper size to what you want
print(RP_A_figure_out,filename,'-dpdf') % then print it
close(RP_A_figure_out)

clear RP_A_figure input_sdf_* plot_EEG_*
