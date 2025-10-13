clear;
close all;

%% Input data

% Gases and fuel properties

gamma_c = 1.4;
gamma_t = 1.3;
R_g = 287;          % J/(kg·K)
h_f = 43e6;           % J/kg
c_pc = gamma_c*R_g/(gamma_c-1);
c_pt = gamma_t*R_g/(gamma_t-1);

% Flight condition

M_0 = 1.5;          % Mach number
h = 9000;           % (m), ISA atmosphere
[T_0,p_0] = ISA(h); 

theta_0 = 1 + (gamma_c-1)*M_0^2/2;

% Design parameters

T_t4 = 1850;        % K
T_t7 = 2200;        % K
p_9 = p_0;

% Flight mechanics

beta = 0.85;

% Efficiencies and pressure drops

Pi_d = 0.95;
eta_LPC = 0.87;
eta_HPC = 0.85;
Pi_b = 0.95;
eta_b = 0.95;
eta_HPT = 0.89;
eta_LPT = 0.90;
eta_mHP = 0.992;
eta_mLP = 0.997;
Pi_ndry = 0.99;
eta_ab = 0.99;
Pi_ab = 0.99;

%% Exercise 1

Pi_LPC = 2;

% The value of pi_C is estimated as if it were an ideal two-spool turbojet
% with afterburner.

theta_t = T_t4/T_0;

% tau_C = 0.5 * (1+theta_t/theta_0);
Tau_C = sqrt(theta_t)/theta_0;

Pi_C = Tau_C^(gamma_c/(gamma_c-1));

%% Exercise 2

% Free Stream

T_t0 = T_0 * (1+(gamma_c-1)*M_0^2/2);
p_t0 = p_0 * (1+(gamma_c-1)*M_0^2/2)^(gamma_c/(gamma_c-1));
a_0 = sqrt(gamma_c*R_g*T_0);

freeStream = [T_t0, p_t0, T_0, p_0, a_0, M_0];

% Inlet

T_t2 = T_t0;
p_t2 = Pi_d * p_t0;

inlet = [T_t2, p_t2, NaN, NaN, NaN, NaN];

% LPC

Tau_LPC = 1 + (Pi_LPC^((gamma_c-1)/gamma_c)-1) / eta_LPC;
T_t25 = Tau_LPC*T_t2;
p_t25 = Pi_LPC*p_t2;

LPC = [T_t25, p_t25, NaN, NaN, NaN, NaN];

% HPC

Pi_HPC = Pi_C/Pi_LPC;

Tau_HPC = 1 + (Pi_HPC^((gamma_c-1)/gamma_c)-1) / eta_HPC;
T_t3 = Tau_HPC*T_t25;
p_t3 = Pi_HPC * p_t25;

HPC = [T_t3, p_t3, NaN, NaN, NaN, NaN];

% Burner

f = (c_pt*T_t4-c_pc*T_t3)/(eta_b*h_f-c_pt*T_t4);
p_t4 = Pi_b*p_t3;

burner = [T_t4, p_t4, NaN, NaN, NaN, NaN];

% HPT

Tau_HPT = 1 - c_pc*(T_t3-T_t25)/(eta_mHP*(1+f)*c_pt*T_t4);
T_t45 = Tau_HPT*T_t4;
Pi_HPT = (1 - (1-Tau_HPT)/eta_HPT)^(gamma_t/(gamma_t-1));
p_t45 = Pi_HPT*p_t4;

HPT = [T_t45, p_t45, NaN, NaN, NaN, NaN];

% LPT

Tau_LPT = 1 - c_pc*(T_t25-T_t2)/(eta_mLP*(1+f)*c_pt*T_t45);
T_t5 = Tau_LPT*T_t45;
Pi_LPT = (1 - (1-Tau_LPT)/eta_LPT)^(gamma_t/(gamma_t-1));
p_t5 = Pi_LPT*p_t45;

LPT = [T_t5, p_t5, NaN, NaN, NaN, NaN];

% Nozzle

T_t9 = T_t5;
p_t9 = Pi_ndry*p_t5;

M_9 = sqrt((2/(gamma_t-1)) * ((p_t9/p_9)^((gamma_t-1)/gamma_t) - 1));

T_9 = T_t9 / (1+(gamma_t-1)*M_9^2/2);

a_9 = sqrt(gamma_t*R_g*T_9);
u_9 = M_9*a_9;

nozzle = [T_t9, p_t9, T_9, p_9, a_9, M_9];

%% Postprocessing

T_tvec = [freeStream(1), inlet(1), LPC(1), HPC(1), burner(1), HPT(1), LPT(1), nozzle(1)];
p_tvec = [freeStream(2), inlet(2), LPC(2), HPC(2), burner(2), HPT(2), LPT(2), nozzle(2)];

stations = {'freeStream', 'inlet', 'LPC', 'HPC', 'burner', 'HPT', 'LPT', 'nozzle'};

figure;

plot(1.5:numel(stations)+0.5, T_tvec, '-o');
xticks(1:numel(stations));
xticklabels(stations);

xlabel('Engine Station');
ylabel('Stagnation Temperature (K)');
title('Stagnation Temperature Across Engine Stations');
grid on;


figure;

plot(1.5:(numel(stations)+.5), p_tvec/1e5, '-o');
xticks(1:numel(stations));
xticklabels(stations);

xlabel('Engine Station');
ylabel('Stagnation Pressure (bar)');
title('Stagnation Pressure Across Engine Stations');
grid on;
