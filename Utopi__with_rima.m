clear
clc
close all

%Joint1 v = 1.25 a =4
%Joint2 v =  a =    v= 1.5 a = 5 at 65 (for 1 second of 0)
%BOM IS 84 and that 1.4 seconds per beat
initial_position = [0 0 0 90 0 -90 0];
initial_position = initial_position*(pi/180);

%defines the limits of the velocity and acceleration of the panda to ensure
%it never exceeds P_phase4(n) = Strumming_pattern(2,n);
vel_max = [2.175 2.175 2.175 2.175 2.61 2.61 2.61]; %rad/s
a_max = [15 7.5 10 12.5 15 20 20]; %rad/s^2

%sets initial position of panda (must match initial in cpp code)
Initial_position = [0, -pi/4, 0, -3 * pi/4, 0, pi/2, pi/4];
phases = 5; %this is the number of target locations the program will have
joint = 1;

pandafilename = 'dance_pattern70.csv'; %name of csv that will be produced



%% Desired Inputs 
BPM = 45;
Time_factor = 60/BPM;
a=2;
%Creates the Position Blocks for the dance moves
side_to_side = {[0 20 0 -40 0 40 0 -20 0]; 0; 0; 0; [0 45 -45 0 -45 45 0 45 -45 0 -45 45 0]; [-20 40 -20 -20 0 40 -20 -20 0 40 -20 -20 20 0]; 0};
side_to_side_t = {[0.5 2 2 4 2 4 2 1.5 2]; 20; 20; 20; [0.25 1 0.75 2.25 2 1.75 2.25 2 1.75 2.25 1 0.75 2]; [2 1 1 1 3 1 1 1 3 1 1 1 1 2];20};
side_lean = {};
sway = {0.5*[-30 60 -60 60 -60 60 -60 30];[-20 0 20];0.5*[30 -60 60 -60 60 -60 60 -30];[0];[10 -20 20 -20 20 -20 20 -10];0;0};
sway_t = {2*[1 1 1 1 1 1 1 1];2*[1 6 1];2*[1 1 1 1 1 1 1 1];2*8;2*[1 1 1 1 1 1 1 1];2*8;2*8};
drop1 = {[0 45 -45 -45 45];-1*[0 90 -90 90 -90];0;[0 80 0 -80 80 -80 0];[0 -45 45];[20 0 -20 20 -40 40 -20];[45 -90 90 -90 90 -45 90 -180 90]};
drop1_t = {[8 2 2 2 2];[8 2 2 2 2];16;[0.5 6.5 1 2 2 2 2];[13.5 1 1.5];[1 6 1 2 2 2 2];[2 2 2 2 2 2 2 2 2]};
%drop2


forward_back_slow = {0; [20 0 -40 0 40 0 -20 0]; 0; -[20 0 -40 0 40 0 -20 0];0;[0 10 -10 0 10 -10 0 10 -10 0 10 -10];0};
for i = 1:numel(forward_back_slow)
    if (-1)^i > 0
        forward_back_slow_inv{i,1} = -1*forward_back_slow{i,1};
    else
        forward_back_slow_inv{i,1} = forward_back_slow{i,1};
    end
end
forward_back_slow_t = {16; [2 2 2 2 2 2 2 2]; 16; [2 2 2 2 2 2 2 2]; 16;[2 1 1 2 1 1 2 1 1 2 1 1];16};

circle = {[0 30 -60 60 -60 60 -60 30 0]; 0; [0 -50 100 -100 100 -100 100 -50 0];[0 -20 40 -40 40 -40 40 -40 20];0;[-20 40 -40 40 -40 40 -40 20];0};
circle_t = {2*[2 1 2 2 2 2 2 1 2];2*16;2*[2 1 2 2 2 2 2 1 2];2*[0.25 2 2 2 2 2 2 2 1.75];2*16;2*[2 2 2 2 2 2 2 2];2*16};

bb_five = 45;
bass_bounce = {0;0;0;0.25*[10 -10 10 -10 10 -10 10 -10 10 -10 10 -10 10 -10 10 -10];[0 bb_five 0 -bb_five 0 bb_five 0 -bb_five 0 bb_five 0 -bb_five 0];[-90 0 40 0 -40 0 90 0 -90 0 90];[0 45 0 -45 0]};
bass_bounce_t = {32;32;32;[2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2];[1.625 1.125 2.625 1.375 2.625 1.375 8 1 5.625 1.375 2.625 1.375 1];[1.625 5.375 0.875 0.125 1.625 10.375 1.625 2.375 1.625 5.375 1];[21.625 1.125 0.25 1 8]};
bass_bounce_inv = {0;0;0;0.25*[10 -10 10 -10 10 -10 10 -10 10 -10 10 -10 10 -10 10 -10];[0 -bb_five 0 bb_five 0 -bb_five 0 bb_five 0];[ -90 0 90 -90 0 90 0 -90 0 90 0 20 0 -20];[0 45 0 -45]};
bass_bounce_inv_t = {32;32;32;[2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2];[1.625 1.375 8 1 5.625 1.375 8 1 4];[1.625 1.375 1 1.625 6.375 1.625 2.375 1.625 10.375 1.375 0.25 1.125 0.25 1];[ 13.625 1.125 0.25 1 16]};

%hip_sway
head_bob = {0; [0 5 -5 5 -5 5 -5 5 -5];0; [0 10 -10 10 -10 10 -10 10 -10];0; [20 -20 20 -20 20 -20 20 -20];0};
head_bob_t = {9; [0.75 1 1 1 1 1 1 1 1.25]; 9; [0.5 1 1 1 1 1 1 1 1.5];9;[1 1 1 1 1 1 1 2];9};

fast_bob = {[0 5 -10 10 -10 10 -10 10 -5];0;[0 5 -10 10 -10 10 -10 10 -5];[-5 10 -10 10 -10 10 -10 10 -10 10 -10 10 -10 5];[30 -60 60 -60 60 -60 60 -30];0.75*[-20 40 -40 40 -40 40 -40 40 -40 40 -40 40 -40 20];0};
fast_bob_t = {[0.25 1 1 1 1 1 1 1 0.75];8;[0.125 1 1 1 1 1 1 1 0.875];[1 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 1];[1 1 1 1 1 1 1 1];[1 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 1];8};

wave = {0;-1*[-45 0 10 -20 20 -20 20 -20 20 -20 20 -20 20 -20 55];0;[45 0 10 -20 20 -20 20 -20 20 -20 20 -20 20 -20 -35]; 0;0.5*[-30 60 -60 60 -60 60 -60 60 -60 60 -60 60 -60 60 -30 0];0};
wave_t = {17;[2 0.75 1 1 1 1 1 1 1 1 1 1 1 1 2];17;[2 0.25 1 1 1 1 1 1 1 1 1 1 1 1 2.75]; 17;[2 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1];17};

forward_back = {0;-1*[-10 20 -20 20 -20 20 -20 20 -20 20 -20 20 -20 20 -10];0*[-10 20 -20 20 -20 20 -20 20 -20 20 -20 20 -20 20 -10];-1*[-10 20 -20 20 -20 20 -20 20 -20 20 -20 20 -20 20 -10];0;[-20 40 -40 40 -40 40 -40 40 -40 40 -40 40 -40 40 -20];0};
forward_back_t = {2*16;2*[2 1 1 1 1 1 1 1 1 1 1 1 1 1 1];2*[2 1 1 1 1 1 1 1 1 1 1 1 1 1 1];2*[2 1 1 1 1 1 1 1 1 1 1 1 1 1 1];2*16;2*[2 1 1 1 1 1 1 1 1 1 1 1 1 1 1];2*16};

triangle_intro = {[5 0 -10 0 5 0 5 0 -5];0;[5 0 -10 0 5 0 5 0 -5];[0 10 0 -10 0];[15 0 -30 0 15 0 15 0 -15];0;0};
triangle_intro_t = {[2 2 1 0.5 0.75 0.25 1 0.5 1];9;[2 2 1 0.5 0.75 0.25 1 0.5 1];[5.5 0.75 0.25 1 1.5];[2 2 1 0.5 0.75 0.25 1 0.5 1];9;9};

head_intro = {0;0;0;[0 10 0 -10];[0 45 0 -90 0 45 0];[90 0 -90 0 180 0 -90];0};
head_intro_inv = head_intro;
head_intro_inv{5} = -1*head_intro{5};
head_intro_t = {9;9;9;[6.6 0.9 0.5 1];[4 1 0.5 0.75 0.25 1 1.5];[2 2 1 1.5 1 0.5 1];9}; 

darbuka_beat ={0;[0 20 0 -20];0;[0 -35 0 15 0 20];0;[0 -20 35 0 -15 0];[0 30 -30]};
darbuka_beat_t = {8;[0.5 2.5 4 1];8;[0.5 2.5 1.5 1 1.5 1];8;[0.5 2.5 1.25 0.25 1 2.5];[6 1 1]};%0.5 2.5 1 0.5 1 1 0.5 1

arc = {[90 0 -90];[45 -90 0 90 0 -90 0 45];[-90 0 30 0 -60 0 120];[0 30 -30 0 30 -30 0];[0 20 -40 20 0];[0 20 -20 20 -20 0];0};
arc_t = {[4 24 4];[4 4 4 4 4 4 4 4];[4 12 3.5 0.5 4 4 4];[4 2 2 4 2 2 16];[24 1 2 1 4];[8 1 1 1 1 20];32};

wait = {0;[0 2 -2 2 -2];0;0;0;[1 -1 1 -1];0};
Bwait = {0;0;0;[2 -2 2];0;[5 -5 5];0};
Bwait_t = {3;3;3;[1 1 1];3;[1 1 1];3};
wait_t = {4;[0.25 1 1 1 0.75];4; 4;4;[1 1 1 1];4};
wait_single_t = {1;1;1;1;1;1;1};


hip_wait = {[20 0 -20 0 -20 0 20];0;[-20 0 20 0 20 0 -20];0;[20 0 -20 0 -20 0 20];[-50 0 50];0};
hip_wait_t = {[1 0.5 2.25 0.25 1 0.5 2.5];8;[1 0.5 2.25 0.25 1 0.5 2.5];8;[1 0.5 2.25 0.25 1 0.5 2.5];[1.5 5 1.5];8};  

cue = {0;0;[0 -20 0 20];[0 -20 0 20];[-90 0];[-60 0 30 -30 30 -30];0};
cue_t = {8;8;[0.25 1.5 5 1.25];[0.25 1.5 5 1.25];[3 5];[1.5 3.5 0.75 0.75 0.75 0.75];8};

length = 32;
for i = 1:(length/4)
    pulse(i) = 40*(-1)^(i+1);
    pulse_next(i) = pulse(i)/10;
    pulse_t(i) = 4;
    if i == length/4
        pulse(i) = 20;
    end
end
pulse_next_t = pulse_t; 
pulse_next_t(length/4) = pulse_t(2)-0.25; 
watch = {0;0;0;[0 pulse_next];[0 90]; pulse;0};
pulse(end) = -40;
watch_inv = {0;0;0;[0 pulse_next];[0 70]; pulse;0};
watch_t ={32;32;32;[0.25 pulse_next_t];[30.25 1.75];pulse_t;32};

pose_look = {[0 30 -60 30 0];[35 0 -25 0 25 0 -35 0];0;[-45 0 50 0 -50 0 45 0];[0 -10 20 -10 0];[25 0 10 -95 0 95 -10 0 -25 0];[0 -15 30 -15 0]};
pose_look_t = {[1.5 1.5 1 1.5 10.5];[1.25 2.75 1.25 2.75 1.5 2.5 1.5 2.5];16;[1.25 2.75 1.25 2.75 1.25 2.75 1.5 2.5];[5.5 1.5 1 1.5 6.5];[1.25 2.5 0.25 1.0 2.75 1 0.25 3 1.5 2.5];[9.5 1.5 1 1.5 2.5]};

back_pose = {0;[-20 0 40 0 -20 0];0;[20 0 -40 0 5 15 0];[0 20];[0 20 -20 0  20 -20 0];0};
back_pose_t = {12;[2 2 2 2 2 2];12;[1.5 .5 3 1 2 2 2];[9.5 2.5];[1.5 2.5 1 0.5 2.5 1 3];12};

side_pose = {[10 0 -20 0 10 0];[0 -5 0 -5];[-15 0 30 0 -15 0];0;[-15 0 -15 15 0 15 -15 0];0;0};
side_pose_t = {[1 3 1 3 1 3];[1.5 2.5 5.5 2.5];[1 3 1 3 1 3];12;[1 0.5 2.5 1 0.5 2.5 1 3];12;12};

Up_downlook = {[0 -30 0 60 0 -30 0];[40 0 -20 0 -20 0];[0 30 0 -60 0 30 0];[-40 0 70 0 -30 0];[0 35 0 -70 0 35 0];[0 -30 0 30 0];0};
Up_downlook_t = {[8 3 1 3 1 3 5];[2 2 2 14 2 2];[8 3 1 3 1 3 5];[3 1 3 13 3 1];[8 3 1 3 1 3 5];[4 2 14 2 2];24};



j=1;
head_nod_t = zeros(1,20)+1; 
head_nod = zeros(1,20)+15;
head_nod2 = zeros(1,10)+15;
head_nod_t0 = zeros(1,10)+2; 
for i = 1:numel(head_nod_t0)
    head_nod2(i) = ((-1)^(i))*head_nod2(i);

end
for i = 1:numel(head_nod_t)
    
    if j < 0
        head_nod(i) = -head_nod(i);
    end
    if ((-1)^(i)) > 0 
        head_nod(i) = 0;
        j = -j;
    end
end

breath_offset1 = 0.125*head_nod2 - 0.25*head_nod2;
breath_offset1 = [0 breath_offset1];
head_nod_t1 = [0.5 head_nod_t0];
head_nod_t1(end) = 1.5;

breath_offset2 = 0.2*head_nod2 - 0.4*head_nod2;
breath_offset2 = [0 breath_offset2];
head_nod_t2 = [0.25 head_nod_t0];
head_nod_t2(end) = 1.75;

follow_wait={0;breath_offset1;0;breath_offset2;[-70 0 140 0 -70];head_nod2;0};
follow_wait_inv = follow_wait;
follow_wait_inv{5} = -1*follow_wait{5};
follow_wait_t = {20;head_nod_t1;20;head_nod_t2;[2 6 4 6 2];head_nod_t0;20};

Build = {[0 -20 20];[0 -45 45];[0 30 -30];[0 45 -45];[0 -70 70];[0 20 -20];[0 -80 80]};
Build_t = {[4 4 4];[4 4 4];[4 4 4];[4 4 4];[4 4 4];[4 4 4];[4 4 4]};
 

compassion = {0;[-10 0 -10 0 -10 0 10 0 10 0 10 0];0;[10 0 10 0 10 0 -10 0 -10 0 -10 0];[30 0 -60 0 60 0 -60 0 60 0 -30 0];head_nod;[15 0 -30 0 30 0 -30 0 30 0 -15 0]};

compassion_t = {24;[2 2 2 2 2 2 2 2 2 2 2 2];24;[2 2 2 2 2 2 2 2 2 2 2 2];[2 2 2 2 2 2 2 2 2 2 2 2];head_nod_t;[2 2 2 2 2 2 2 2 2 2 2 2]};
%pride2(tallsway)
%pride(raise head)
%joy1(pumpup)

Mirror = {-1*[0 90 0 -90];-1*[0 -45 0 90 0 -90 45];-1*[0 10 -10 0];-1*[0 45 0 -90 0 90 -45];-1*[0 60 -60 0 90 0 -90 0 60 -60];[-90 0 90 0 30 -30 -90 -45 45 0 10 80];0};
Mirror_inv = {-1*[0 -55 0 55];-1*[0 -45 0 90 0 -90 45];-1*[0 -10 10 0];-1*[0 45 0 -90 0 90 -45];-1*[0 -60 60 0 -90 0 90 0 -60 60];[-90 0 90 0 30 -30 90 -45 45 0 -10 -80];0};
Mirror_t = {[4.35 2.65 23 2];[0.25 1.75 6.25 2.75 17 2 2];[4.25 1.375 1.125 25.25];[0.25 1.75 6.25 2.75 17 2 2];[4 2 2 8 3 5 3 1 2 2];[2 6 3 1 2 2 4 2 2 4 2 2];32};  

%% UTOPIA

standing_rest = {-210;0;180;[0 70];0;[90 -90];0};
standing_rest_t = {3;3;3;[0.5 2.5];3;[2 1];3};

sts = {[0 90];0;0;10;[35 0 -35];0 ;0};
sts_t = {[0.5 0.5];1;1;1;[.4 0.1 .5]; 1;1};

drop = {0;0;0;[0 -20 20];0;[-30 30];0}; %drops sideways
drop_t = {1;1;1;[0.125 0.5 0.375];1;[0.5 0.5];1};

leanback = {[-90 0]; [0 -30, 0 10]; 0; [0 -40]; 0; [0, 40]; 0;}; %top drops down and returns facing straight 
leanback_t = {[0.5 1.5];[0.5 0.9 0.1 0.5];2;[1.5 0.5]; 2;[1.5 0.5];2}; 

dropb = {0; [0 0]; 0; 0; 0; [-60 60]; 0;};
dropb_t = {1;[0.5 0.5];1;1;1;[0.5 0.5];1};

return_torest = {0; 20; 0;30;0;-40;0}; %return to straight up facing forward
return_torest_t = {1;1;1;1;1;1;1};

shoulder = {[0 -90];0;0;0;[-30 0 30]; [-30 30 -30 30]; 0;};
shoulder_t = {[0.5 0.5];1;1;1;[0.4 0.1 0.5];[ 0.25 0.25 0.25 0.25];1};

wave = {0; [0 0 -30 0]; 0; [0 0 40 -40 0]; 0; [0 60 -60 0]; 0;};%need to go sideways           
wave_t = {2;[0.5 0.5 0.9 0.1];2;[0.5 0.25 0.5 0.5 0.25]; 2;[0.5 0.5 0.5 0.5];2};

fake_spin = {-10;[0 60];0;0;[100 -190];0;0};
fake_spin_t = {2.5;[.25 2.25];2.5;2.5;[1 1.5];2.5;2.5};

arcut = {0;[-90 0];[-80 0];0;0;[-60 30 -30];0};
arcut_t = {2.25 ;[1.5 1.75];[2 .25];2.25;2.25;[1.25 0.5 0.5];2.25};

endscene = {0;0;0;0;0;0;0};
endscene_t = {5;5;5;5;5;5;5};
%% Dance time
%Part_B
Dance_routine = {standing_rest sts drop leanback return_torest shoulder wave fake_spin arcut endscene};
Dance_routine_t = {standing_rest_t sts_t drop_t leanback_t return_torest_t shoulder_t wave_t fake_spin_t arcut_t endscene_t};

xarmfilename = 'forest1b.csv';
%PartA
%Dance_routine = {head_intro darbuka_beat darbuka_beat Bwait wait forward_back_slow forward_back_slow bass_bounce arc follow_wait hip_wait circle compassion watch_inv wait Mirror compassion Up_downlook wait hip_wait Build back_pose side_pose wait Up_downlook wait triangle_intro};
%Dance_routine_t = {head_intro_t darbuka_beat_t darbuka_beat_t Bwait_t wait_t forward_back_slow_t forward_back_slow_t bass_bounce_t arc_t follow_wait_t hip_wait_t circle_t compassion_t watch_inv_t wait_t Mirror_t compassion_t Up_downlook_t wait_t hip_wait_t Build_t back_pose_t side_pose_t wait_t Up_downlook_t wait_t triangle_intro_t};

%%

%Does not move
Wait = [0;0;1];

%******Part to change******
n = numel(Dance_routine);

%Time input of each joint
t1 = [];
t2 = [];
t3 = [];
t4 = [];
t5 = [];
t6 = [];
t7 = [];


Phase_array = [];
time_array = [];
P_phase = {};
t_phase = {};
spot = 1;
for j = 1:7
    Phase_array = [];
    time_array = [];
    for m = 1:n
        Phase_array = [Phase_array Dance_routine{m}{j}];
        time_array = [time_array Dance_routine_t{m}{j}];
    end
    P_phase{j} = Phase_array;
    t_phase{j} = Time_factor*time_array;
    
end
%Adds in Strumming pattern

debugt = t_phase;
debugp = P_phase;
% t_phase = {t1; t2; t3; t4; t5; t6; t7}; %time it will take to complete each phase
% P_phase = {P_phase1; P_phase2; P_phase3; P_phase4; P_phase5; P_phase6; P_phase7}; 
%target position of each phase

t_step = 0.001; %value of time steps for lamba function
%finds total t to make arrays

%%

for i = 1:numel(t_phase) 
t_test(i) = sum(t_phase{i});
end


%finds total t to make arrays
t_total = max(t_test);
datapoints = int64(t_total/t_step);
time = linspace(0,t_total,datapoints);
Trajectory = zeros([7 datapoints]);
Velocity = zeros([7 datapoints]);


for j = 1:7 %runs the program 7 times for each joint
    phases = numel(P_phase{j}); 
    i=1;
    currentplace = 0;
    current_pos = 1;
    t_pos = 0;
    negativeplace = zeros([1 phases]);
    zeroplace = zeros([1 phases]);
    %defines some inital conditions
    t1 = 0; %inital time for each phase
    P1 = 0; %inital position displacement
    v0 = 0;%initial velocity
    
 
    
    while i<=phases
        P_phase{j}(i) = P_phase{j}(i)*(pi/180); %convert to radians
        P = P_phase{j}(i);
        t_a = t_phase{j}(i)/2;
        a = (P_phase{j}(i) -v0*t_a)/(t_a^2);
        vf = t_a*a;
        if abs(a) > a_max(j) || abs(vf) > vel_max(j)
            rip = ['too fast at phase ',num2str(i),' joint ',num2str(j),' velocity ',num2str(vf),' acceleration ',num2str(a)];
            disp(rip)
            %break
        end
        %creates some datapoints along the kinematic equation to use for 5th
        %order polynomial
        t = linspace(t1,t_a,10);
        y_start = P1 + .5*a*t.^2;

        %5th orde0 0 0 90 0 -90 0];r trajectory
        [P_start, s, mu] = polyfit(t,y_start,6);
        data_accel = t_a/0.001;
        x2_start = linspace(0,t_a,data_accel);
        y2_start = polyval(P_start,x2_start,s,mu);
        
        %Deceleration 
        t_total = 2*t_a;
        t_end = flip(t_total - t);
        y_end = y2_start(end) + vf*t - .5*a*t.^2;

        %5th order
        [P_end, s_end, mu_end] = polyfit(t,y_end,6);
        x2_end = linspace(0,t_a,data_accel);
        y2_end = polyval(P_end,x2_end, s_end, mu_end);
        x2_end = flip(t_total-x2_end);
        
        %makes trajectory  and velocity grid

        t_pos = t_pos + t_phase{j}(i);

        time_grid = [x2_start x2_end];
        
        if i>1
            time_grid = t_pos + [x2_start x2_end];
        end
        traj_grid = [y2_start y2_end];
        %creats gradient velocities (v=d/t)
        Single_Velocity_grid = gradient(traj_grid(:))./gradient(time_grid(:));
        Velocity_grid = transpose(Single_Velocity_grid);

%         if negativeplace(i) > 0 %checks to make negative direction
%                 traj_grid=-traj_grid;
%                 Velocity_grid = -Velocity_grid;
%         end
%         if zeroplace(i) > 0 %checks to make pause times
%             traj_grid= 0 * traj_grid;
%             Velocity_grid = 0 * Velocity_grid;
%         end
        
        if i > 1
            current_pos = end_pos+1;
%current_pos + (t_phase{j}((i-1))/t_step);
        end
        end_pos = current_pos + numel(time_grid)-1;
        %makes trajectory, time velocity array

        %abs_position(i) =traj_grid(end);
        if i==1
            Trajectory(j,current_pos:end_pos) = traj_grid;
        else
            Trajectory(j,current_pos:end_pos) = traj_grid;
        end
        Velocity(j,current_pos:end_pos) = Velocity_grid;
        
        P1 = traj_grid(end);
        
        i=i+1;
        
    end
end

Velocity_phase1 = Velocity;
figure
for i = 1:7
    Trajectory(i,:) = Trajectory(i,:) + initial_position(i);
    if i == 2 || i == 6 || i == 1 || i == 3
        Trajectory(i,:) = -1*Trajectory(i,:);
    end
    plot(time,Trajectory(i,:))
    hold on
end
title('Position plot of each joint')
legend('Joint 1','Joint 2','Joint 3','Joint 4','Joint 5','Joint 6','Joint 7')

figure
for i = 1:7
    plot(time,Velocity(i,:))
    hold on
end
legend('Joint 1','Joint 2','Joint 3','Joint 4','Joint 5','Joint 6','Joint 7')
title('Velocity plot of each joint')

% Final create
%Velocity_phase1 = transpose(Velocity_phase1);
%Velocity_phase2 = transpose(Velocity_phase2);
%Velocity_phase2 = 0 * Velocity_phase2;
Trajectory(8,:) = time;
final_position_db = transpose(Trajectory);
final_position = final_position_db(1:4:end,:);
csvwrite(xarmfilename,final_position);

final_trajectory = Velocity_phase1;
final_trajectory = transpose(final_trajectory);
csvwrite(pandafilename,final_trajectory);