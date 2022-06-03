format bank

% Script for designing the LQR controller given the wheelbots dynamics model
clear; close all; clc;

run('./s00_config.m') % Load wheelbot parameters

const_values = [Mw; Mc; Mp;...
             Iwx; Iwy; Iwz;...
             Icx; Icy; Icz;...
             Ipx; Ipy; Ipz;...
             Rw; Lc; Lcp; Lp; g];

% Use derived symbolic model from scripts in "matlab_nonlinear_ODE" folder
syms Mw Mc Mp ... % Body masses
     Iwx Iwy Iwz ... % Body inertias
     Icx Icy Icz ...
     Ipx Ipy Ipz ...
     Rw Lc Lcp Lp g ... % System geometry and physical constants
     u2 u1 % Actuation Torques
syms q1 q2 q3 q4 q5 u1 u2
syms q1_d q2_d q3_d q4_d q5_d x_d y_d 
syms q1_dd q2_dd q3_dd q4_dd q5_dd x_dd y_dd
q_v = [q1; q2; q3; q4; q5];
dq_v = [q1_d; q2_d; q3_d; q4_d; q5_d];
ddq_v = [q1_dd; q2_dd; q3_dd; q4_dd; q5_dd];
state = [q1; q1_d; q2; q2_d; q3; q3_d; q4; q4_d; q5; q5_d];

control = [u2; u1];
M = [                                                                                                                         Icz + Ipy + Iwx + Lp^2*Mp + Mc*Rw^2 + Mp*Rw^2 + Mw*Rw^2 + Icx*cos(q2)^2 - Icz*cos(q2)^2 + Ipx*cos(q2)^2 - Ipy*cos(q2)^2 - Ipy*cos(q5)^2 + Ipz*cos(q5)^2 + Ipy*cos(q2)^2*cos(q5)^2 - Ipz*cos(q2)^2*cos(q5)^2 + Lc^2*Mc*cos(q2)^2 + Lc^2*Mp*cos(q2)^2 + Lcp^2*Mp*cos(q2)^2 - Lp^2*Mp*cos(q5)^2 + 2*Lc*Mc*Rw*cos(q2) + 2*Lc*Mp*Rw*cos(q2) + 2*Lcp*Mp*Rw*cos(q2) + 2*Lc*Lcp*Mp*cos(q2)^2 + Lp^2*Mp*cos(q2)^2*cos(q5)^2 + 2*Lc*Lp*Mp*cos(q2)^2*cos(q5) + 2*Lcp*Lp*Mp*cos(q2)^2*cos(q5) + 2*Lp*Mp*Rw*cos(q2)*cos(q5),                                                                                                                                                                                                                                                                                                                                                                                                              Ipy*cos(q5)*sin(q2)*sin(q5) - Ipz*cos(q5)*sin(q2)*sin(q5) + Lc*Lp*Mp*sin(q2)*sin(q5) + Lcp*Lp*Mp*sin(q2)*sin(q5) + Lp^2*Mp*cos(q5)*sin(q2)*sin(q5),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               Icz*cos(q1)*cos(q2)*sin(q2) - Icx*cos(q1)*cos(q2)*sin(q2) - Ipx*cos(q1)*cos(q2)*sin(q2) + Ipy*cos(q1)*cos(q2)*sin(q2) - Lc*Mc*Rw*cos(q1)*sin(q2) - Lc*Mp*Rw*cos(q1)*sin(q2) - Lcp*Mp*Rw*cos(q1)*sin(q2) + Ipy*cos(q5)*sin(q1)*sin(q2)*sin(q5) - Ipz*cos(q5)*sin(q1)*sin(q2)*sin(q5) - Ipy*cos(q1)*cos(q2)*cos(q5)^2*sin(q2) + Ipz*cos(q1)*cos(q2)*cos(q5)^2*sin(q2) - Lc^2*Mc*cos(q1)*cos(q2)*sin(q2) - Lc^2*Mp*cos(q1)*cos(q2)*sin(q2) - Lcp^2*Mp*cos(q1)*cos(q2)*sin(q2) - Lp^2*Mp*cos(q1)*cos(q2)*cos(q5)^2*sin(q2) - 2*Lc*Lcp*Mp*cos(q1)*cos(q2)*sin(q2) - Lp*Mp*Rw*cos(q1)*cos(q5)*sin(q2) + Lp^2*Mp*cos(q5)*sin(q1)*sin(q2)*sin(q5) + Lc*Lp*Mp*sin(q1)*sin(q2)*sin(q5) + Lcp*Lp*Mp*sin(q1)*sin(q2)*sin(q5) - 2*Lc*Lp*Mp*cos(q1)*cos(q2)*cos(q5)*sin(q2) - 2*Lcp*Lp*Mp*cos(q1)*cos(q2)*cos(q5)*sin(q2),                                                                                                                                                                                                                 0,                                                   Ipx*cos(q2) + Lp^2*Mp*cos(q2) + Lp*Mp*Rw*cos(q5) + Lc*Lp*Mp*cos(q2)*cos(q5) + Lcp*Lp*Mp*cos(q2)*cos(q5);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   sin(q2)*sin(q5)*(Ipy*cos(q5) - Ipz*cos(q5) + Lp^2*Mp*cos(q5) + Lc*Lp*Mp + Lcp*Lp*Mp),                                                                                                                                                                                                                                                                                                                                                                                                           Icy + Ipz + Lc^2*Mc + Lc^2*Mp + Lcp^2*Mp + Ipy*cos(q5)^2 - Ipz*cos(q5)^2 + 2*Lc*Lcp*Mp + Lp^2*Mp*cos(q5)^2 + 2*Lc*Lp*Mp*cos(q5) + 2*Lcp*Lp*Mp*cos(q5),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           Icy*sin(q1) + Ipz*sin(q1) + Lc^2*Mc*sin(q1) + Lc^2*Mp*sin(q1) + Lcp^2*Mp*sin(q1) + Ipy*cos(q5)^2*sin(q1) - Ipz*cos(q5)^2*sin(q1) + 2*Lc*Lcp*Mp*sin(q1) + Lp^2*Mp*cos(q5)^2*sin(q1) + Lc*Mc*Rw*cos(q2)*sin(q1) + Lc*Mp*Rw*cos(q2)*sin(q1) + Lcp*Mp*Rw*cos(q2)*sin(q1) + Ipy*cos(q1)*cos(q2)*cos(q5)*sin(q5) - Ipz*cos(q1)*cos(q2)*cos(q5)*sin(q5) + 2*Lc*Lp*Mp*cos(q5)*sin(q1) + 2*Lcp*Lp*Mp*cos(q5)*sin(q1) + Lp^2*Mp*cos(q1)*cos(q2)*cos(q5)*sin(q5) + Lc*Lp*Mp*cos(q1)*cos(q2)*sin(q5) + Lcp*Lp*Mp*cos(q1)*cos(q2)*sin(q5) + Lp*Mp*Rw*cos(q2)*cos(q5)*sin(q1),                                                                                                                                Lc*Mc*Rw*cos(q2) + Lc*Mp*Rw*cos(q2) + Lcp*Mp*Rw*cos(q2) + Lp*Mp*Rw*cos(q2)*cos(q5),                                                                                                                                                         0;
 -sin(q2)*(Icx*cos(q1)*cos(q2) - Icz*cos(q1)*cos(q2) + Ipx*cos(q1)*cos(q2) - Ipy*cos(q1)*cos(q2) + Lc^2*Mc*cos(q1)*cos(q2) + Lc^2*Mp*cos(q1)*cos(q2) + Lcp^2*Mp*cos(q1)*cos(q2) + Lc*Mc*Rw*cos(q1) + Lc*Mp*Rw*cos(q1) + Lcp*Mp*Rw*cos(q1) - Ipy*cos(q5)*sin(q1)*sin(q5) + Ipz*cos(q5)*sin(q1)*sin(q5) + Ipy*cos(q1)*cos(q2)*cos(q5)^2 - Ipz*cos(q1)*cos(q2)*cos(q5)^2 - Lc*Lp*Mp*sin(q1)*sin(q5) - Lcp*Lp*Mp*sin(q1)*sin(q5) + Lp^2*Mp*cos(q1)*cos(q2)*cos(q5)^2 + 2*Lc*Lcp*Mp*cos(q1)*cos(q2) + Lp*Mp*Rw*cos(q1)*cos(q5) - Lp^2*Mp*cos(q5)*sin(q1)*sin(q5) + 2*Lc*Lp*Mp*cos(q1)*cos(q2)*cos(q5) + 2*Lcp*Lp*Mp*cos(q1)*cos(q2)*cos(q5)), Icy*sin(q1) + Ipz*sin(q1) + Lc^2*Mc*sin(q1) + Lc^2*Mp*sin(q1) + Lcp^2*Mp*sin(q1) + Ipy*cos(q5)^2*sin(q1) - Ipz*cos(q5)^2*sin(q1) + 2*Lc*Lcp*Mp*sin(q1) + Lp^2*Mp*cos(q5)^2*sin(q1) + Lc*Mc*Rw*cos(q2)*sin(q1) + Lc*Mp*Rw*cos(q2)*sin(q1) + Lcp*Mp*Rw*cos(q2)*sin(q1) + Ipy*cos(q1)*cos(q2)*cos(q5)*sin(q5) - Ipz*cos(q1)*cos(q2)*cos(q5)*sin(q5) + 2*Lc*Lp*Mp*cos(q5)*sin(q1) + 2*Lcp*Lp*Mp*cos(q5)*sin(q1) + Lp^2*Mp*cos(q1)*cos(q2)*cos(q5)*sin(q5) + Lc*Lp*Mp*cos(q1)*cos(q2)*sin(q5) + Lcp*Lp*Mp*cos(q1)*cos(q2)*sin(q5) + Lp*Mp*Rw*cos(q2)*cos(q5)*sin(q1), Icy + Ipz + Iwy + Lc^2*Mc + Lc^2*Mp + Lcp^2*Mp + Mc*Rw^2 + Mp*Rw^2 + Mw*Rw^2 + Icx*cos(q1)^2 - Icy*cos(q1)^2 + Ipx*cos(q1)^2 + Ipy*cos(q5)^2 - Ipz*cos(q1)^2 - Ipz*cos(q5)^2 - Iwy*cos(q1)^2 + Iwz*cos(q1)^2 - Icx*cos(q1)^2*cos(q2)^2 + Icz*cos(q1)^2*cos(q2)^2 - Ipx*cos(q1)^2*cos(q2)^2 + Ipy*cos(q1)^2*cos(q2)^2 - Ipy*cos(q1)^2*cos(q5)^2 + Ipz*cos(q1)^2*cos(q5)^2 + 2*Lc*Lcp*Mp + Lp^2*Mp*cos(q1)^2 + Lp^2*Mp*cos(q5)^2 - Mc*Rw^2*cos(q1)^2 - Mp*Rw^2*cos(q1)^2 - Mw*Rw^2*cos(q1)^2 + 2*Lc*Lp*Mp*cos(q5) + 2*Lcp*Lp*Mp*cos(q5) + 2*Lc*Mc*Rw*cos(q2) + 2*Lc*Mp*Rw*cos(q2) + 2*Lcp*Mp*Rw*cos(q2) - Ipy*cos(q1)^2*cos(q2)^2*cos(q5)^2 + Ipz*cos(q1)^2*cos(q2)^2*cos(q5)^2 - Lc^2*Mc*cos(q1)^2*cos(q2)^2 - Lc^2*Mp*cos(q1)^2*cos(q2)^2 - Lcp^2*Mp*cos(q1)^2*cos(q2)^2 - Lp^2*Mp*cos(q1)^2*cos(q5)^2 - 2*Lc*Mc*Rw*cos(q1)^2*cos(q2) - 2*Lc*Mp*Rw*cos(q1)^2*cos(q2) - 2*Lcp*Mp*Rw*cos(q1)^2*cos(q2) - 2*Lc*Lcp*Mp*cos(q1)^2*cos(q2)^2 - Lp^2*Mp*cos(q1)^2*cos(q2)^2*cos(q5)^2 + 2*Lp*Mp*Rw*cos(q2)*cos(q5) - 2*Lp*Mp*Rw*cos(q1)^2*cos(q2)*cos(q5) - 2*Lc*Lp*Mp*cos(q1)^2*cos(q2)^2*cos(q5) - 2*Lcp*Lp*Mp*cos(q1)^2*cos(q2)^2*cos(q5) + 2*Lp*Mp*Rw*cos(q1)*sin(q1)*sin(q5) + 2*Ipy*cos(q1)*cos(q2)*cos(q5)*sin(q1)*sin(q5) - 2*Ipz*cos(q1)*cos(q2)*cos(q5)*sin(q1)*sin(q5) + 2*Lp^2*Mp*cos(q1)*cos(q2)*cos(q5)*sin(q1)*sin(q5) + 2*Lc*Lp*Mp*cos(q1)*cos(q2)*sin(q1)*sin(q5) + 2*Lcp*Lp*Mp*cos(q1)*cos(q2)*sin(q1)*sin(q5), Iwy*sin(q1) + Mc*Rw^2*sin(q1) + Mp*Rw^2*sin(q1) + Mw*Rw^2*sin(q1) + Lc*Mc*Rw*cos(q2)*sin(q1) + Lc*Mp*Rw*cos(q2)*sin(q1) + Lcp*Mp*Rw*cos(q2)*sin(q1) + Lp*Mp*Rw*cos(q1)*sin(q5) + Lp*Mp*Rw*cos(q2)*cos(q5)*sin(q1), - Ipx*cos(q1)*sin(q2) - Lp^2*Mp*cos(q1)*sin(q2) - Lc*Lp*Mp*cos(q1)*cos(q5)*sin(q2) - Lcp*Lp*Mp*cos(q1)*cos(q5)*sin(q2) - Lp*Mp*Rw*sin(q1)*sin(q2)*sin(q5);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Lc*Mc*Rw*cos(q2) + Lc*Mp*Rw*cos(q2) + Lcp*Mp*Rw*cos(q2) + Lp*Mp*Rw*cos(q2)*cos(q5),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         Iwy*sin(q1) + Mc*Rw^2*sin(q1) + Mp*Rw^2*sin(q1) + Mw*Rw^2*sin(q1) + Lc*Mc*Rw*cos(q2)*sin(q1) + Lc*Mp*Rw*cos(q2)*sin(q1) + Lcp*Mp*Rw*cos(q2)*sin(q1) + Lp*Mp*Rw*cos(q1)*sin(q5) + Lp*Mp*Rw*cos(q2)*cos(q5)*sin(q1),                                                                                                                                                                                 Iwy + Mc*Rw^2 + Mp*Rw^2 + Mw*Rw^2,                                                                                                                                 -Lp*Mp*Rw*sin(q2)*sin(q5);
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Ipx*cos(q2) + Lp^2*Mp*cos(q2) + Lp*Mp*Rw*cos(q5) + Lc*Lp*Mp*cos(q2)*cos(q5) + Lcp*Lp*Mp*cos(q2)*cos(q5),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               0,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 - Ipx*cos(q1)*sin(q2) - Lp^2*Mp*cos(q1)*sin(q2) - Lc*Lp*Mp*cos(q1)*cos(q5)*sin(q2) - Lcp*Lp*Mp*cos(q1)*cos(q5)*sin(q2) - Lp*Mp*Rw*sin(q1)*sin(q2)*sin(q5),                                                                                                                                                                                         -Lp*Mp*Rw*sin(q2)*sin(q5),                                                                                                                                             Mp*Lp^2 + Ipx];
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
RHS = [(Icy*q3_d^2*sin(2*q1))/2 - (Icx*q3_d^2*sin(2*q1))/2 - (Ipx*q3_d^2*sin(2*q1))/2 + (Ipz*q3_d^2*sin(2*q1))/2 + (Iwy*q3_d^2*sin(2*q1))/2 - (Iwz*q3_d^2*sin(2*q1))/2 + Mc*Rw*g*sin(q1) + Mp*Rw*g*sin(q1) + Mw*Rw*g*sin(q1) - Icx*q2_d*q3_d*cos(q1) + Icy*q2_d*q3_d*cos(q1) + Icz*q2_d*q3_d*cos(q1) - Ipx*q2_d*q3_d*cos(q1) + Ipy*q2_d*q3_d*cos(q1) + Ipz*q2_d*q3_d*cos(q1) + Iwy*q3_d*q4_d*cos(q1) - (Lp^2*Mp*q3_d^2*sin(2*q1))/2 + Ipx*q2_d*q5_d*sin(q2) + Ipy*q2_d*q5_d*sin(q2) - Ipz*q2_d*q5_d*sin(q2) + (Mc*Rw^2*q3_d^2*sin(2*q1))/2 + (Mp*Rw^2*q3_d^2*sin(2*q1))/2 + (Mw*Rw^2*q3_d^2*sin(2*q1))/2 + Icx*q1_d*q2_d*sin(2*q2) - Icz*q1_d*q2_d*sin(2*q2) + Ipx*q1_d*q2_d*sin(2*q2) - Ipy*q1_d*q2_d*sin(2*q2) - Ipy*q1_d*q5_d*sin(2*q5) + Ipz*q1_d*q5_d*sin(2*q5) - Lp*Mp*Rw*q3_d^2*sin(q5) + Lp*Mp*Rw*q5_d^2*sin(q5) - Ipy*q2_d^2*cos(q2)*cos(q5)*sin(q5) - Ipy*q3_d^2*cos(q2)*cos(q5)*sin(q5) + Ipz*q2_d^2*cos(q2)*cos(q5)*sin(q5) + Ipz*q3_d^2*cos(q2)*cos(q5)*sin(q5) + Mc*Rw^2*q3_d*q4_d*cos(q1) + Mp*Rw^2*q3_d*q4_d*cos(q1) + Mw*Rw^2*q3_d*q4_d*cos(q1) + Lc*Mc*g*cos(q2)*sin(q1) + Lc*Mp*g*cos(q2)*sin(q1) + Lcp*Mp*g*cos(q2)*sin(q1) + Lp*Mp*g*cos(q1)*sin(q5) + 2*Lp^2*Mp*q2_d*q5_d*sin(q2) + Ipx*q3_d*q5_d*sin(q1)*sin(q2) + Ipy*q3_d*q5_d*sin(q1)*sin(q2) - Ipz*q3_d*q5_d*sin(q1)*sin(q2) + Icx*q3_d^2*cos(q1)*cos(q2)^2*sin(q1) - Icz*q3_d^2*cos(q1)*cos(q2)^2*sin(q1) + Ipx*q3_d^2*cos(q1)*cos(q2)^2*sin(q1) - Ipy*q3_d^2*cos(q1)*cos(q2)^2*sin(q1) + Ipy*q3_d^2*cos(q1)*cos(q5)^2*sin(q1) - Ipz*q3_d^2*cos(q1)*cos(q5)^2*sin(q1) + Lc^2*Mc*q1_d*q2_d*sin(2*q2) + Lc^2*Mp*q1_d*q2_d*sin(2*q2) + Lcp^2*Mp*q1_d*q2_d*sin(2*q2) - Lp^2*Mp*q1_d*q5_d*sin(2*q5) + 2*Icx*q2_d*q3_d*cos(q1)*cos(q2)^2 - 2*Icz*q2_d*q3_d*cos(q1)*cos(q2)^2 + 2*Ipx*q2_d*q3_d*cos(q1)*cos(q2)^2 - 2*Ipy*q2_d*q3_d*cos(q1)*cos(q2)^2 - 2*Ipy*q2_d*q5_d*cos(q5)^2*sin(q2) + 2*Ipz*q2_d*q5_d*cos(q5)^2*sin(q2) + 2*Lp^2*Mp*q3_d*q5_d*sin(q1)*sin(q2) + 2*Lc*Mc*Rw*q1_d*q2_d*sin(q2) + 2*Lc*Mp*Rw*q1_d*q2_d*sin(q2) + 2*Lcp*Mp*Rw*q1_d*q2_d*sin(q2) + Lc^2*Mc*q3_d^2*cos(q1)*cos(q2)^2*sin(q1) + Lc^2*Mp*q3_d^2*cos(q1)*cos(q2)^2*sin(q1) + Lcp^2*Mp*q3_d^2*cos(q1)*cos(q2)^2*sin(q1) + Lp^2*Mp*q3_d^2*cos(q1)*cos(q5)^2*sin(q1) + 2*Lp*Mp*Rw*q3_d^2*cos(q1)^2*sin(q5) + 2*Ipy*q3_d^2*cos(q1)^2*cos(q2)*cos(q5)*sin(q5) - 2*Ipz*q3_d^2*cos(q1)^2*cos(q2)*cos(q5)*sin(q5) + 2*Lc^2*Mc*q2_d*q3_d*cos(q1)*cos(q2)^2 + 2*Lc^2*Mp*q2_d*q3_d*cos(q1)*cos(q2)^2 + 2*Lcp^2*Mp*q2_d*q3_d*cos(q1)*cos(q2)^2 - 2*Lp^2*Mp*q2_d*q5_d*cos(q5)^2*sin(q2) + 2*Lc*Lcp*Mp*q1_d*q2_d*sin(2*q2) + 2*Ipy*q1_d*q2_d*cos(q2)*cos(q5)^2*sin(q2) + 2*Ipy*q1_d*q5_d*cos(q2)^2*cos(q5)*sin(q5) - 2*Ipz*q1_d*q2_d*cos(q2)*cos(q5)^2*sin(q2) - 2*Ipz*q1_d*q5_d*cos(q2)^2*cos(q5)*sin(q5) - 2*Ipy*q3_d*q5_d*cos(q5)^2*sin(q1)*sin(q2) + 2*Ipz*q3_d*q5_d*cos(q5)^2*sin(q1)*sin(q2) + Ipy*q3_d^2*cos(q1)*cos(q2)^2*cos(q5)^2*sin(q1) - Ipz*q3_d^2*cos(q1)*cos(q2)^2*cos(q5)^2*sin(q1) - Lp^2*Mp*q2_d^2*cos(q2)*cos(q5)*sin(q5) - Lp^2*Mp*q3_d^2*cos(q2)*cos(q5)*sin(q5) + 2*Ipy*q2_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)^2 - 2*Ipz*q2_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)^2 - Lc*Lp*Mp*q2_d^2*cos(q2)*sin(q5) - Lc*Lp*Mp*q3_d^2*cos(q2)*sin(q5) + Lc*Lp*Mp*q5_d^2*cos(q2)*sin(q5) - Lcp*Lp*Mp*q2_d^2*cos(q2)*sin(q5) - Lcp*Lp*Mp*q3_d^2*cos(q2)*sin(q5) + Lcp*Lp*Mp*q5_d^2*cos(q2)*sin(q5) + Lp*Mp*g*cos(q2)*cos(q5)*sin(q1) + 2*Lc*Lcp*Mp*q3_d^2*cos(q1)*cos(q2)^2*sin(q1) + 2*Lc*Lp*Mp*q3_d^2*cos(q1)^2*cos(q2)*sin(q5) + 2*Lcp*Lp*Mp*q3_d^2*cos(q1)^2*cos(q2)*sin(q5) + 2*Lp^2*Mp*q1_d*q2_d*cos(q2)*cos(q5)^2*sin(q2) + 2*Lp^2*Mp*q1_d*q5_d*cos(q2)^2*cos(q5)*sin(q5) + 4*Lc*Lcp*Mp*q2_d*q3_d*cos(q1)*cos(q2)^2 - 2*Lp^2*Mp*q3_d*q5_d*cos(q5)^2*sin(q1)*sin(q2) + 2*Lc*Lp*Mp*q1_d*q5_d*cos(q2)^2*sin(q5) + 2*Lcp*Lp*Mp*q1_d*q5_d*cos(q2)^2*sin(q5) + Lp^2*Mp*q3_d^2*cos(q1)*cos(q2)^2*cos(q5)^2*sin(q1) + 2*Lp^2*Mp*q2_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)^2 + 2*Lc*Mc*Rw*q3_d^2*cos(q1)*cos(q2)*sin(q1) + 2*Lc*Mp*Rw*q3_d^2*cos(q1)*cos(q2)*sin(q1) + 2*Lcp*Mp*Rw*q3_d^2*cos(q1)*cos(q2)*sin(q1) + 2*Lc*Mc*Rw*q2_d*q3_d*cos(q1)*cos(q2) + Lc*Mc*Rw*q3_d*q4_d*cos(q1)*cos(q2) + 2*Lc*Mp*Rw*q2_d*q3_d*cos(q1)*cos(q2) + Lc*Mp*Rw*q3_d*q4_d*cos(q1)*cos(q2) + 2*Lcp*Mp*Rw*q2_d*q3_d*cos(q1)*cos(q2) + Lcp*Mp*Rw*q3_d*q4_d*cos(q1)*cos(q2) + 2*Lp*Mp*Rw*q1_d*q2_d*cos(q5)*sin(q2) + 2*Lp*Mp*Rw*q1_d*q5_d*cos(q2)*sin(q5) + 2*Lp^2*Mp*q3_d^2*cos(q1)^2*cos(q2)*cos(q5)*sin(q5) - Lp*Mp*Rw*q3_d*q4_d*sin(q1)*sin(q5) - 2*Ipy*q2_d*q3_d*cos(q2)*cos(q5)*sin(q1)*sin(q5) + 2*Ipz*q2_d*q3_d*cos(q2)*cos(q5)*sin(q1)*sin(q5) + 4*Lc*Lp*Mp*q2_d*q3_d*cos(q1)*cos(q2)^2*cos(q5) + 4*Lcp*Lp*Mp*q2_d*q3_d*cos(q1)*cos(q2)^2*cos(q5) + 2*Lp*Mp*Rw*q3_d^2*cos(q1)*cos(q2)*cos(q5)*sin(q1) + 2*Lp*Mp*Rw*q2_d*q3_d*cos(q1)*cos(q2)*cos(q5) + Lp*Mp*Rw*q3_d*q4_d*cos(q1)*cos(q2)*cos(q5) - 2*Lp^2*Mp*q2_d*q3_d*cos(q2)*cos(q5)*sin(q1)*sin(q5) + 4*Lc*Lp*Mp*q1_d*q2_d*cos(q2)*cos(q5)*sin(q2) + 4*Lcp*Lp*Mp*q1_d*q2_d*cos(q2)*cos(q5)*sin(q2) - 2*Lc*Lp*Mp*q2_d*q3_d*cos(q2)*sin(q1)*sin(q5) - 2*Lcp*Lp*Mp*q2_d*q3_d*cos(q2)*sin(q1)*sin(q5) - 2*Lp*Mp*Rw*q3_d*q5_d*cos(q1)*sin(q2)*sin(q5) - 2*Ipy*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)*sin(q2)*sin(q5) + 2*Ipz*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)*sin(q2)*sin(q5) + 2*Lc*Lp*Mp*q3_d^2*cos(q1)*cos(q2)^2*cos(q5)*sin(q1) + 2*Lcp*Lp*Mp*q3_d^2*cos(q1)*cos(q2)^2*cos(q5)*sin(q1) - 2*Lp^2*Mp*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)*sin(q2)*sin(q5) - 2*Lc*Lp*Mp*q3_d*q5_d*cos(q1)*cos(q2)*sin(q2)*sin(q5) - 2*Lcp*Lp*Mp*q3_d*q5_d*cos(q1)*cos(q2)*sin(q2)*sin(q5);     
            (Icz*q1_d^2*sin(2*q2))/2 - (Icx*q1_d^2*sin(2*q2))/2 - u2 - (Ipx*q1_d^2*sin(2*q2))/2 + (Ipy*q1_d^2*sin(2*q2))/2 + Icx*q1_d*q3_d*cos(q1) - Icy*q1_d*q3_d*cos(q1) - Icz*q1_d*q3_d*cos(q1) + Ipx*q1_d*q3_d*cos(q1) - Ipy*q1_d*q3_d*cos(q1) - Ipz*q1_d*q3_d*cos(q1) - (Lc^2*Mc*q1_d^2*sin(2*q2))/2 - (Lc^2*Mp*q1_d^2*sin(2*q2))/2 - (Lcp^2*Mp*q1_d^2*sin(2*q2))/2 - Ipx*q1_d*q5_d*sin(q2) + Ipy*q1_d*q5_d*sin(q2) - Ipz*q1_d*q5_d*sin(q2) + Ipy*q2_d*q5_d*sin(2*q5) - Ipz*q2_d*q5_d*sin(2*q5) - Lc*Mc*Rw*q1_d^2*sin(q2) - Lc*Mc*Rw*q3_d^2*sin(q2) - Lc*Mp*Rw*q1_d^2*sin(q2) - Lc*Mp*Rw*q3_d^2*sin(q2) - Lcp*Mp*Rw*q1_d^2*sin(q2) - Lcp*Mp*Rw*q3_d^2*sin(q2) + Lc*Mc*g*cos(q1)*sin(q2) + Lc*Mp*g*cos(q1)*sin(q2) + Lcp*Mp*g*cos(q1)*sin(q2) - Ipx*q3_d*q5_d*cos(q1)*cos(q2) + Ipy*q3_d*q5_d*cos(q1)*cos(q2) - Ipz*q3_d*q5_d*cos(q1)*cos(q2) - Lc*Lcp*Mp*q1_d^2*sin(2*q2) + Icx*q3_d^2*cos(q1)^2*cos(q2)*sin(q2) - Icz*q3_d^2*cos(q1)^2*cos(q2)*sin(q2) + Ipx*q3_d^2*cos(q1)^2*cos(q2)*sin(q2) - Ipy*q3_d^2*cos(q1)^2*cos(q2)*sin(q2) - Ipy*q1_d^2*cos(q2)*cos(q5)^2*sin(q2) + Ipz*q1_d^2*cos(q2)*cos(q5)^2*sin(q2) + Lp^2*Mp*q2_d*q5_d*sin(2*q5) - 2*Icx*q1_d*q3_d*cos(q1)*cos(q2)^2 + 2*Icz*q1_d*q3_d*cos(q1)*cos(q2)^2 - 2*Ipx*q1_d*q3_d*cos(q1)*cos(q2)^2 + 2*Ipy*q1_d*q3_d*cos(q1)*cos(q2)^2 - 2*Ipy*q1_d*q5_d*cos(q5)^2*sin(q2) + 2*Ipz*q1_d*q5_d*cos(q5)^2*sin(q2) + 2*Lc*Lp*Mp*q2_d*q5_d*sin(q5) + 2*Lcp*Lp*Mp*q2_d*q5_d*sin(q5) + Lc^2*Mc*q3_d^2*cos(q1)^2*cos(q2)*sin(q2) + Lc^2*Mp*q3_d^2*cos(q1)^2*cos(q2)*sin(q2) + Lcp^2*Mp*q3_d^2*cos(q1)^2*cos(q2)*sin(q2) - Lp^2*Mp*q1_d^2*cos(q2)*cos(q5)^2*sin(q2) + 2*Ipy*q3_d*q5_d*cos(q5)*sin(q1)*sin(q5) - 2*Ipz*q3_d*q5_d*cos(q5)*sin(q1)*sin(q5) + Lc*Mc*Rw*q3_d^2*cos(q1)^2*sin(q2) + Lc*Mp*Rw*q3_d^2*cos(q1)^2*sin(q2) + Lcp*Mp*Rw*q3_d^2*cos(q1)^2*sin(q2) - 2*Lc^2*Mc*q1_d*q3_d*cos(q1)*cos(q2)^2 - 2*Lc^2*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2 - 2*Lcp^2*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2 - 2*Lp^2*Mp*q1_d*q5_d*cos(q5)^2*sin(q2) - 2*Ipy*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)^2 + 2*Ipz*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)^2 + Ipy*q3_d^2*cos(q1)^2*cos(q2)*cos(q5)^2*sin(q2) - Ipz*q3_d^2*cos(q1)^2*cos(q2)*cos(q5)^2*sin(q2) - 2*Ipy*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)^2 + 2*Ipz*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)^2 - Lp*Mp*Rw*q1_d^2*cos(q5)*sin(q2) - Lp*Mp*Rw*q3_d^2*cos(q5)*sin(q2) + Lp*Mp*g*cos(q1)*cos(q5)*sin(q2) + 2*Lc*Lcp*Mp*q3_d^2*cos(q1)^2*cos(q2)*sin(q2) + Lp*Mp*Rw*q3_d^2*cos(q1)^2*cos(q5)*sin(q2) - 2*Lp^2*Mp*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)^2 - 4*Lc*Lcp*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2 + Lp^2*Mp*q3_d^2*cos(q1)^2*cos(q2)*cos(q5)^2*sin(q2) - 2*Lp^2*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)^2 - 2*Lc*Lp*Mp*q1_d^2*cos(q2)*cos(q5)*sin(q2) - 2*Lcp*Lp*Mp*q1_d^2*cos(q2)*cos(q5)*sin(q2) - Ipy*q3_d^2*cos(q1)*cos(q5)*sin(q1)*sin(q2)*sin(q5) + Ipz*q3_d^2*cos(q1)*cos(q5)*sin(q1)*sin(q2)*sin(q5) - 2*Lc*Mc*Rw*q1_d*q3_d*cos(q1)*cos(q2) - 2*Lc*Mp*Rw*q1_d*q3_d*cos(q1)*cos(q2) - 2*Lcp*Mp*Rw*q1_d*q3_d*cos(q1)*cos(q2) + 2*Lp^2*Mp*q3_d*q5_d*cos(q5)*sin(q1)*sin(q5) - 2*Lc*Lp*Mp*q1_d*q5_d*cos(q5)*sin(q2) - 2*Lcp*Lp*Mp*q1_d*q5_d*cos(q5)*sin(q2) + 2*Lc*Lp*Mp*q3_d*q5_d*sin(q1)*sin(q5) + 2*Lcp*Lp*Mp*q3_d*q5_d*sin(q1)*sin(q5) - Lc*Mc*Rw*q3_d*q4_d*sin(q1)*sin(q2) - Lc*Mp*Rw*q3_d*q4_d*sin(q1)*sin(q2) - Lcp*Mp*Rw*q3_d*q4_d*sin(q1)*sin(q2) + 2*Ipy*q1_d*q3_d*cos(q2)*cos(q5)*sin(q1)*sin(q5) - 2*Ipz*q1_d*q3_d*cos(q2)*cos(q5)*sin(q1)*sin(q5) - 4*Lc*Lp*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5) - 4*Lcp*Lp*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5) - Lp^2*Mp*q3_d^2*cos(q1)*cos(q5)*sin(q1)*sin(q2)*sin(q5) - Lc*Lp*Mp*q3_d^2*cos(q1)*sin(q1)*sin(q2)*sin(q5) - Lcp*Lp*Mp*q3_d^2*cos(q1)*sin(q1)*sin(q2)*sin(q5) - 2*Lc*Lp*Mp*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5) - 2*Lcp*Lp*Mp*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5) - 2*Lp*Mp*Rw*q1_d*q3_d*cos(q1)*cos(q2)*cos(q5) + 2*Lp^2*Mp*q1_d*q3_d*cos(q2)*cos(q5)*sin(q1)*sin(q5) + 2*Lc*Lp*Mp*q1_d*q3_d*cos(q2)*sin(q1)*sin(q5) + 2*Lcp*Lp*Mp*q1_d*q3_d*cos(q2)*sin(q1)*sin(q5) - Lp*Mp*Rw*q3_d*q4_d*cos(q5)*sin(q1)*sin(q2) + 2*Lc*Lp*Mp*q3_d^2*cos(q1)^2*cos(q2)*cos(q5)*sin(q2) + 2*Lcp*Lp*Mp*q3_d^2*cos(q1)^2*cos(q2)*cos(q5)*sin(q2);      
            Icz*q1_d*q2_d*cos(q1) - Icy*q1_d*q2_d*cos(q1) - Icx*q1_d*q2_d*cos(q1) - Ipx*q1_d*q2_d*cos(q1) + Ipy*q1_d*q2_d*cos(q1) - Ipz*q1_d*q2_d*cos(q1) - Iwy*q1_d*q4_d*cos(q1) + Icx*q1_d*q3_d*sin(2*q1) - Icy*q1_d*q3_d*sin(2*q1) + Ipx*q1_d*q3_d*sin(2*q1) + Ipy*q3_d*q5_d*sin(2*q5) - Ipz*q1_d*q3_d*sin(2*q1) - Ipz*q3_d*q5_d*sin(2*q5) - Iwy*q1_d*q3_d*sin(2*q1) + Iwz*q1_d*q3_d*sin(2*q1) - 2*Lc^2*Mc*q1_d*q2_d*cos(q1) - 2*Lc^2*Mp*q1_d*q2_d*cos(q1) - 2*Lcp^2*Mp*q1_d*q2_d*cos(q1) - Icx*q1_d^2*cos(q2)*sin(q1)*sin(q2) + Icz*q1_d^2*cos(q2)*sin(q1)*sin(q2) - Ipx*q1_d^2*cos(q2)*sin(q1)*sin(q2) + Ipy*q1_d^2*cos(q2)*sin(q1)*sin(q2) + Ipx*q2_d*q5_d*cos(q1)*cos(q2) + Ipy*q2_d*q5_d*cos(q1)*cos(q2) - Ipz*q2_d*q5_d*cos(q1)*cos(q2) - Ipx*q1_d*q5_d*sin(q1)*sin(q2) + Ipy*q1_d*q5_d*sin(q1)*sin(q2) - Ipz*q1_d*q5_d*sin(q1)*sin(q2) + Lp^2*Mp*q1_d*q3_d*sin(2*q1) + Lp^2*Mp*q3_d*q5_d*sin(2*q5) - Mc*Rw^2*q1_d*q3_d*sin(2*q1) - Mp*Rw^2*q1_d*q3_d*sin(2*q1) - Mw*Rw^2*q1_d*q3_d*sin(2*q1) + 2*Icx*q1_d*q2_d*cos(q1)*cos(q2)^2 - 2*Icz*q1_d*q2_d*cos(q1)*cos(q2)^2 + 2*Ipx*q1_d*q2_d*cos(q1)*cos(q2)^2 - 2*Ipy*q1_d*q2_d*cos(q1)*cos(q2)^2 - 2*Ipy*q1_d*q2_d*cos(q1)*cos(q5)^2 + 2*Ipz*q1_d*q2_d*cos(q1)*cos(q5)^2 + 2*Lc*Lp*Mp*q3_d*q5_d*sin(q5) + 2*Lcp*Lp*Mp*q3_d*q5_d*sin(q5) + 2*Lc*Mc*Rw*q2_d*q3_d*sin(q2) - Lc*Mc*Rw*q3_d*q4_d*sin(q2) + 2*Lc*Mp*Rw*q2_d*q3_d*sin(q2) - Lc*Mp*Rw*q3_d*q4_d*sin(q2) + 2*Lcp*Mp*Rw*q2_d*q3_d*sin(q2) - Lcp*Mp*Rw*q3_d*q4_d*sin(q2) + 2*Lp*Mp*Rw*q1_d*q3_d*sin(q5) + 2*Ipy*q3_d*q5_d*cos(q1)*cos(q2)*sin(q1) + 2*Ipy*q1_d*q3_d*cos(q2)*cos(q5)*sin(q5) - 2*Ipz*q3_d*q5_d*cos(q1)*cos(q2)*sin(q1) - 2*Ipz*q1_d*q3_d*cos(q2)*cos(q5)*sin(q5) + 2*Ipy*q2_d*q5_d*cos(q5)*sin(q1)*sin(q5) - 2*Ipz*q2_d*q5_d*cos(q5)*sin(q1)*sin(q5) + 2*Lc^2*Mc*q1_d*q2_d*cos(q1)*cos(q2)^2 + 2*Lc^2*Mp*q1_d*q2_d*cos(q1)*cos(q2)^2 + 2*Lcp^2*Mp*q1_d*q2_d*cos(q1)*cos(q2)^2 - 2*Lp^2*Mp*q1_d*q2_d*cos(q1)*cos(q5)^2 - Ipy*q1_d^2*cos(q2)*cos(q5)^2*sin(q1)*sin(q2) + Ipz*q1_d^2*cos(q2)*cos(q5)^2*sin(q1)*sin(q2) - 2*Ipy*q2_d*q5_d*cos(q1)*cos(q2)*cos(q5)^2 + 2*Ipz*q2_d*q5_d*cos(q1)*cos(q2)*cos(q5)^2 - 2*Icx*q1_d*q3_d*cos(q1)*cos(q2)^2*sin(q1) - 2*Icx*q2_d*q3_d*cos(q1)^2*cos(q2)*sin(q2) + 2*Icz*q1_d*q3_d*cos(q1)*cos(q2)^2*sin(q1) + 2*Icz*q2_d*q3_d*cos(q1)^2*cos(q2)*sin(q2) - 2*Ipx*q1_d*q3_d*cos(q1)*cos(q2)^2*sin(q1) - 2*Ipx*q2_d*q3_d*cos(q1)^2*cos(q2)*sin(q2) + 2*Ipy*q1_d*q3_d*cos(q1)*cos(q2)^2*sin(q1) + 2*Ipy*q2_d*q3_d*cos(q1)^2*cos(q2)*sin(q2) - 2*Ipy*q1_d*q3_d*cos(q1)*cos(q5)^2*sin(q1) - 2*Ipy*q3_d*q5_d*cos(q1)^2*cos(q5)*sin(q5) + 2*Ipz*q1_d*q3_d*cos(q1)*cos(q5)^2*sin(q1) + 2*Ipz*q3_d*q5_d*cos(q1)^2*cos(q5)*sin(q5) - 2*Ipy*q1_d*q5_d*cos(q5)^2*sin(q1)*sin(q2) + 2*Ipz*q1_d*q5_d*cos(q5)^2*sin(q1)*sin(q2) - Lc^2*Mc*q1_d^2*cos(q2)*sin(q1)*sin(q2) - Lc^2*Mp*q1_d^2*cos(q2)*sin(q1)*sin(q2) - Lcp^2*Mp*q1_d^2*cos(q2)*sin(q1)*sin(q2) + 2*Ipy*q1_d*q2_d*cos(q1)*cos(q2)^2*cos(q5)^2 - 2*Ipz*q1_d*q2_d*cos(q1)*cos(q2)^2*cos(q5)^2 + 2*Lp^2*Mp*q2_d*q5_d*cos(q1)*cos(q2) - Lc*Mc*Rw*q1_d^2*sin(q1)*sin(q2) + Lc*Mc*Rw*q2_d^2*sin(q1)*sin(q2) - Lc*Mp*Rw*q1_d^2*sin(q1)*sin(q2) + Lc*Mp*Rw*q2_d^2*sin(q1)*sin(q2) - Lcp*Mp*Rw*q1_d^2*sin(q1)*sin(q2) + Lcp*Mp*Rw*q2_d^2*sin(q1)*sin(q2) - Ipy*q1_d^2*cos(q1)*cos(q5)*sin(q2)*sin(q5) + Ipy*q2_d^2*cos(q1)*cos(q5)*sin(q2)*sin(q5) + Ipz*q1_d^2*cos(q1)*cos(q5)*sin(q2)*sin(q5) - Ipz*q2_d^2*cos(q1)*cos(q5)*sin(q2)*sin(q5) - 4*Lc*Lcp*Mp*q1_d*q2_d*cos(q1) - 2*Lp^2*Mp*q2_d*q5_d*cos(q1)*cos(q2)*cos(q5)^2 - 2*Lc^2*Mc*q1_d*q3_d*cos(q1)*cos(q2)^2*sin(q1) - 2*Lc^2*Mc*q2_d*q3_d*cos(q1)^2*cos(q2)*sin(q2) - 2*Lc^2*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2*sin(q1) - 2*Lc^2*Mp*q2_d*q3_d*cos(q1)^2*cos(q2)*sin(q2) - 2*Lcp^2*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2*sin(q1) - 2*Lcp^2*Mp*q2_d*q3_d*cos(q1)^2*cos(q2)*sin(q2) - 2*Lp^2*Mp*q1_d*q3_d*cos(q1)*cos(q5)^2*sin(q1) - 2*Lp^2*Mp*q3_d*q5_d*cos(q1)^2*cos(q5)*sin(q5) + 4*Lc*Lcp*Mp*q1_d*q2_d*cos(q1)*cos(q2)^2 - 2*Lp^2*Mp*q1_d*q5_d*cos(q5)^2*sin(q1)*sin(q2) - 2*Lc*Mc*Rw*q2_d*q3_d*cos(q1)^2*sin(q2) - 2*Lc*Mp*Rw*q2_d*q3_d*cos(q1)^2*sin(q2) - 2*Lcp*Mp*Rw*q2_d*q3_d*cos(q1)^2*sin(q2) - 4*Lp*Mp*Rw*q1_d*q3_d*cos(q1)^2*sin(q5) - 4*Ipy*q1_d*q3_d*cos(q1)^2*cos(q2)*cos(q5)*sin(q5) - 4*Ipy*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)^2*sin(q1) + 4*Ipz*q1_d*q3_d*cos(q1)^2*cos(q2)*cos(q5)*sin(q5) + 4*Ipz*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)^2*sin(q1) + 2*Lp^2*Mp*q1_d*q2_d*cos(q1)*cos(q2)^2*cos(q5)^2 - Lp^2*Mp*q1_d^2*cos(q1)*cos(q5)*sin(q2)*sin(q5) + Lp^2*Mp*q2_d^2*cos(q1)*cos(q5)*sin(q2)*sin(q5) - 2*Ipy*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)^2*sin(q1) - 2*Ipy*q2_d*q3_d*cos(q1)^2*cos(q2)*cos(q5)^2*sin(q2) - 2*Ipy*q3_d*q5_d*cos(q1)^2*cos(q2)^2*cos(q5)*sin(q5) + 2*Ipz*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)^2*sin(q1) + 2*Ipz*q2_d*q3_d*cos(q1)^2*cos(q2)*cos(q5)^2*sin(q2) + 2*Ipz*q3_d*q5_d*cos(q1)^2*cos(q2)^2*cos(q5)*sin(q5) - 2*Lc*Lcp*Mp*q1_d^2*cos(q2)*sin(q1)*sin(q2) - Lc*Lp*Mp*q1_d^2*cos(q1)*sin(q2)*sin(q5) + Lc*Lp*Mp*q2_d^2*cos(q1)*sin(q2)*sin(q5) - Lc*Lp*Mp*q5_d^2*cos(q1)*sin(q2)*sin(q5) - Lcp*Lp*Mp*q1_d^2*cos(q1)*sin(q2)*sin(q5) + Lcp*Lp*Mp*q2_d^2*cos(q1)*sin(q2)*sin(q5) - Lcp*Lp*Mp*q5_d^2*cos(q1)*sin(q2)*sin(q5) - Lp*Mp*Rw*q1_d^2*cos(q5)*sin(q1)*sin(q2) + Lp*Mp*Rw*q2_d^2*cos(q5)*sin(q1)*sin(q2) + Lp*Mp*Rw*q5_d^2*cos(q5)*sin(q1)*sin(q2) + 2*Lp^2*Mp*q3_d*q5_d*cos(q1)*cos(q2)*sin(q1) + 2*Lp^2*Mp*q1_d*q3_d*cos(q2)*cos(q5)*sin(q5) - 4*Lc*Lp*Mp*q1_d*q2_d*cos(q1)*cos(q5) - 4*Lcp*Lp*Mp*q1_d*q2_d*cos(q1)*cos(q5) + 2*Lp^2*Mp*q2_d*q5_d*cos(q5)*sin(q1)*sin(q5) + 2*Lc*Lp*Mp*q1_d*q3_d*cos(q2)*sin(q5) + 2*Lcp*Lp*Mp*q1_d*q3_d*cos(q2)*sin(q5) + 2*Lp*Mp*Rw*q2_d*q3_d*cos(q5)*sin(q2) - Lp*Mp*Rw*q3_d*q4_d*cos(q5)*sin(q2) + 2*Lp*Mp*Rw*q3_d*q5_d*cos(q2)*sin(q5) + 2*Lc*Lp*Mp*q2_d*q5_d*sin(q1)*sin(q5) + 2*Lcp*Lp*Mp*q2_d*q5_d*sin(q1)*sin(q5) - Lp^2*Mp*q1_d^2*cos(q2)*cos(q5)^2*sin(q1)*sin(q2) + 4*Lc*Lp*Mp*q1_d*q2_d*cos(q1)*cos(q2)^2*cos(q5) + 4*Lcp*Lp*Mp*q1_d*q2_d*cos(q1)*cos(q2)^2*cos(q5) - 4*Lc*Lcp*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2*sin(q1) - 4*Lc*Lcp*Mp*q2_d*q3_d*cos(q1)^2*cos(q2)*sin(q2) - 4*Lc*Lp*Mp*q1_d*q3_d*cos(q1)^2*cos(q2)*sin(q5) - 4*Lcp*Lp*Mp*q1_d*q3_d*cos(q1)^2*cos(q2)*sin(q5) - 2*Lp*Mp*Rw*q2_d*q3_d*cos(q1)^2*cos(q5)*sin(q2) - 2*Lp*Mp*Rw*q3_d*q5_d*cos(q1)^2*cos(q2)*sin(q5) - 2*Lp^2*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)^2*sin(q1) - 2*Lp^2*Mp*q2_d*q3_d*cos(q1)^2*cos(q2)*cos(q5)^2*sin(q2) - 2*Lp^2*Mp*q3_d*q5_d*cos(q1)^2*cos(q2)^2*cos(q5)*sin(q5) - 2*Lc*Lp*Mp*q3_d*q5_d*cos(q1)^2*cos(q2)^2*sin(q5) - 2*Lcp*Lp*Mp*q3_d*q5_d*cos(q1)^2*cos(q2)^2*sin(q5) - 2*Lc*Lp*Mp*q1_d^2*cos(q2)*cos(q5)*sin(q1)*sin(q2) - 2*Lcp*Lp*Mp*q1_d^2*cos(q2)*cos(q5)*sin(q1)*sin(q2) - 4*Lc*Mc*Rw*q1_d*q3_d*cos(q1)*cos(q2)*sin(q1) - 4*Lc*Mp*Rw*q1_d*q3_d*cos(q1)*cos(q2)*sin(q1) - 4*Lcp*Mp*Rw*q1_d*q3_d*cos(q1)*cos(q2)*sin(q1) - 2*Lp*Mp*Rw*q3_d*q5_d*cos(q1)*cos(q5)*sin(q1) - 2*Lc*Lp*Mp*q1_d*q5_d*cos(q5)*sin(q1)*sin(q2) - 2*Lcp*Lp*Mp*q1_d*q5_d*cos(q5)*sin(q1)*sin(q2) + 2*Lp*Mp*Rw*q2_d*q5_d*cos(q2)*sin(q1)*sin(q5) - 2*Ipy*q1_d*q5_d*cos(q1)*cos(q2)*cos(q5)*sin(q2)*sin(q5) + 2*Ipz*q1_d*q5_d*cos(q1)*cos(q2)*cos(q5)*sin(q2)*sin(q5) + 2*Ipy*q2_d*q3_d*cos(q1)*cos(q5)*sin(q1)*sin(q2)*sin(q5) - 2*Ipz*q2_d*q3_d*cos(q1)*cos(q5)*sin(q1)*sin(q2)*sin(q5) - 4*Lp^2*Mp*q1_d*q3_d*cos(q1)^2*cos(q2)*cos(q5)*sin(q5) - 4*Lp^2*Mp*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)^2*sin(q1) - 2*Lp^2*Mp*q1_d*q5_d*cos(q1)*cos(q2)*cos(q5)*sin(q2)*sin(q5) - 2*Lc*Lp*Mp*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)*sin(q1) - 2*Lcp*Lp*Mp*q3_d*q5_d*cos(q1)*cos(q2)*cos(q5)*sin(q1) - 4*Lp*Mp*Rw*q1_d*q3_d*cos(q1)*cos(q2)*cos(q5)*sin(q1) + 2*Lp^2*Mp*q2_d*q3_d*cos(q1)*cos(q5)*sin(q1)*sin(q2)*sin(q5) - 2*Lc*Lp*Mp*q1_d*q5_d*cos(q1)*cos(q2)*sin(q2)*sin(q5) - 2*Lcp*Lp*Mp*q1_d*q5_d*cos(q1)*cos(q2)*sin(q2)*sin(q5) + 2*Lc*Lp*Mp*q2_d*q3_d*cos(q1)*sin(q1)*sin(q2)*sin(q5) + 2*Lcp*Lp*Mp*q2_d*q3_d*cos(q1)*sin(q1)*sin(q2)*sin(q5) - 4*Lc*Lp*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)*sin(q1) - 4*Lc*Lp*Mp*q2_d*q3_d*cos(q1)^2*cos(q2)*cos(q5)*sin(q2) - 4*Lcp*Lp*Mp*q1_d*q3_d*cos(q1)*cos(q2)^2*cos(q5)*sin(q1) - 4*Lcp*Lp*Mp*q2_d*q3_d*cos(q1)^2*cos(q2)*cos(q5)*sin(q2);    
            u2 - Iwy*q1_d*q3_d*cos(q1) + Lc*Mc*Rw*q2_d^2*sin(q2) + Lc*Mc*Rw*q3_d^2*sin(q2) + Lc*Mp*Rw*q2_d^2*sin(q2) + Lc*Mp*Rw*q3_d^2*sin(q2) + Lcp*Mp*Rw*q2_d^2*sin(q2) + Lcp*Mp*Rw*q3_d^2*sin(q2) - 2*Mc*Rw^2*q1_d*q3_d*cos(q1) - 2*Mp*Rw^2*q1_d*q3_d*cos(q1) - 2*Mw*Rw^2*q1_d*q3_d*cos(q1) + Lp*Mp*Rw*q2_d^2*cos(q5)*sin(q2) + Lp*Mp*Rw*q3_d^2*cos(q5)*sin(q2) + Lp*Mp*Rw*q5_d^2*cos(q5)*sin(q2) - 2*Lc*Mc*Rw*q1_d*q3_d*cos(q1)*cos(q2) - 2*Lc*Mp*Rw*q1_d*q3_d*cos(q1)*cos(q2) - 2*Lcp*Mp*Rw*q1_d*q3_d*cos(q1)*cos(q2) - 2*Lp*Mp*Rw*q3_d*q5_d*cos(q1)*cos(q5) + 2*Lp*Mp*Rw*q2_d*q5_d*cos(q2)*sin(q5) + 2*Lc*Mc*Rw*q2_d*q3_d*sin(q1)*sin(q2) + 2*Lc*Mp*Rw*q2_d*q3_d*sin(q1)*sin(q2) + 2*Lcp*Mp*Rw*q2_d*q3_d*sin(q1)*sin(q2) + 2*Lp*Mp*Rw*q1_d*q3_d*sin(q1)*sin(q5) - 2*Lp*Mp*Rw*q1_d*q3_d*cos(q1)*cos(q2)*cos(q5) + 2*Lp*Mp*Rw*q2_d*q3_d*cos(q5)*sin(q1)*sin(q2) + 2*Lp*Mp*Rw*q3_d*q5_d*cos(q2)*sin(q1)*sin(q5);        
            u1 + (Ipy*q1_d^2*sin(2*q5))/2 - (Ipy*q2_d^2*sin(2*q5))/2 - (Ipy*q3_d^2*sin(2*q5))/2 - (Ipz*q1_d^2*sin(2*q5))/2 + (Ipz*q2_d^2*sin(2*q5))/2 + (Ipz*q3_d^2*sin(2*q5))/2 + (Lp^2*Mp*q1_d^2*sin(2*q5))/2 - (Lp^2*Mp*q2_d^2*sin(2*q5))/2 - (Lp^2*Mp*q3_d^2*sin(2*q5))/2 + Ipx*q1_d*q2_d*sin(q2) - Ipy*q1_d*q2_d*sin(q2) + Ipz*q1_d*q2_d*sin(q2) - Ipy*q3_d^2*cos(q1)*cos(q2)*sin(q1) + Ipz*q3_d^2*cos(q1)*cos(q2)*sin(q1) + Lp*Mp*g*cos(q5)*sin(q1) + Ipx*q2_d*q3_d*cos(q1)*cos(q2) - Ipy*q2_d*q3_d*cos(q1)*cos(q2) + Ipz*q2_d*q3_d*cos(q1)*cos(q2) - Ipx*q1_d*q3_d*sin(q1)*sin(q2) - Ipy*q1_d*q3_d*sin(q1)*sin(q2) + Ipz*q1_d*q3_d*sin(q1)*sin(q2) - Ipy*q1_d^2*cos(q2)^2*cos(q5)*sin(q5) + Ipy*q3_d^2*cos(q1)^2*cos(q5)*sin(q5) + Ipz*q1_d^2*cos(q2)^2*cos(q5)*sin(q5) - Ipz*q3_d^2*cos(q1)^2*cos(q5)*sin(q5) + 2*Ipy*q1_d*q2_d*cos(q5)^2*sin(q2) - 2*Ipz*q1_d*q2_d*cos(q5)^2*sin(q2) - Lc*Lp*Mp*q2_d^2*sin(q5) - Lc*Lp*Mp*q3_d^2*sin(q5) - Lcp*Lp*Mp*q2_d^2*sin(q5) - Lcp*Lp*Mp*q3_d^2*sin(q5) - 2*Lp^2*Mp*q1_d*q3_d*sin(q1)*sin(q2) - Lp^2*Mp*q1_d^2*cos(q2)^2*cos(q5)*sin(q5) + Lp^2*Mp*q3_d^2*cos(q1)^2*cos(q5)*sin(q5) - 2*Ipy*q2_d*q3_d*cos(q5)*sin(q1)*sin(q5) + 2*Ipz*q2_d*q3_d*cos(q5)*sin(q1)*sin(q5) - Lc*Lp*Mp*q1_d^2*cos(q2)^2*sin(q5) - Lcp*Lp*Mp*q1_d^2*cos(q2)^2*sin(q5) + 2*Ipy*q3_d^2*cos(q1)*cos(q2)*cos(q5)^2*sin(q1) - 2*Ipz*q3_d^2*cos(q1)*cos(q2)*cos(q5)^2*sin(q1) + 2*Lp^2*Mp*q1_d*q2_d*cos(q5)^2*sin(q2) + 2*Ipy*q2_d*q3_d*cos(q1)*cos(q2)*cos(q5)^2 - 2*Ipz*q2_d*q3_d*cos(q1)*cos(q2)*cos(q5)^2 + 2*Ipy*q1_d*q3_d*cos(q5)^2*sin(q1)*sin(q2) - 2*Ipz*q1_d*q3_d*cos(q5)^2*sin(q1)*sin(q2) + Ipy*q3_d^2*cos(q1)^2*cos(q2)^2*cos(q5)*sin(q5) - Ipz*q3_d^2*cos(q1)^2*cos(q2)^2*cos(q5)*sin(q5) - Lp^2*Mp*q3_d^2*cos(q1)*cos(q2)*sin(q1) - Lp*Mp*Rw*q1_d^2*cos(q2)*sin(q5) - Lp*Mp*Rw*q3_d^2*cos(q2)*sin(q5) + Lp*Mp*g*cos(q1)*cos(q2)*sin(q5) + Lp*Mp*Rw*q3_d^2*cos(q1)^2*cos(q2)*sin(q5) + 2*Lp^2*Mp*q2_d*q3_d*cos(q1)*cos(q2)*cos(q5)^2 + 2*Lp^2*Mp*q1_d*q3_d*cos(q5)^2*sin(q1)*sin(q2) + Lp^2*Mp*q3_d^2*cos(q1)^2*cos(q2)^2*cos(q5)*sin(q5) + Lc*Lp*Mp*q3_d^2*cos(q1)^2*cos(q2)^2*sin(q5) + Lcp*Lp*Mp*q3_d^2*cos(q1)^2*cos(q2)^2*sin(q5) + Lp*Mp*Rw*q3_d^2*cos(q1)*cos(q5)*sin(q1) + Lp*Mp*Rw*q3_d*q4_d*cos(q1)*cos(q5) - 2*Lp^2*Mp*q2_d*q3_d*cos(q5)*sin(q1)*sin(q5) + 2*Lc*Lp*Mp*q1_d*q2_d*cos(q5)*sin(q2) + 2*Lcp*Lp*Mp*q1_d*q2_d*cos(q5)*sin(q2) + 2*Lp^2*Mp*q3_d^2*cos(q1)*cos(q2)*cos(q5)^2*sin(q1) - 2*Lc*Lp*Mp*q2_d*q3_d*sin(q1)*sin(q5) - 2*Lcp*Lp*Mp*q2_d*q3_d*sin(q1)*sin(q5) + Lc*Lp*Mp*q3_d^2*cos(q1)*cos(q2)*cos(q5)*sin(q1) + Lcp*Lp*Mp*q3_d^2*cos(q1)*cos(q2)*cos(q5)*sin(q1) + 2*Lc*Lp*Mp*q2_d*q3_d*cos(q1)*cos(q2)*cos(q5) + 2*Lcp*Lp*Mp*q2_d*q3_d*cos(q1)*cos(q2)*cos(q5) + 2*Lp*Mp*Rw*q1_d*q3_d*cos(q1)*sin(q2)*sin(q5) - Lp*Mp*Rw*q3_d*q4_d*cos(q2)*sin(q1)*sin(q5) + 2*Ipy*q1_d*q3_d*cos(q1)*cos(q2)*cos(q5)*sin(q2)*sin(q5) - 2*Ipz*q1_d*q3_d*cos(q1)*cos(q2)*cos(q5)*sin(q2)*sin(q5) + 2*Lp^2*Mp*q1_d*q3_d*cos(q1)*cos(q2)*cos(q5)*sin(q2)*sin(q5) + 2*Lc*Lp*Mp*q1_d*q3_d*cos(q1)*cos(q2)*sin(q2)*sin(q5) + 2*Lcp*Lp*Mp*q1_d*q3_d*cos(q1)*cos(q2)*sin(q2)*sin(q5)];

% Put in system values
const_symbolic = [Mw; Mc; Mp;...
             Iwx; Iwy; Iwz;...
             Icx; Icy; Icz;...
             Ipx; Ipy; Ipz;...
             Rw; Lc; Lcp; Lp; g];
         
M = subs(M, const_symbolic, const_values);
RHS = subs(RHS, const_symbolic, const_values);
%M = subs(M, [q2, q2_d, q3, q3_d, q4, q4_d, Lp], [0,0,0,0,0,0,0]); % These states are zero during standup
%RHS = subs(RHS, [q2, q2_d, q3, q3_d, q4, q4_d, Lp], [0,0,0,0,0,0,0]);
%M_roll_gamma = [M(1,1) M(1,5);M(5,1) M(5,5)];
EQN = M*ddq_v - RHS;
ddq = solve(EQN, ddq_v);
ddq_sym = [ddq.q1_dd; ddq.q2_dd; ddq.q3_dd; ddq.q4_dd; ddq.q5_dd];
%ddq_sym = simplify(collect(simplify(ddq_sym, 'Steps',10), state), 10);

save('ddq_sym', 'ddq_sym');
