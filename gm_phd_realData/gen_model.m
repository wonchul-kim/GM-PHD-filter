function model = gen_model

% dimension of state and observation
model.x_dim = 6;    % dimension of state vector (x, y, z, dx, dy, dz)
model.z_dim = 3;    % dimension of observation vector (x, y, z)

% model dynamic
model.T= 0.1;                                             %sampling period
model.A0= [ 1 model.T; 0 1 ];                           %transition matrix                     
model.F= [ model.A0 zeros(2,4); 
           zeros(2,2) model.A0 zeros(2,2);
           zeros(2,4) model.A0];  
       
model.B0= [ (model.T^2)/2; model.T ];
model.B= [ model.B0 zeros(2,2); 
           zeros(2,1) model.B0 zeros(2,1);
           zeros(2,2) model.B0];

model.sigma_v = 0.1;
model.Q= (model.sigma_v)^2* model.B*model.B';   %process noise covariance

% observation model parameters (noise x, y, z - position only)
model.H = [1 0 0 0 0 0;
           0 0 1 0 0 0; 
           0 0 0 0 1 0];                 % observation matrix
model.D = diag([0.3; 0.3; 0.3]);
model.R = model.D*model.D';          % observation noise covariance

% survival parameters
model.P_s = 0.8;
model.Q_s = 1 - model.P_s;

% detection parameters in measurements
model.P_d = 0.75;                    % probability of detection in measurements
model.Q_d = 1 - model.P_d;         

% clutter parameters
model.lambda_c = 10;                   % poisson average rate of uniform clutter (per scan)
model.range_c = [100   200;
                 0     100;
                 0     400 ];          % uniform clutter region
model.pdf_c = 1/prod(model.range_c(:, 2) - model.range_c(:, 1));          % uniform clutter density

% birth parameters (Poisson birth model & Gaussian)
model.L_birth = 4;                                                                 % number of Gaussian birth terms
model.w_birth = zeros(model.L_birth, 1);                                           % weight of Gaussian birth terms (per scan)
                                                                                   % [sum gives average rate of target birth per scan]
model.m_birth = zeros(model.x_dim, model.L_birth);                                 % means of Gaussian birth terms ---> position
model.B_birth = zeros(model.x_dim, model.x_dim, model.L_birth);                    % std. of Gaussian birth terms
model.P_birth = zeros(model.x_dim, model.x_dim, model.L_birth);                    % cov. of Gaussian birth terms

model.w_birth(1) = 9/10;                                                          % birth term 1
model.m_birth(:, 1) = [127.12; 0; 41.4; 0; 0; 0];
model.B_birth(:, :, 1) = diag([3; 7; 3; 7; 10; 10]);
model.P_birth(:, :, 1) = model.B_birth(:, :, 1)*model.B_birth(:, :, 1);

model.w_birth(2) = 9/10;                                                          % birth term 2
model.m_birth(:, 2) = [128.62; 0; 40.95; 0; 9.3132e-13; 0];
model.B_birth(:, :, 2) = diag([3; 7; 3; 7; 10; 10]);
model.P_birth(:, :, 2) = model.B_birth(:, :, 2)*model.B_birth(:, :, 2);

model.w_birth(3) = 9/10;                                                          % birth term 3
model.m_birth(:, 3) = [129.32; 0; 40.950; 0; 9.3132e-13; 0];
model.B_birth(:, :, 3) = diag([3; 7; 3; 7; 10; 10]);
model.P_birth(:, :, 3) = model.B_birth(:, :, 3)*model.B_birth(:, :, 3);

model.w_birth(4) = 9/10;                                                          % birth term 4
model.m_birth(:, 4) = [124.82; 40; 0; 0; 0; 0];
model.B_birth(:, :, 4) = diag([3; 7; 3; 7; 10; 10]);
model.P_birth(:, :, 4) = model.B_birth(:, :, 4)*model.B_birth(:, :, 4);

end