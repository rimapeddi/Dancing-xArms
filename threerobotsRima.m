clear
clc
close all

%Joint1 v = 1.25 a =4
%Joint2 v =  a =    v= 1.5 a = 5 at 65 (for 1 second of 0)
%BOM IS 84 and that 1.4 seconds per beat
initial_position = [0 0 0 90 0 0 0];
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
BPM = 90;
Time_factor = 60/BPM;
a=2;
%Creates the Position Blocks for the dance moves
%%right robot
bop_right = {0;0;[45 0 -45 0];-1*[25 -25 0 25 -25 0];0;[-30 30 0 -30 30 0];0};
bop_right_t = {4;4;[1.5 .5 1.5 .5];[.75 .75 .5 .75 .75 .5];4;[.75 .75 .5 .75 .75 .5];4};

stand_look_left = {-90;0;0;45;0;-45;0};
stand_look_left_t = {4;4;4;4;4;4;4};

%robot 'sits' and then propels forward and turns to face the front
formation_right = {0;[-20 40 0];0;-1*[65 -50 5 0];[0 -90];[65 20 -40 0 -90];0};
formation_right_t = {16;[4 4 8];16;[4 3 1 8];[8.5 7.5];[4 3 1 6 2];16};

for i = 1:7
    total_right{i} = sum([bop_right{i} stand_look_left{i} formation_right{i}]);
    return_right{i} = -total_right{i};
    return_right_t{i} = 4;
end

bend = {[90 0 -90];[0 -70 0 100 -20];0;[0 60 0 -45 105 -60];0;[0 -120 70 -70 70];0;};
bend_t = {[4 24 4];[4 8 8 6 6];32;[4 4 8 4 6 6];32; [12 4 4 6 6];32;};

wait = {0;0;0;0;0;0;0};
wait_t = {30;30;30;30;30;30;30};

%%middle robot
bop_middle = {0;[15 0 -15 0];0;-1*[15 -30 0 30 -15 0];0;[-30 30 0 -30 30 0];0};
bop_middle_t = {4;[1.5 .5 1.5 .5];4;[.75 .75 .5 .75 .75 .5];4;[.75 .75 .5 .75 .75 .5];4};

stand = {0;0;0;45;0;-45;0};
stand_t = {4;4;4;4;4;4;4};

formation_middle = {0;[-20 40 0 -20 15];0;-1*[65 -50 5 0 100];[0 -180];[65 20 -40 0 -90];0};
formation_middle_t = {16;[4 4 .5 2.5 5];16;[4 3 1 .5 7.5];[8.5 7.5];[4 3 1 6 2]; 16};

for i = 1:7
    total{i} = sum([bop_middle{i} stand{i} formation_middle{i}]);
    return_middle{i} = -total{i};
    return_middle_t{i} = 4;
end

%%left robot
bop_left = {0;0;[-45 0 45 0];-1*[25 -25 0 25 -25 0];0;[-30 30 0 -30 30 0];0};
bop_left_t = {4;4;[1.5 .5 1.5 .5];[.75 .75 .5 .75 .75 .5];4;[.75 .75 .5 .75 .75 .5];4};

stand_look_right = {60;0;0;45;0;-45;0};
stand_look_right_t = {4;4;4;4;4;4;4};

formation_left = {0;[-20 40 0];0;[65 -30 10 0];[0 -90];[65 40 -20 0 90];0};
formation_left_t ={16;[4 4 8];16;[4 3 1 8];[8.5 7.5];[4 3 1 6 2];16};

return_left = {[0 -60];-20;0;0;90;-130;0};
return_left_t = {[1 3];4;4;4;4;4;4};

%DANCES
dance_routine_right = {bop_right stand_look_left formation_right return_right bop_right bop_right};
dance_routine_right_t = {bop_right_t stand_look_left_t formation_right_t return_right_t bop_right_t bop_right_t};

%% DAnce Time

xarmfilename = 'task0.csv'; %name of csv that will be produced RIGHT 
Dance_routine = {bop_right stand_look_left formation_right return_right bend wait};
Dance_routine_t = {bop_right_t stand_look_left_t formation_right_t return_right_t bend_t wait_t};
% Dance_routine = {bop_middle stand formation_middle return_middle bop_middle bop_middle};
% Dance_routine_t = {bop_middle_t stand_t formation_middle_t return_middle_t bop_middle_t bop_middle_t};

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
    if i == 5 || i == 6 || i == 3
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
final_position = final_position_db(1:8:end,:);
delete(xarmfilename);
csvwrite(xarmfilename,final_position);

final_trajectory = Velocity_phase1;
final_trajectory = transpose(final_trajectory);
csvwrite(pandafilename,final_trajectory);