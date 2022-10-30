function [hr,time] = find_hr_autocorrelation(r,FrameRate,NumFrames)

Window_sec = 8;
Window_frames = ceil((Window_sec)*FrameRate);
step_sec = 2;
step_frames = ceil(step_sec*FrameRate);
num_piece = floor((NumFrames-Window_frames)/step_frames);

%r_hpf = highpass(r,0.45,FrameRate);
%r_bpf = lowpass(r_hpf,25/6,FrameRate);

r_hpf = highpass(r,1,FrameRate);
r_bpf = lowpass(r_hpf,20/6,FrameRate);

if (num_piece > 0)
    hr = zeros(1,num_piece-1);
    for k = 1:(num_piece-1)
        r_piece = r_bpf((k-1)*step_frames + 1 : (k-1)*step_frames + 1 + Window_frames) ;
        r_piece = r_piece - mean(r_piece);
        curr = xcorr(r_piece);
        [peaks, index] = findpeaks(curr);
        difference_between_peaks = diff(index);
        average_diff_peaks = mean(difference_between_peaks); 
        hr(k) = 60*FrameRate/(average_diff_peaks);
    end
    time = 4:step_sec:step_sec*num_piece;
else
    r_bpf = r_bpf - mean(r_bpf);
    curr = xcorr(r_bpf);
    [peaks, index] = findpeaks(curr);
    difference_between_peaks = diff(index);
    average_diff_peaks = mean(difference_between_peaks); 
    hr = 60*FrameRate/(average_diff_peaks);
    time = 1;
end