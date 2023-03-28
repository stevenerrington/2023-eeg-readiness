function nostop_speed_trls = get_rtspeed_trls(executiveBeh,ttx_matched)

for session_i = 1:29
    RT_nostop_trls_left = [];
    RT_nostop_trls_left = ttx_matched.left{session_i};
    
    RT_nostop_trls_right = [];
    RT_nostop_trls_right = ttx_matched.right{session_i};
    
    RT_nostop_left = [];
    RT_nostop_left(:,1) = executiveBeh.TrialEventTimes_Overall{session_i}(RT_nostop_trls_left,4)-...
        executiveBeh.TrialEventTimes_Overall{session_i}(RT_nostop_trls_left,2);
    
    RT_nostop_right = [];
    RT_nostop_right(:,1) = executiveBeh.TrialEventTimes_Overall{session_i}(RT_nostop_trls_right,4)-...
        executiveBeh.TrialEventTimes_Overall{session_i}(RT_nostop_trls_right,2);
    
    cutoff_left =  median(RT_nostop_left);
    cutoff_right =  median(RT_nostop_right);
    
    nostop_speed_trls{session_i}.fast.left = RT_nostop_trls_left(RT_nostop_left <= cutoff_left);
    nostop_speed_trls{session_i}.slow.left = RT_nostop_trls_left(RT_nostop_left >= cutoff_left);
    nostop_speed_trls{session_i}.fast.right = RT_nostop_trls_right(RT_nostop_right <= cutoff_right);
    nostop_speed_trls{session_i}.slow.right = RT_nostop_trls_right(RT_nostop_right >= cutoff_right);
end

end
