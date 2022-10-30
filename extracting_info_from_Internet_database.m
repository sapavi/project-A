 
clc
close all
clear

%%  data extraction

info = readtable('data_Internet_database\data_info\s10_sit.csv');
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
%[HR_R_d_auto,time_R_d_auto] = find_hr_autocorrelation(ppg_R_d, HZ, size_tmp(1));
[HR_R_d_pan,time_R_d_pan] = find_hr_pan_and_topkin(ppg_R_d, HZ, size_tmp(1));
[HR_R_d_ex_algo,time_R_d_ex_algo] = find_hr_ex_algo(ppg_R_d, HZ);
[HR_R_d_flip,time_R_d_flip] = find_hr_flip(ppg_R_d, HZ, size_tmp(1));

[HR_IR_d_auto,time_IR_d_auto] = find_hr_autocorrelation_updated(ppg_IR_d, HZ, size_tmp(1));
%[HR_IR_d_auto,time_IR_d_auto] = find_hr_autocorrelation(ppg_IR_d, HZ, size_tmp(1));
[HR_IR_d_pan,time_IR_d_pan] = find_hr_pan_and_topkin(ppg_IR_d, HZ, size_tmp(1));
[HR_IR_d_ex_algo,time_IR_d_ex_algo] = find_hr_ex_algo(ppg_IR_d, HZ);
[HR_IR_d_flip,time_IR_d_flip] = find_hr_flip(ppg_IR_d, HZ, size_tmp(1));

[HR_G_d_auto,time_G_d_auto] = find_hr_autocorrelation_updated(ppg_G_d, HZ, size_tmp(1));
%[HR_G_d_auto,time_G_d_auto] = find_hr_autocorrelation(ppg_G_d, HZ, size_tmp(1));
[HR_G_d_pan,time_G_d_pan] = find_hr_pan_and_topkin(ppg_G_d, HZ, size_tmp(1));
[HR_G_d_ex_algo,time_G_d_ex_algo] = find_hr_ex_algo(ppg_G_d, HZ);
[HR_G_d_flip,time_G_d_flip] = find_hr_flip(ppg_G_d, HZ, size_tmp(1));

[HR_R_p_auto,time_R_p_auto] = find_hr_autocorrelation_updated(ppg_R_p, HZ, size_tmp(1));
%[HR_R_p_auto,time_R_p_auto] = find_hr_autocorrelation(ppg_R_p, HZ, size_tmp(1));
[HR_R_p_pan,time_R_p_pan] = find_hr_pan_and_topkin(ppg_R_p, HZ, size_tmp(1));
[HR_R_p_ex_algo,time_R_p_ex_algo] = find_hr_ex_algo(ppg_R_p, HZ);
[HR_R_p_flip,time_R_p_flip] = find_hr_flip(ppg_R_p, HZ, size_tmp(1));

[HR_IR_p_auto,time_IR_p_auto] = find_hr_autocorrelation_updated(ppg_IR_p, HZ, size_tmp(1));
%[HR_IR_p_auto,time_IR_p_auto] = find_hr_autocorrelation(ppg_IR_p, HZ, size_tmp(1));
[HR_IR_p_pan,time_IR_p_pan] = find_hr_pan_and_topkin(ppg_IR_p, HZ, size_tmp(1));
[HR_IR_p_ex_algo,time_IR_p_ex_algo] = find_hr_ex_algo(ppg_IR_p, HZ);
[HR_IR_p_flip,time_IR_p_flip] = find_hr_flip(ppg_IR_p, HZ, size_tmp(1));

[HR_G_p_auto,time_G_p_auto] = find_hr_autocorrelation_updated(ppg_G_p, HZ, size_tmp(1));
%[HR_G_p_auto,time_G_p_auto] = find_hr_autocorrelation(ppg_G_p, HZ, size_tmp(1));
[HR_G_p_pan,time_G_p_pan] = find_hr_pan_and_topkin(ppg_G_p, HZ, size_tmp(1));
[HR_G_p_ex_algo,time_G_p_ex_algo] = find_hr_ex_algo(ppg_G_p, HZ);
[HR_G_p_flip,time_G_p_flip] = find_hr_flip(ppg_G_p, HZ, size_tmp(1));

[peaks, index] = findpeaks(peak_hr);
diff_peaks = diff(index);
tmp_size = size(diff_peaks);
hr = zeros(1,tmp_size(1));
for i = 1:tmp_size(1)
    hr(i) = 60*HZ/(diff_peaks(i));
end
time = index(1:end-1)./HZ;

time_IR_d = 0:1/HZ:(size(ppg_IR_d,1)-1)/HZ;
time_IR_p = 0:1/HZ:(size(ppg_IR_p,1)-1)/HZ;


%% plot ppg

figure;
subplot(2,1,1)
plot(time_IR_d,ppg_IR_d);
title('Infra-Red distal phalanx');
xlabel('Time [sec]');
ylabel('ppg');
subplot(2,1,2)
plot(time_IR_p,ppg_IR_p);
title('Infra-Red proximal phalanx');
xlabel('Time [sec]');
ylabel('ppg');
%% Compare distal phalanx and proximal phalanx

figure;

subplot(4,1,1);
plot(time_R_d_auto, HR_R_d_auto,'m-*',time_R_p_auto, HR_R_p_auto,'b-*', time, hr ,'r-*');
title('Autocorrelation HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx', 'Reference');

subplot(4,1,2);
plot(time_R_d_pan, HR_R_d_pan,'m-*',time_R_p_pan, HR_R_p_pan,'b-*', time, hr ,'r-*');
title('Pan and Topkin HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

subplot(4,1,3);
plot(time_R_d_ex_algo, HR_R_d_ex_algo,'m-*',time_R_p_ex_algo, HR_R_p_ex_algo,'b-*', time, hr ,'r-*');
title('External algorithm HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

subplot(4,1,4);
plot(time_R_d_flip, HR_R_d_flip,'m-*',time_R_p_flip, HR_R_p_flip,'b-*', time, hr ,'r-*');
title('Flip HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

sgtitle('Compare between distal and proximal in RED color')


figure;

subplot(4,1,1);
plot(time_IR_d_auto, HR_IR_d_auto,'m-*',time_IR_p_auto, HR_IR_p_auto,'b-*', time, hr ,'r-*');
title('Autocorrelation HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

subplot(4,1,2);
plot(time_IR_d_pan, HR_IR_d_pan,'m-*',time_IR_p_pan, HR_IR_p_pan,'b-*', time, hr ,'r-*');
title('Pan and Topkin HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

subplot(4,1,3);
plot(time_IR_d_ex_algo, HR_IR_d_ex_algo,'m-*',time_IR_p_ex_algo, HR_IR_p_ex_algo,'b-*', time, hr ,'r-*');
title('External algorithm HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

subplot(4,1,4);
plot(time_IR_d_flip, HR_IR_d_flip,'m-*',time_IR_p_flip, HR_IR_p_flip,'b-*', time, hr ,'r-*');
title('Flip HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

sgtitle('Compare between distal and proximal in Infra-Red color')


figure;

subplot(4,1,1);
plot(time_G_d_auto, HR_G_d_auto,'m-*',time_G_p_auto, HR_G_p_auto,'b-*', time, hr ,'r-*');
title('Autocorrelation HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

subplot(4,1,2);
plot(time_G_d_pan, HR_G_d_pan,'m-*',time_G_p_pan, HR_G_p_pan,'b-*', time, hr ,'r-*');
title('Pan and Topkin HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

subplot(4,1,3);
plot(time_G_d_ex_algo, HR_G_d_ex_algo,'m-*',time_G_p_ex_algo, HR_G_p_ex_algo,'b-*', time, hr ,'r-*');
title('External algorithm HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

subplot(4,1,4);
plot(time_G_d_flip, HR_G_d_flip,'m-*',time_G_p_flip, HR_G_p_flip,'b-*', time, hr ,'r-*');
title('Flip HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Distal phalanx', 'Proximal phalanx','Reference');

sgtitle('Compare between distal and proximal in GREEN color')


%% Compare READ GREEN IR

figure;

subplot(4,1,1);
plot(time_R_d_auto, HR_R_d_auto,'m-*',time_IR_d_auto, HR_IR_d_auto, 'b-*', time_G_d_auto, HR_G_d_auto ,'c-*', time, hr ,'r-*' );
title('Autocorrelation HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red', 'GREEN', 'Reference');

subplot(4,1,2);
plot(time_R_d_pan, HR_R_d_pan,'m-*',time_IR_d_pan, HR_IR_d_pan, 'b-*', time_G_d_pan, HR_G_d_pan ,'c-*', time, hr ,'r-*' );
title('Pan and Topkin HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red', 'GREEN', 'Reference');

subplot(4,1,3);
plot(time_R_d_ex_algo, HR_R_d_ex_algo,'m-*',time_IR_d_ex_algo, HR_IR_d_ex_algo, 'b-*', time_G_d_ex_algo, HR_G_d_ex_algo ,'c-*', time, hr ,'r-*' );
title('External algorithm HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red', 'GREEN', 'Reference');

subplot(4,1,4);
plot(time_R_d_flip, HR_R_d_flip,'m-*',time_IR_d_flip, HR_IR_d_flip, 'b-*', time_G_d_flip, HR_G_d_flip ,'c-*', time, hr ,'r-*' );
title('Flip HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red', 'GREEN', 'Reference');

sgtitle('Compare between RED, Infra-Red, GREEN in distal phalanx');


figure;

subplot(4,1,1);
plot(time_R_p_auto, HR_R_p_auto,'m-*',time_IR_p_auto, HR_IR_p_auto, 'b-*', time_G_p_auto, HR_G_p_auto ,'c-*', time, hr ,'r-*' );
title('Autocorrelation HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red', 'GREEN', 'Reference');

subplot(4,1,2);
plot(time_R_p_pan, HR_R_p_pan,'m-*',time_IR_p_pan, HR_IR_p_pan, 'b-*', time_G_p_pan, HR_G_p_pan ,'c-*', time, hr ,'r-*' );
title('Pan and Topkin HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red', 'GREEN', 'Reference');

subplot(4,1,3);
plot(time_R_p_ex_algo, HR_R_p_ex_algo,'m-*',time_IR_p_ex_algo, HR_IR_p_ex_algo, 'b-*', time_G_p_ex_algo, HR_G_p_ex_algo ,'c-*', time, hr ,'r-*' );
title('External algorithm HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red', 'GREEN', 'Reference');

subplot(4,1,4);
plot(time_R_p_flip, HR_R_p_flip,'m-*',time_IR_p_flip, HR_IR_p_flip, 'b-*', time_G_p_flip, HR_G_p_flip ,'c-*', time, hr ,'r-*' );
title('flip HR');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'Infra-Red', 'GREEN', 'Reference');

sgtitle('Compare between RED, Infra-Red, GREEN in proximal phalanx');


%% Compare the different methods

figure

subplot(3,1,1);
plot(time_R_d_auto, HR_R_d_auto,'m-*',time_R_d_pan, HR_R_d_pan, 'b-*', time_R_d_ex_algo, HR_R_d_ex_algo ,'c-*', time_R_d_flip, HR_R_d_flip, 'y-*', time, hr ,'r-*' );
title('RED HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Autocorrelation', 'Pan and Topkin', 'External algorithm', 'Flip', 'Reference');

subplot(3,1,2);
plot(time_IR_d_auto, HR_IR_d_auto,'m-*',time_IR_d_pan, HR_IR_d_pan, 'b-*', time_IR_d_ex_algo, HR_IR_d_ex_algo ,'c-*', time_IR_d_flip, HR_IR_d_flip, 'y-*', time, hr ,'r-*' );
title('Infra-Red HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Autocorrelation', 'Pan and Topkin', 'External algorithm', 'Flip', 'Reference');

subplot(3,1,3);
plot(time_G_d_auto, HR_G_d_auto,'m-*',time_G_d_pan, HR_G_d_pan, 'b-*', time_G_d_ex_algo, HR_G_d_ex_algo ,'c-*', time_G_d_flip, HR_G_d_flip, 'y-*', time, hr ,'r-*' );
title('GREEN HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Autocorrelation', 'Pan and Topkin', 'External algorithm', 'Flip', 'Reference');

sgtitle('Compare between the different methods in distal phalanx');


figure

subplot(3,1,1);
plot(time_R_p_auto, HR_R_p_auto,'m-*',time_R_p_pan, HR_R_p_pan, 'b-*', time_R_p_ex_algo, HR_R_p_ex_algo ,'c-*', time_R_p_flip, HR_R_p_flip, 'y-*', time, hr ,'r-*' );
title('RED HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Autocorrelation', 'Pan and Topkin', 'External algorithm', 'Flip', 'Reference');

subplot(3,1,2);
plot(time_IR_p_auto, HR_IR_p_auto,'m-*',time_IR_p_pan, HR_IR_p_pan, 'b-*', time_IR_p_ex_algo, HR_IR_p_ex_algo ,'c-*', time_IR_p_flip, HR_IR_p_flip, 'y-*', time, hr ,'r-*' );
title('Infra-Red HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Autocorrelation', 'Pan and Topkin', 'External algorithm', 'Flip', 'Reference');

subplot(3,1,3);
plot(time_G_p_auto, HR_G_p_auto,'m-*',time_G_p_pan, HR_G_p_pan, 'b-*', time_G_p_ex_algo, HR_G_p_ex_algo ,'c-*', time_G_p_flip, HR_G_p_flip, 'y-*', time, hr ,'r-*' );
title('GREEN HR');
xlabel('Time [sec]');
ylabel('HR');
legend('Autocorrelation', 'Pan and Topkin', 'External algorithm', 'Flip', 'Reference');

sgtitle('Compare between the different methods in proximal phalanx');
