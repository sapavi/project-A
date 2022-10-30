clc
close all
clear

%% data extraction

%{
C = readcell('data_analog_evaluation_module\First_set_of_samples\sapir_work_index_1\Device_Volts_20220224_094725.xls','FileType','text','Delimiter','\t');
info_cell = C(5:end,:);
info_num = cell2mat(info_cell);
RED = info_num(:,1);
IR = info_num(:,2);
ch_RED_def = info_num(:,5);
ch_IR_def = info_num(:,6);
%}


%%{
info_table = readtable("data_analog_evaluation_module\Second_set_of_sampls\Measurement_number_1\Device_Volts_20220831_134106.csv");
info_num = table2array(info_table);
RED = info_num(:,1);
IR = info_num(:,2);
%%}

HZ = 500;
size_tmp = size(RED);
T = 1/HZ;
time = 0:T:(size_tmp-1)/HZ;


%% Running the algorithm

[HR_RED_auto,time_RED_auto] = find_hr_autocorrelation_updated(RED, HZ, size_tmp(1));
%[HR_RED_auto,time_RED_auto] = find_hr_autocorrelation(RED, HZ, size_tmp(1));
[HR_RED_pan,time_RED_pan] = find_hr_pan_and_topkin(RED, HZ, size_tmp(1));
[HR_RED_ex_algo,time_RED_ex_algo] = find_hr_ex_algo(RED, HZ);
[HR_RED_flip,time_RED_flip] = find_hr_flip(RED, HZ, size_tmp(1));

[HR_IR_auto,time_IR_auto] = find_hr_autocorrelation_updated(IR, HZ, size_tmp(1));
%[HR_IR_auto,time_IR_auto] = find_hr_autocorrelation(IR, HZ, size_tmp(1));
[HR_IR_pan,time_IR_pan] = find_hr_pan_and_topkin(IR, HZ, size_tmp(1));
[HR_IR_ex_algo,time_IR_ex_algo] = find_hr_ex_algo(IR, HZ);
[HR_IR_flip,time_IR_flip] = find_hr_flip(IR, HZ, size_tmp(1));



%% See PPG

figure;

subplot(2,1,1);
plot(time,RED)
title('RED');
xlabel('Time [sec]');
ylabel('PPG');
legend('PPG');

subplot(2,1,2);
plot(time,IR)
title('Infra-Red');
xlabel('Time [sec]');
ylabel('PPG');
legend('PPG');

%{
figure;

subplot(2,1,1);
%plot(time_RED_auto, HR_RED_auto,'m-*',time_RED_pan, HR_RED_pan,'b-*', time_RED_flip, HR_RED_flip, 'c-*');
plot(time_RED_auto, HR_RED_auto,'m-*',time_RED_pan, HR_RED_pan,'b-*', time_RED_ex_algo, HR_RED_ex_algo, 'g-*', time_RED_flip, HR_RED_flip, 'C-*');
title('RED HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Autocorrelation', 'Pan and Tompkins', 'Flip', 'External algorithm');
%legend('Autocorrelation', 'Pan and Tompkins', 'ex algo', 'flip');

subplot(2,1,2);
%plot(time_IR_auto, HR_IR_auto,'m-*',time_IR_pan, HR_IR_pan,'b-*', time_IR_flip, HR_IR_flip, 'C-*');
plot(time_IR_auto, HR_IR_auto,'m-*',time_IR_pan, HR_IR_pan,'b-*', time_IR_ex_algo, HR_IR_ex_algo, 'g-*', time_IR_flip, HR_IR_flip, 'C-*');
title('Infra-Red HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Autocorrelation', 'Pan and Tompkins', 'Flip', 'External algorithm');
%legend('Autocorrelation', 'Pan and Tompkins', 'ex algo', 'flip');

sgtitle('Compare between The different methods')

%}

%% Compare between RED and IR

figure;

subplot(4,1,1);
plot(time_RED_auto, HR_RED_auto,'m-*',time_IR_auto, HR_IR_auto,'b-*');
title('Autocorrelation HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red');

subplot(4,1,2);
plot(time_RED_pan, HR_RED_pan,'m-*',time_IR_pan, HR_IR_pan,'b-*');
title('Pan and Topkin HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red');

subplot(4,1,3);
plot(time_RED_flip, HR_RED_flip,'m-*',time_IR_flip, HR_IR_flip,'b-*');
title('Flip HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red');

subplot(4,1,4);
plot(time_RED_ex_algo, HR_RED_ex_algo,'m-*',time_IR_ex_algo, HR_IR_ex_algo,'b-*');
title('External algorithm HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red');

sgtitle('Compare between RED and Infra-Red')
