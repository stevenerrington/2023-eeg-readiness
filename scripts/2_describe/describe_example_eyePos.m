
% Define example session
session_i = 1;

% Admin: update the user
clc; fprintf('Extracting data from %s... | file %i of %i \n',FileNames{session_i}, session_i, 29);

% Load in the raw data files with eye positions
data_in = load(fullfile(dirs.raw_data,FileNames{session_i}));

% Define parameters for alignment
alignmentParameters.eventN = 2;
alignmentParameters.alignWin = [-1000 2000];
eventTimes = executiveBeh.TrialEventTimes_Overall{session_i};

% Align eye signals on target onset
aligned_eyeX = align_signal(data_in.EyeX_,...
    1:size(eventTimes,1),...
    eventTimes, alignmentParameters.eventN, alignmentParameters.alignWin);
aligned_eyeY = align_signal(data_in.EyeY_,...
    1:size(eventTimes,1),...
    eventTimes, alignmentParameters.eventN, alignmentParameters.alignWin);

% Collapse NS trials for left and rightward saccades
lr_ns_trials = [executiveBeh.ttx.GO_Left{session_i};executiveBeh.ttx.GO_Right{session_i}];

% For each saccade trial
for trl_i = 1:length(lr_ns_trials)
    
    % Get the RT
    trl_n = lr_ns_trials(trl_i);
    RT = executiveBeh.TrialEventTimes_Overall{session_i}(trl_n,4)-...
        executiveBeh.TrialEventTimes_Overall{session_i}(trl_n,2);
    
    % And get the eye position 50 ms after the saccade started
    x(trl_i,1) = aligned_eyeX(trl_n,1000+RT+50);
    y(trl_i,1) = aligned_eyeY(trl_n,1000+RT+50);

end


%% Figure: produce eye position figure
% Define parameters of figure
colormap = cool(2);
time_window = [-100 600];
x_lim_posWindow = [-15 15];
y_lim_posWindow = [-10 10];

% Create figure window
saccade_pos_figure = figure('Renderer', 'painters', 'Position', [100 100 300 600]);

% Plot: trial-by-trial x-position
subplot(2,1,1); hold on
plot(aligned_eyeX(executiveBeh.ttx.GO_Left{session_i},:),-999:2000,'color',[colormap(1,:) 0.1])
hold on
plot(aligned_eyeX(executiveBeh.ttx.GO_Right{session_i},:),-999:2000,'color',[colormap(2,:) 0.1])
ylim(time_window); xlim(x_lim_posWindow); set(gca,'YDir','Reverse')
grid on; box off; set(gca,'TickDir','out')

% Plot: trial-by-trial final saccade position
subplot(2,1,2); hold on
for trl_i = 1:length(lr_ns_trials)
    if x(trl_i) > 0
        color_i = [colormap(1,:) 0.1];
    else
        color_i = [colormap(2,:) 0.1];
    end
    
    line([0 x(trl_i,1)], [0 y(trl_i,1)],'color',color_i);
    scatter(x(trl_i,1),y(trl_i,1),0.5,'k+');
end
xlim(x_lim_posWindow); ylim(y_lim_posWindow)
grid on; box off; set(gca,'TickDir','out');

%% Export: save figure
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','saccade_pos_figure.pdf');
set(saccade_pos_figure,'PaperSize',[20 10]); %set the paper size to what you want
print(saccade_pos_figure,filename,'-dpdf') % then print it
close(saccade_pos_figure)

