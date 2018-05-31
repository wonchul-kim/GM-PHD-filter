function model = gen_model

% dimension of state and observation
model.x_dim = 6;    % dimension of state vector (x, y, z, dx, dy, dz)
model.z_dim = 3;    % dimension of observation vector (x, y, z)

% model dynamic
model.T= 1;                                             %sampling period
model.A0= [ 1 model.T; 0 1 ];                           %transition matrix                     
model.F= [ model.A0 zeros(2,4); 
           zeros(2,2) model.A0 zeros(2,2);
           zeros(2,4) model.A0];  
model.B0= [ (model.T^2)/2; model.T ];
model.B= [ model.B0 zeros(2,2); 
           zeros(2,1) model.B0 zeros(2,1);
           zeros(2,2) model.B0];
model.sigma_v = 5;
model.Q= (model.sigma_v)^2* model.B*model.B';   %process noise covariance

% observation model parameters (noise x, y, z - position only)
model.H = [1 0 0 0 0 0;
           0 0 1 0 0 0; 
           0 0 0 0 1 0];                 % observation matrix
model.D = diag([10; 10; 10]);
model.R = model.D*model.D';          % observation noise covariance

% survival parameters
model.P_s = 0.99;
model.Q_s = 1 - model.P_s;

% detection parameters in measurements
model.P_d = 0.98;                    % probability of detection in measurements
model.Q_d = 1 - model.P_d;         

% clutter parameters
model.lambda_c = 60;                   % poisson average rate of uniform clutter (per scan)
model.range_c = [-1000 1000;
                 -1000 1000;
                 -1000 1000];          % uniform clutter region
model.pdf_c = 1/prod(model.range_c(:, 2) - model.range_c(:, 1));          % uniform clutter density

% birth parameters (Poisson birth model & Gaussian)
model.L_birth = 6;                                                                 % number of Gaussian birth terms
model.w_birth = zeros(model.L_birth, 1);                                           % weight of Gaussian birth terms (per scan)
                                                                                   % [sum gives average rate of target birth per scan]
model.m_birth = zeros(model.x_dim, model.L_birth);                                 % means of Gaussian birth terms ---> position
model.B_birth = zeros(model.x_dim, model.x_dim, model.L_birth);                    % std. of Gaussian birth terms
model.P_birth = zeros(model.x_dim, model.x_dim, model.L_birth);                    % cov. of Gaussian birth terms

model.w_birth(1) = 3/100;                                                          % birth term 1
model.m_birth(:, 1) = [0; 0; 0; 0; 0; 0];
model.B_birth(:, :, 1) = diag([10; 10; 10; 10; 10; 10]);
model.P_birth(:, :, 1) = model.B_birth(:, :, 1)*model.B_birth(:, :, 1);

model.w_birth(2) = 3/100;                                                          % birth term 2
model.m_birth(:, 2) = [400; 0; -600; 0; 0; 0];
model.B_birth(:, :, 2) = diag([10; 10; 10; 10; 10; 10]);
model.P_birth(:, :, 2) = model.B_birth(:, :, 2)*model.B_birth(:, :, 2);

model.w_birth(3) = 3/100;                                                          % birth term 3
model.m_birth(:, 3) = [-800; 0; -200; 0; 0; 0];
model.B_birth(:, :, 3) = diag([10; 10; 10; 10; 10; 10]);
model.P_birth(:, :, 3) = model.B_birth(:, :, 3)*model.B_birth(:, :, 3);

model.w_birth(4) = 3/100;                                                          % birth term 4
model.m_birth(:, 4) = [-200; 0; 800; 0; 0; 0];
model.B_birth(:, :, 4) = diag([10; 10; 10; 10; 10; 10]);
model.P_birth(:, :, 4) = model.B_birth(:, :, 4)*model.B_birth(:, :, 4);

model.w_birth(5) = 3/100;                                                          % birth term 3
model.m_birth(:, 5) = [-800; 0; -200; 0; 0; 0];
model.B_birth(:, :, 5) = diag([10; 10; 10; 10; 10; 10]);
model.P_birth(:, :, 5) = model.B_birth(:, :, 5)*model.B_birth(:, :, 5);

model.w_birth(6) = 3/100;                                                          % birth term 4
model.m_birth(:, 6) = [-200; 0; 800; 0; 0; 0];
model.B_birth(:, :, 6) = diag([10; 10; 10; 10; 10; 10]);
model.P_birth(:, :, 6) = model.B_birth(:, :, 6)*model.B_birth(:, :, 6);


end