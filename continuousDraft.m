wait = [0;0;0;0;0;0;0];
wait_t = [2;2;2;2;2;2;2];

step1 = [0;0;0;0;[90 -90];0;0];
step1_t = [2;2;2;2;[1 1];2;2];

step2 = [0;0;0;0;0;[-90 90];0];
step2_t = [2;2;2;2;2;[1 1];2];

step3 = [0;0;[30 -60];[-20 20];0;[-30 30];0];
step3_t = [4;4;[1 3];[2 2];4;[2 2];4];

step4 = [0;0;90;40;0;-40;0];
step4_t = [4;4;4;4;4;4;4];

step5 = [0;0;0;-40;0;40;0];
step5_t = [2;2;2;2;2;2;2];

step6 = [0;0;0;40;0;-40;0];
step6_t = [2;2;2;2;2;2;2];

robot1_dance = {step1 step2 step3 step4 step5 step6};
robot1_dance_t = {step1_t step2_t step3_t step4_t step5_t step6_t};

robot2_dance = {wait step2 step3 step4 step5 step6};
robot2_dance_t = {wait_t step2_t step3_t step4_t step5_t step6_t};

robot3_dance = {wait wait step3 step4 step5 step6};
robot3_dance_t = {wait_t wait_t step3_t step4_t step5_t step6_t};

robot4_dance = {wait wait wait wait step4 step5 step6};
robot4_dance_t = {wait_t wait_t wait_t wait_t step4_t step5_t step6_t};

robot5_dance = {wait wait wait wait wait wait step5 step6};
robot5_dance_t = {wait_t wait_t wait_t wait_ wait_t wait_ step5_t step6_t};

robot6_dance = {wait wait wait wait wait wait wait step6};
robot6_dance_t = {wait_t wait_t wait_t wait_ wait_t wait_ wait_t step6_t};