function new_state = gen_newstate(model, state, option)

% linear state space equation

if strcmp(option, 'noise')
    V = model.sigma_v*model.B*randn(size(model.B, 2), size(state, 2));
elseif strcmp(option, 'noiseless')
    V = zeros(size(model.B, 1), size(state, 2));
end

if isempty(state)
    new_state = [];
else
    new_state = model.F*state + V;
end

