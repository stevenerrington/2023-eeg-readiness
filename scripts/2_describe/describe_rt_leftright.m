%% Extract: get RT's for left and right saccades across sessions
for session_i = 1:29
   left_saccade_trials = [];
   left_saccade_trials = executiveBeh.ttx.GO_Left{session_i};

   right_saccade_trials = [];
   right_saccade_trials = executiveBeh.ttx.GO_Right{session_i};
   
   left_RT = [];
   left_RT = executiveBeh.TrialEventTimes_Overall{session_i}(left_saccade_trials,4)-...
        executiveBeh.TrialEventTimes_Overall{session_i}(left_saccade_trials,2);
    
    right_RT = [];
    right_RT = executiveBeh.TrialEventTimes_Overall{session_i}(right_saccade_trials,4)-...
        executiveBeh.TrialEventTimes_Overall{session_i}(right_saccade_trials,2);

    
     rt_analysis.RT_raw.left{session_i,1} = left_RT;
     rt_analysis.RT_raw.right{session_i,1} = right_RT;

        
        
    rt_analysis.RT_median.left(session_i,1) = nanmedian(left_RT);
    rt_analysis.RT_median.right(session_i,1) = nanmedian(right_RT);
    rt_analysis.RT_median.diff(session_i,1) = nanmedian(left_RT)-nanmedian(right_RT);
    rt_analysis.comparison.left_right(session_i,1) = ranksum(left_RT,right_RT);

end


fprintf('The average median RT for left targets across sessions was %1.1f ms \n', mean(rt_analysis.RT_median.left))
fprintf('The average median RT for right targets across sessions was %1.1f ms \n', mean(rt_analysis.RT_median.right))
fprintf('The average diff RT was %1.1f ms \n', mean(rt_analysis.RT_median.diff))

fprintf('%i sessions had significant differences between left and right RTs \n', sum(rt_analysis.comparison.left_right < 0.05) )

[p, h , stats] = ranksum(rt_analysis.RT_median.left,rt_analysis.RT_median.right);


%% Trial-matching: left and right saccades

for session_i = 1:29
   left_saccade_trials = [];
   left_saccade_trials = executiveBeh.ttx.GO_Left{session_i};

   right_saccade_trials = [];
   right_saccade_trials = executiveBeh.ttx.GO_Right{session_i};
   
   A = []; B=[];
   [A, B,  ~,  ~] =...
        distOverlap([left_saccade_trials rt_analysis.RT_raw.left{session_i,1}],...
        [right_saccade_trials rt_analysis.RT_raw.right{session_i,1}], 10);
    
    ttx_matched.left{session_i} = A(:,1);
    ttx_matched.right{session_i} = B(:,1);
    
end