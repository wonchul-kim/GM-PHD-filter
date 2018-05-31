clear all; close all; clc;

model = gen_model();                                % Gaussian & Poisson model

ground_truth = load_data(model);                    % Load data

meas = gen_measurements(model, ground_truth);       % Get measurements

est = gm_phd(model, meas);                          % Estimates

gen_plots(model, ground_truth, meas, est);          % Plot the results