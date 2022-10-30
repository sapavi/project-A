function [hr,time] = find_hr_ex_algo(r,FrameRate)

[peaks, onsets] = abd_beat_detector(r, FrameRate);
diff_peaks = diff(peaks);
hr = 60*FrameRate./diff_peaks;
for i = 1:size(hr)
    if (hr(i)>200)
        if(i==1)
            hr(i) = 0;
        else
            hr(i) = hr(i-1);
        end
    end
end
time = peaks(1:end-1)/FrameRate;

end