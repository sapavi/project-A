clc
close all
clear

%%  data extraction

enfo = load("data_TROIKA_database\Training_data\DATA_01_TYPE01.mat");
sig = enfo.sig;
ECG = sig(1,:);
PPG_signal = sig(2,:); %SIGNAL A
%PPG_signal = sig(3,:); %SIGNAL B
X_acceleration_axis = sig(4,:);
Y_acceleration_axis= sig(5,:);
Z_acceleration_axis = sig(6,:);

frequency = 125;
num_simples = size(PPG_signal');
time = 0:1/frequency:(num_simples(1)-1)/frequency;

%% Running the algorithm

%[HR_auto , time_auto] = find_hr_autocorrelation_updated(PPG_signal, frequency, num_simples(1));
[HR_auto , time_auto] = find_hr_autocorrelation(PPG_signal, frequency, num_simples(1));
[HR_PAN , time_PAN] = find_hr_pan_and_topkin(PPG_signal, frequency, num_simples(1));
[HR_flip, time_flip] = find_hr_flip(PPG_signal, frequency, num_simples(1));
[HR_ex_algo, time_ex_algo] = find_hr_ex_algo(PPG_signal', frequency);

tmp = load("data_TROIKA_database\Training_data\DATA_01_TYPE01_BPMtrace.mat");
bpm= tmp.BPM0;
size_bpm = size(bpm);
time_bpm = 4:2:4+2*size_bpm(1)-1;
x = 30:60:300;

%% See PPG

figure;

plot(time,PPG_signal)
title('PPG');
xlabel('Time [sec]');
ylabel('PPG');
hold on;
xline(x)
legend('PPG', 'time 30', 'time 90', 'time 150', 'time 210', 'time 270')
hold off


%% Compare between Autocorrelation and Pan and Tompkins

figure;

subplot(2,2,1);
plot(time_auto, HR_auto, time_bpm, bpm, 'r-*');
title('Autocorrelation');
xlabel('Time [sec]');
ylabel('HR');
hold on;
xline(x)
%legend('Autocorrelation', 'BPM TROIKA', 'time 30', 'time 90', 'time 150', 'time 210', 'time 270')
hold off

subplot(2,2,2);
plot(time_PAN, HR_PAN, time_bpm, bpm, 'r-*');
title('Pan and Tompkins');
xlabel('Time [sec]');
ylabel('HR');
hold on;
xline(x)
%legend('Pan and Tompkins', 'BPM TROIKA', 'time 30', 'time 90', 'time 150', 'time 210', 'time 270')
hold off

subplot(2,2,3);
plot(time_ex_algo, HR_ex_algo, time_bpm, bpm, 'r-*');
title('External algorithm');
xlabel('Time [sec]');
ylabel('HR');
hold on;
xline(x)
%legend('External algorithm', 'BPM TROIKA', 'time 30', 'time 90', 'time 150', 'time 210', 'time 270')
hold off

subplot(2,2,4);
plot(time_flip, HR_flip, time_bpm, bpm, 'r-*');
title('Flip');
xlabel('Time [sec]');
ylabel('HR');
hold on;
xline(x)
%legend('Flip', 'BPM TROIKA', 'time 30', 'time 90', 'time 150', 'time 210', 'time 270')
hold off




%{
plot(time_auto, HR_auto,'m-*',time_PAN, HR_PAN,'b-*', time_ex_algo, HR_ex_algo, 'g-*', time_flip, HR_flip, 'c-*', time_bpm, bpm, 'r-*');
title('TROIKA PPG');
xlabel('Time [sec]');
ylabel('HR');
hold on;
xline(x)
legend('Autocorrelation', 'Pan and Tompkins', 'External algorithm', 'Flip', 'BPM TROIKA', 'time 30', 'time 90', 'time 150', 'time 210', 'time 270')
hold off
%}

