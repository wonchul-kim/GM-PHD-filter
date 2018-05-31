function meas = gen_measurements(model, truth)

meas.length = truth.length;             % length of data
meas.Z = cell(truth.length, 1);         % each of measurements from true data

% generate measurements
for i = 1:truth.length
    if truth.N(i) > 0                                                                                   % if there is a target
        idx = find(rand(truth.N(i), 1) <= model.P_d);                                                   % detected target
        meas.Z{i} = gen_obervation_fn(model, truth.X{i}(:, idx), 'noise');
    end
    
    N_c = poissrnd(model.lambda_c);                                                                     % number of clutter points
    C= repmat(model.range_c(:,1),[1 N_c])+ diag(model.range_c*[ -1; 1 ])*rand(model.z_dim,N_c);         % clutter generation
    meas.Z{i} = [meas.Z{i} C];
    
end

