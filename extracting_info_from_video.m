clc
close all
clear

%%  data extraction

video = VideoReader("data_mobile_video\measurement_2.mp4");
k=1;
while hasFrame(video)
    img = readFrame(video);
    r(k) = mean(mean(img(:,:,1)));
    g(k) = mean(mean(img(:,:,2)));
    b(k) = mean(mean(img(:,:,3)));
    k = k+1;
end
time = 0:1/video.FrameRate:(video.NumFrames-1)/video.FrameRate;

%% Running the algorithm

[HR_R_auto, time_R_auto] = find_hr_autocorrelation_updated(r,video.FrameRate,video.NumFrames);
%[HR_R_auto, time_R_auto] = find_hr_autocorrelation(r,video.FrameRate,video.NumFrames);
[HR_R_pan, time_R_pan] = find_hr_pan_and_topkin(r,floor(video.FrameRate),video.NumFrames);
[HR_R_ex_algo, time_R_ex_algo] = find_hr_ex_algo(r',video.FrameRate);
[HR_R_flip, time_R_flip] = find_hr_flip(r,floor(video.FrameRate),video.NumFrames);

[HR_G_auto, time_G_auto] = find_hr_autocorrelation_updated(g,video.FrameRate,video.NumFrames);
%[HR_G_auto, time_G_auto] = find_hr_autocorrelation(g,video.FrameRate,video.NumFrames);
[HR_G_pan, time_G_pan] = find_hr_pan_and_topkin(g,floor(video.FrameRate),video.NumFrames);
[HR_G_ex_algo, time_G_ex_algo] = find_hr_ex_algo(g',video.FrameRate);
[HR_G_flip, time_G_flip] = find_hr_flip(g,floor(video.FrameRate),video.NumFrames);

[HR_B_auto, time_B_auto] = find_hr_autocorrelation_updated(b,video.FrameRate,video.NumFrames);
%[HR_B_auto, time_B_auto] = find_hr_autocorrelation(b,video.FrameRate,video.NumFrames);
[HR_B_pan, time_B_pan] = find_hr_pan_and_topkin(b,floor(video.FrameRate),video.NumFrames);
[HR_B_ex_algo, time_B_ex_algo] = find_hr_ex_algo(b',video.FrameRate);
[HR_B_flip, time_B_flip] = find_hr_flip(b,floor(video.FrameRate),video.NumFrames);

%% See PPG

figure;

subplot(3,1,1);
plot(time,r,'r')
title('RED');
xlabel('Time [sec]');
ylabel('PPG');
legend('PPG');

subplot(3,1,2);
plot(time,g,'g')
title('GREEN');
xlabel('Time [sec]');
ylabel('PPG');
legend('PPG');

subplot(3,1,3);
plot(time,b,'b')
title('BLUE');
xlabel('Time [sec]');
ylabel('PPG');
legend('PPG');


%% Comparison between primary colors

figure;
subplot(2,2,1);
plot(time_R_auto, HR_R_auto, 'r-*', time_G_auto, HR_G_auto, 'g-*', time_B_auto, HR_B_auto, 'b-*');
title('Autocorrelation');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'GREEN', 'BLUE');

subplot(2,2,2);
plot(time_R_pan, HR_R_pan, 'r-*', time_G_pan, HR_G_pan, 'g-*', time_B_pan, HR_B_pan, 'b-*');
title('Pan and Tompkins');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'GREEN', 'BLUE');

subplot(2,2,3);
plot(time_R_ex_algo, HR_R_ex_algo, 'r-*', time_G_ex_algo, HR_G_ex_algo, 'g-*', time_B_ex_algo, HR_B_ex_algo, 'b-*');
title('External algorithm');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'GREEN', 'BLUE');

subplot(2,2,4);
plot(time_R_flip, HR_R_flip, 'r-*', time_G_flip, HR_G_flip, 'g-*', time_B_flip, HR_B_flip, 'b-*');
title('Flip');
xlabel('Time [sec]');
ylabel('HR');
legend('RED', 'GREEN', 'BLUE');

sgtitle('Compare between RED GREEN BLUE')
