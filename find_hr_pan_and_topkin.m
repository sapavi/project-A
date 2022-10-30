function [hr,time] = find_hr_pan_and_topkin(r,FrameRate,NumFrames)
Fs = 40 ;
Ts = 1/Fs;
r_resample = resample(r,Fs,FrameRate);
r_resample = r_resample(6:end-6);

Window_sec = 4;
Window_frames = ceil((Window_sec)*Fs);
step_sec = 2;
step_frames = ceil(step_sec*Fs);
new_NumFrames = floor(NumFrames*Fs/FrameRate)-10;
num_piece = floor((new_NumFrames-Window_frames)/step_frames);
if (num_piece > 0)
    hr = zeros(1,num_piece-1);
    for k = 1:(num_piece-1)
        r_piece = r_resample((k-1)*step_frames + 1 : (k-1)*step_frames + 1 + Window_frames) ;
        r_piece = r_piece - mean(r_piece);
        hr(k) = pan_and_topkin(r_piece,Fs,NumFrames);
    end

    time = 4:step_sec:step_sec*num_piece;
else
    hr = pan_and_topkin(r_resample, Fs, size(r_resample));
    time = 1;
end
end




%%

function [hr] = pan_and_topkin(r,Fs,NumFrames)


Ts = 1/Fs;

%% ####### the first part : "A"  "Pre-processing Steps"
%  first step : filtere the PPG signal by a bandpass filter order 4 
% type Butterworth 

% Define BPF as in the article
z = tf('z',Ts);
H = (0.5825 -1.1650*z^-2 +0.5825*z^-4 ) / (1-0.6874*z^-1 -0.8157*z^-2 +0.1939*z^-3 +0.3477*z^-4);
Num = H.Numerator;
Den = H.Denominator;

% filter use the builed func filtfilt
PPG_signal_filtered = filtfilt(Num{:}, Den{:}, r);

%% The second step consists of converting the signal into unsigned one

abs_PPG_signal_filtered = abs(PPG_signal_filtered);

%% The third step : The signal resulting from the previous step will proceed to 
%  an integration window of a width of 150 samples
samples = Fs * 0.3 ;
PPG_signal_aft_integr_window = zeros(size(abs_PPG_signal_filtered));
for n = samples+1:length(abs_PPG_signal_filtered) 
    itr = 0 ;
    
    for i = 1:samples 
        itr = itr + abs_PPG_signal_filtered(n-i);
    end 
    itr = itr/samples ;
    PPG_signal_aft_integr_window(n)= itr;
    
end   
PPG_signal_aft_integr_window = PPG_signal_aft_integr_window(21:end-2);

%% The last step is to apply a low pass filter of order 1 type butterworth

% Define LPF as in the article
z = tf('z',Ts);
H = (0.0591 +0.0591*z^-1 ) / (1-0.8816*z^-1);
Num = H.Numerator;
Den = H.Denominator;

% filter use the builed func filtfilt
PPG_signal_aft_integr_window_filtered = filtfilt(Num{:}, Den{:}, PPG_signal_aft_integr_window);

%% ####### the second part : "B" - "Peak Detection and Heart Rate Calculation"
% first and second step : peak detection of PPG_signal_aft_integr_window_filtered
%  and Time Validation: In order to avoid the detection of two
% near peaks
min_peak_to_peak_sec = 0.3 ;
N_time_valid = Fs * min_peak_to_peak_sec ;
[pks,locs] = findpeaks(PPG_signal_aft_integr_window_filtered,'MinPeakDistance',N_time_valid);

%% third step : Calculation Of Time Between Two Peaks

cycles = diff(locs);
Num_of_samples = mean(cycles);
hr = (60 * Fs )/Num_of_samples;

end