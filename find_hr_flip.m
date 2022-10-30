function [hr,time] = find_hr_flip(r,FrameRate,NumFrames)

r_flip = max(r) - r;

Window_sec = 8;
Window_frames = ceil((Window_sec)*FrameRate);
step_sec = 2;
step_frames = ceil(step_sec*FrameRate);
num_piece = floor((NumFrames-Window_frames)/step_frames);
min_peak_to_peak_sec = 0.3 ;
N_time_valid = FrameRate * min_peak_to_peak_sec ;

r_hpf_flip = highpass(r_flip,1,FrameRate);
r_bpf_flip = lowpass(r_hpf_flip,20/6,FrameRate);

if (num_piece > 0)
    hr = zeros(1,num_piece-1);
    for k = 1:(num_piece-1)
        r_piece_flip = r_bpf_flip((k-1)*step_frames + 1 : (k-1)*step_frames + 1 + Window_frames) ;
        r_piece_flip = r_piece_flip - mean(r_piece_flip);
        [peaks, index] = findpeaks(r_piece_flip,'MinPeakDistance',N_time_valid);
        difference_between_peaks = diff(index);
        average_diff_peaks = mean(difference_between_peaks); 
        hr(k) = 60*FrameRate/(average_diff_peaks);
    end
    time = 4:step_sec:step_sec*num_piece;
else
    [peaks, index] = findpeaks(r_flip,'MinPeakDistance',N_time_valid);
    difference_between_peaks = diff(index);
    average_diff_peaks = mean(difference_between_peaks); 
    hr = 60*FrameRate/(average_diff_peaks);
    time = 1;
end

end