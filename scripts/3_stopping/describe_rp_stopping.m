
%% Analyse: Extract ERP for left and right no-stop trials
% Initialize the arrays
EEG_saccade_left = [];
EEG_saccade_right = [];

% For each session
for session = 1:29
    % Find the lateral channels
    for ch_index = 2:3

        channel = channel_list{ch_index};

        EEG_stopping_left{ch_index}(session,:) = nanmean( EEG_signal.stopSignal{session,ch_index}(ttx_canc_lat.left{session},:));
        EEG_stopping_right{ch_index}(session,:) = nanmean( EEG_signal.stopSignal{session,ch_index}(ttx_canc_lat.right{session},:));

    end
end


%% Figure: Population EEG for left/right target

for session = 1:29
    plot_EEG_left_A(session,:)  = EEG_stopping_left{2}(session,:);
    plot_EEG_right_A(session,:) = EEG_stopping_right{2}(session,:);

end

input_sdf_left_A = num2cell(plot_EEG_left_A, 2);
input_sdf_right_A = num2cell(plot_EEG_right_A, 2);

xlim_input = [-200 600];
ylim_input = [-10 10];
timewins.sdf = -999:2000;

labels_value = [repmat({'1_Left'},length(input_sdf_left_A),1);repmat({'2_Right'},length(input_sdf_right_A),1)];
monkey_label = [repmat(executiveBeh.nhpSessions.monkeyNameLabel,2,1)];

% Produce the figure, collapsed across all monkeys
time_electrode_AUC(1,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
time_electrode_AUC(1,1).stat_summary();
time_electrode_AUC(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(1,1).set_names('x','Time from Target (ms)','y','EEG (uV)');

time_electrode_AUC(2,1)=gramm('x',timewins.sdf,'y',[input_sdf_left_A;input_sdf_right_A],'color',labels_value);
time_electrode_AUC(2,1).stat_summary();
time_electrode_AUC(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(2,1).set_names('x','Time from Target (ms)','y','EEG (uV)');
time_electrode_AUC(2,1).facet_grid([],monkey_label);

time_electrode_AUC(1,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
time_electrode_AUC(1,2).stat_summary();
time_electrode_AUC(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(1,2).set_names('x','Time from Target (ms)','y','EEG (uV)');

time_electrode_AUC(2,2)=gramm('x',timewins.sdf,'y',[input_sdf_left_B;input_sdf_right_B],'color',labels_value);
time_electrode_AUC(2,2).stat_summary();
time_electrode_AUC(2,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
time_electrode_AUC(2,2).set_names('x','Time from Target (ms)','y','EEG (uV)');
time_electrode_AUC(2,2).facet_grid([],monkey_label);

RP_A_figure_out = figure('Renderer', 'painters', 'Position', [100 100 1500 800]);
time_electrode_AUC.draw();

%%
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','pop_figure_rp_target.pdf');
set(RP_A_figure_out,'PaperSize',[20 10]); %set the paper size to what you want
print(RP_A_figure_out,filename,'-dpdf') % then print it
close(RP_A_figure_out)

clear RP_A_figure input_sdf_* plot_EEG_*
