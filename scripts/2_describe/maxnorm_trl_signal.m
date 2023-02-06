function signal_in_norm = maxnorm_trl_signal(signal_in, norm_window)

for trl_i = 1:size(signal_in,1)
    signal_in_norm(trl_i,:) = signal_in(trl_i,:)./max(abs(signal_in(trl_i,norm_window)));    
end

end


