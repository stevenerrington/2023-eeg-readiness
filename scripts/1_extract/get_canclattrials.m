function [ttx_canc_lat, ttx_noncanc_lat] = get_canclattrials(executiveBeh)

for session_i = 1:29
    n_ssds = length(executiveBeh.inh_SSD{session_i});

    ttx_canc_lat.left{session_i} = [];     ttx_canc_lat.right{session_i} = [];
    ttx_noncanc_lat.left{session_i} = [];     ttx_noncanc_lat.right{session_i} = [];

    for ssd_i = 1:n_ssds
        ttx_canc_lat.left{session_i} = [ttx_canc_lat.left{session_i}; executiveBeh.ttm_c.C{session_i, ssd_i}.left];
        ttx_canc_lat.right{session_i} = [ttx_canc_lat.right{session_i}; executiveBeh.ttm_c.C{session_i, ssd_i}.right];
      
        ttx_noncanc_lat.left{session_i} = [ttx_canc_lat.left{session_i}; executiveBeh.ttm_c.NC{session_i, ssd_i}.left];
        ttx_noncanc_lat.right{session_i} = [ttx_canc_lat.right{session_i}; executiveBeh.ttm_c.NC{session_i, ssd_i}.right];

    end

end



