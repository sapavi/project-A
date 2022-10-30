clc
close all
clear

page = fopen("data_Address_video.txt");
line = fgetl(page);
num_line = 0;


error_red_tot = [0,0,0,0];
error_red_auto = 0;
error_red_pan = 0;
error_blue_tot = [0,0,0,0];
error_blue_auto = 0;
error_bluen_pan = 0;
error_green_tot = [0,0,0,0];
error_green_auto = 0;
error_green_pan = 0;

while ischar(line)
    [error_r_d,error_ir_d,error_g_d,error_r_p,error_ir_p,error_g_p] = error_internet_database(line);
    num_line = num_line + 1;

    error_r_d_tot = tot(error_r_d_tot,error_r_d);
    if isnan(error_r_d(1))
        error_r_d_auto(end+1) = num_line;
    end