function error_find = find_error(hr, time, hr_ppg, time_ppg)
    
    error_ppg = 0;
    size_error_ppg = 0;
    iter_ppg = 1;
    
    for i = 1:size(time,1)
        if time(i)<time_ppg(iter_ppg)
        else 
            if iter_ppg > size(time_ppg,1)
                break
            else
                error_ppg = error_ppg + abs(hr(i) - hr_ppg(iter_ppg))/hr(i);
                iter_ppg = iter_ppg + 1;
                size_error_ppg = size_error_ppg + 1;
            end
        end
    end
    error_find = error_ppg/size_error_ppg;
end