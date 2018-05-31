close all; clear all; clc;

model = gen_model();                                % Gaussian & Poisson model

ground_truth = gen_Gtruth(model);                   % Ground truth

meas = gen_measurements(model, ground_truth);       % Measurements

est = gm_phd(model, meas);                          % Estimates

gen_plots(model, ground_truth, meas, est);               % Plot the results