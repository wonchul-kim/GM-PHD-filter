function model= gen_model

% basic parameters
model.x_dim= 6;   %dimension of state vector   (x, dx, y, dy, z, dz)
model.z_dim= 3;   %dimension of observation vector   (theta(x-y), phi(z), r)
model.v_dim= 3;   %dimension of process noise    
model.w_dim= 3;   %dimension of observation noise

% dynamical model parameters (CT model)
% state transformation given by gen_newstate_fn, transition matrix is N/A in non-linear case
model.T= 0.1;                         % sampling period
model.sigma_vel= 0.1;
model.bt= model.sigma_vel*[ (model.T^2)/2; model.T ];
model.A0= [ 1 model.T; 0 1 ];                           %transition matrix                     
model.F= [ model.A0 zeros(2,4); 
           zeros(2,2) model.A0 zeros(2,2);
           zeros(2,4) model.A0];  
model.B2= [ model.bt zeros(2,2); 
            zeros(2,1) model.bt zeros(2,1);
            zeros(2,2) model.bt];
model.B= eye(model.v_dim);
model.Q= model.B*model.B';

% observation model parameters (noisy r/theta only)
% measurement transformation given by gen_observation_fn, observation matrix is N/A in non-linear case
model.D= diag([ pi/1800; pi/1800; 1 ]);      %std for angle and range noise
model.R= model.D*model.D';              %covariance for observation noise

% detection parameters
model.P_D = 0.8;   %probability of detection in measurements
model.Q_D = 1 - model.P_D; %probability of missed detection in measurements

% clutter parameters (uniform clutter)
model.lambda_c= 10;                             % poisson average rate of uniform clutter (per scan)
model.range_c= [ -pi/2 pi/2;                   % theta
                   -pi  pi;                    % phi
                    0  2000 ];                 % r
model.pdf_c= 1/prod(model.range_c(:,2)-model.range_c(:,1)); %uniform clutter density

% survival/death parameters
model.P_S= 0.8;
model.Q_S= 1 - model.P_S;

% birth parameters (LMB birth model, single component only)
model.L_birth= 4;                                                     %no. of Gaussian birth terms
model.w_birth= zeros(model.L_birth,1);                                %weights of Gaussian birth terms (per scan) [sum gives average rate of target birth per scan]
model.m_birth= zeros(model.x_dim,model.L_birth);                      %means of Gaussian birth terms 
model.B_birth= zeros(model.x_dim,model.x_dim,model.L_birth);          %std of Gaussian birth terms
model.P_birth= zeros(model.x_dim,model.x_dim,model.L_birth);          %cov of Gaussian birth terms

model.w_birth(1)= 0.9;                                              %birth term 1
model.m_birth(:,1)= [127.12; 0; 41.4; 0; 0; 0];  
model.B_birth(:,:,1)= diag([3; 7; 3; 7; 10; 10]);    
model.P_birth(:,:,1)= model.B_birth(:,:,1)*model.B_birth(:,:,1)';
    
model.w_birth(2)= 0.9;                                              %birth term 2
model.m_birth(:,2)= [128.62; 0; 40.95; 0; 0; 0];
model.B_birth(:,:,2)= diag([3; 7; 3; 7; 10; 10]); 
model.P_birth(:,:,2)= model.B_birth(:,:,2)*model.B_birth(:,:,2)';

model.w_birth(3)= 0.9;                                              %birth term 3
model.m_birth(:,3)= [129.32; 0; 40.95; 0; 0; 0];
model.B_birth(:,:,3)= diag([3; 7; 3; 7; 10; 10]);     
model.P_birth(:,:,3)= model.B_birth(:,:,3)*model.B_birth(:,:,3)';

model.w_birth(4)= 0.9;                                              %birth term 4
model.m_birth(:,4)= [124.82; 40; 0; 0; 0; 0];   
model.B_birth(:,:,4)= diag([3; 7; 3; 7; 7; 10]);   
model.P_birth(:,:,4)= model.B_birth(:,:,4)*model.B_birth(:,:,4)';







