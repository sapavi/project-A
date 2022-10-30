clc
close all
clear

%%  data extraction

enfo = load("data_E4Wristband\1661942085_A033B7\BVP.csv");
record = enfo(3:end);
HZ_record = enfo(2);
time = 0:1/HZ_record:(size(record,1)-1)/HZ_record;
tmp =  load('data_E4Wristband\1661942085_A033B7\HR.csv');
real_HR = tmp(3:end);
HZ_HR = tmp(2);
time_HR = 0:1/HZ_HR:ceil(size(real_HR,1)/HZ_HR)-1;

%% Running the algorithm

[HR_auto,time_auto] = find_hr_autocorrelation_updated(record,HZ_record,size(record,1));
%[HR_auto,time_auto] = find_hr_autocorrelation(record,HZ_record,size(record,1));
[HR_pan,time_pan] = find_hr_pan_and_topkin(record,HZ_record,size(record,1));
[HR_flip,time_flip] = find_hr_flip(record, HZ_record, size(record,1));
[HR_ex_algo, time_ex_algo] = find_hr_ex_algo(record, HZ_record);

%% See PPG

figure;

plot(time,record)
title('PPG');
xlabel('Time [sec]');
ylabel('PPG');
legend('PPG');

%% Compare between Autocorrelation and Pan and Tompkins

figure;
plot(time_auto, HR_auto,'m-*',time_pan, HR_pan,'b-*', time_ex_algo, HR_ex_algo, 'g-*', time_flip, HR_flip, 'c-*', time_HR ,real_HR , 'r-*');
title('E4 Wristband');
xlabel('Time [sec]');
ylabel('HR');
legend('Autocorrelation', 'Pan and Tompkins', 'External algorithm', 'Flip', 'HR E4');

