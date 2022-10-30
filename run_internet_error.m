clc
close all
clear

page = fopen("data_Address_internet.txt");
line = fgetl(page);
num_line = 0;

error_r_d_tot = [0,0,0,0];
error_r_d_auto = 0;
error_r_d_pan = 0;
error_ir_d_tot = [0,0,0,0];
error_ir_d_auto = 0;
error_ir_d_pan = 0;
error_g_d_tot = [0,0,0,0];
error_g_d_auto = 0;
error_g_d_pan = 0;
error_r_p_tot = [0,0,0,0];
error_r_p_auto = 0;
error_r_p_pan = 0;
error_ir_p_tot = [0,0,0,0];
error_ir_p_auto = 0;
error_ir_p_pan = 0;
error_g_p_tot = [0,0,0,0];
error_g_p_auto = 0;
error_g_p_pan = 0;

while ischar(line)
    [error_r_d,error_ir_d,error_g_d,error_r_p,error_ir_p,error_g_p] = error_internet_database(line);
    num_line = num_line + 1;

    error_r_d_tot = tot(error_r_d_tot,error_r_d);
    if isnan(error_r_d(1))
        error_r_d_auto(end+1) = num_line;
    end
    if isnan(error_r_d(2))
        error_r_d_pan(end+1) = num_line;
    end

    error_ir_d_tot = tot(error_ir_d_tot,error_ir_d);
    if isnan(error_ir_d(1))
        error_ir_d_auto(end+1) = num_line;
    end
    if isnan(error_ir_d(2))
        error_ir_d_pan(end+1) = num_line;
    end

    error_g_d_tot = tot(error_g_d_tot,error_g_d);
    if isnan(error_g_d(1))
        error_g_d_auto(end+1) = num_line;
    end
    if isnan(error_g_d(2))
        error_g_d_pan(end+1) = num_line;
    end

    error_r_p_tot = tot(error_r_p_tot,error_r_p);
    if isnan(error_r_p(1))
        error_r_p_auto(end+1) = num_line;
    end
    if isnan(error_r_p(2))
        error_r_p_pan(end+1) = num_line;
    end
    
    error_ir_p_tot = tot(error_ir_p_tot,error_ir_p);
    if isnan(error_ir_p(1))
        error_ir_p_auto(end+1) = num_line;
    end
    if isnan(error_ir_p(2))
        error_ir_p_pan(end+1) = num_line;
    end

    error_g_p_tot = tot(error_g_p_tot,error_g_p);
    if isnan(error_g_p(1))
        error_g_p_auto(end+1) = num_line;
    end
    if isnan(error_g_p(2))
        error_g_p_pan(end+1) = num_line;
    end
    line = fgetl(page);
end

error_r_d_tot(1) = error_r_d_tot(1)/error_r_d_tot(3);
error_ir_d_tot(1) = error_ir_d_tot(1)/error_ir_d_tot(3);
error_g_d_tot(1) = error_g_d_tot(1)/error_g_d_tot(3);
error_r_p_tot(1) = error_r_p_tot(1)/error_r_p_tot(3);
error_ir_p_tot(1) = error_ir_p_tot(1)/error_ir_p_tot(3);
error_g_p_tot(1) = error_g_p_tot(1)/error_g_p_tot(3);

error_r_d_tot(2) = error_r_d_tot(2)/error_r_d_tot(4);
error_ir_d_tot(2) = error_ir_d_tot(2)/error_ir_d_tot(4);
error_g_d_tot(2) = error_g_d_tot(2)/error_g_d_tot(4);
error_r_p_tot(2) = error_r_p_tot(2)/error_r_p_tot(4);
error_ir_p_tot(2) = error_ir_p_tot(2)/error_ir_p_tot(4);
error_g_p_tot(2) = error_g_p_tot(2)/error_g_p_tot(4);


clear page num_line line error_r_d error_ir_d error_g_d error_r_p error_ir_p error_g_p

auto = [error_r_d_tot(1), error_ir_d_tot(1), error_g_d_tot(1), error_r_p_tot(1), error_ir_p_tot(1), error_g_p_tot(1)];
pan = [error_r_d_tot(2), error_ir_d_tot(2), error_g_d_tot(2), error_r_p_tot(2), error_ir_p_tot(2), error_g_p_tot(2)];
auto_percent = auto*100;
pan_percent = pan*100;
figure;
subplot(2,1,1);
stem(auto_percent);
title('Autocorrelation');
legend('red, distal', 'infrared, distal', 'green, distal', 'red, proximal', 'infrared, proximal', 'green, proximal');
subplot(2,1,2);
stem (pan_percent);
title('Pan and Topkin');
legend('red, distal', 'infrared, distal', 'green, distal', 'red, proximal', 'infrared, proximal', 'green, proximal');
sgtitle('error');


function error_tot = tot(error_tot, error)

    if isnan(error(1))
    else
        error_tot(1) = error_tot(1) + error(1);
        error_tot(3) = error_tot(3)+1;
    end

    if isnan(error(2))
    else
        error_tot(2) = error_tot(2) + error(2);
        error_tot(4) = error_tot(4)+1;
    end

end



function [error_r_d,error_ir_d,error_g_d,error_r_p,error_ir_p,error_g_p] = error_internet_database(name)


%%  data extraction

    info = readtable(name);
    peak_hr = table2array(info(:,3));
    ppg_R_d = table2array(info(:,4)); %red  d = distal phalanx
    ppg_IR_d = table2array(info(:,5)); %infrared
    ppg_G_d =table2array(info(:,6)); %green
    ppg_R_p = table2array(info(:,7)); %red  p = proximal phalanx
    ppg_IR_p = table2array(info(:,8)); %infrared
    ppg_G_p = table2array(info(:,9)); %green
    HZ = 500;
    size_tmp = size(peak_hr);

%% Running the algorithm

    [HR_R_d_auto,time_R_d_auto] = find_hr_autocorrelation_updated(ppg_R_d, HZ, size_tmp(1));
    [HR_R_d_pan,time_R_d_pan] = find_hr_pan_and_topkin(ppg_R_d, HZ, size_tmp(1));

    [HR_IR_d_auto,time_IR_d_auto] = find_hr_autocorrelation_updated(ppg_IR_d, HZ, size_tmp(1));
    [HR_IR_d_pan,time_IR_d_pan] = find_hr_pan_and_topkin(ppg_IR_d, HZ, size_tmp(1));

    [HR_G_d_auto,time_G_d_auto] = find_hr_autocorrelation_updated(ppg_G_d, HZ, size_tmp(1));
    [HR_G_d_pan,time_G_d_pan] = find_hr_pan_and_topkin(ppg_G_d, HZ, size_tmp(1));

    [HR_R_p_auto,time_R_p_auto] = find_hr_autocorrelation_updated(ppg_R_p, HZ, size_tmp(1));
    [HR_R_p_pan,time_R_p_pan] = find_hr_pan_and_topkin(ppg_R_p, HZ, size_tmp(1));

    [HR_IR_p_auto,time_IR_p_auto] = find_hr_autocorrelation_updated(ppg_IR_p, HZ, size_tmp(1));
    [HR_IR_p_pan,time_IR_p_pan] = find_hr_pan_and_topkin(ppg_IR_p, HZ, size_tmp(1));

    [HR_G_p_auto,time_G_p_auto] = find_hr_autocorrelation_updated(ppg_G_p, HZ, size_tmp(1));
    [HR_G_p_pan,time_G_p_pan] = find_hr_pan_and_topkin(ppg_G_p, HZ, size_tmp(1));

    [peaks, index] = findpeaks(peak_hr);
    diff_peaks = diff(index);
    tmp_size = size(diff_peaks);
    hr = zeros(1,tmp_size(1));
    for i = 1:tmp_size(1)
        hr(i) = 60*HZ/(diff_peaks(i));
    end
    time = index(1:end-1)./HZ;

%% error
    error_r_d(1) = find_error(hr, time, HR_R_d_auto, time_R_d_auto);
    error_r_d(2) = find_error(hr, time, HR_R_d_pan, time_R_d_pan);
    error_ir_d(1) = find_error(hr, time, HR_IR_d_auto, time_IR_d_auto);
    error_ir_d(2) = find_error(hr, time, HR_IR_d_pan, time_IR_d_pan);
    error_g_d(1) = find_error(hr, time, HR_G_d_auto, time_G_d_auto);
    error_g_d(2) = find_error(hr, time, HR_G_d_pan, time_G_d_pan);
    error_r_p(1) = find_error(hr, time, HR_R_p_auto, time_R_p_auto);
    error_r_p(2) = find_error(hr, time, HR_R_p_pan, time_R_p_pan);
    error_ir_p(1) = find_error(hr, time, HR_IR_p_auto, time_IR_p_auto);
    error_ir_p(2) = find_error(hr, time, HR_IR_p_pan, time_IR_p_pan);
    error_g_p(1) = find_error(hr, time, HR_G_p_auto, time_G_p_auto);
    error_g_p(2) = find_error(hr, time, HR_G_p_pan, time_G_p_pan);

end




