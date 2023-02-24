function ttx_canc_lat = get_canclattrials(executiveBeh)

clear ttx_canc*

for session_i = 1:29
    n_ssds = length(executiveBeh.inh_SSD{session_i});

    ttx_canc_lat.left{session_i} = [];     ttx_canc_lat.right{session_i} = [];

    for ssd_i = 1:n_ssds
        ttx_canc_lat.left{session_i} = [ttx_canc_lat.left{session_i}; executiveBeh.ttm_c.C{session_i, ssd_i}.left];
        ttx_canc_lat.right{session_i} = [ttx_canc_lat.right{session_i}; executiveBeh.ttm_c.C{session_i, ssd_i}.right];
    end

end



