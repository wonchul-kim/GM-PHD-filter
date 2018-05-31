function ground_truth = gen_Gtruth(model)

% variables
truth.length = 100;                                  % length of data/number of scan
truth.X = cell(truth.length, 1);                     % states of targets 
truth.N = zeros(truth.length, 1);                    % number of targets
truth.L = cell(truth.length, 1);                     % labels of targets (k, i)
truth.track_list = cell(truth.length, 1);            % for plotting
truth.total_tracks = 0;                         % total number of appearing tracked targets

% initial states of targets (no spawning........................)
n_birth = 3;

startS(:, 1) = [0; 0; 0; -5; 0; 10];       t_birth(1) = 1;   t_terminal(1) = 70;             % target 1
startS(:, 2) = [400; -7; -600; -4; 0; 3];   t_birth(2) = 1;   t_terminal(2) = 90;             % target 2
startS(:, 3) = [-800; 20; -200; -5; 0; 5];  t_birth(3) = 20;  t_terminal(3) = 99;             % target 3


% generate tracks of each target
for targetNum = 1:n_birth
    state = startS(:, targetNum);
    for time = t_birth(targetNum):min(t_terminal(targetNum), truth.length)
        state = gen_newstate(model, state, 'noiseless');
        truth.X{time} = [truth.X{time} state];
        truth.track_list{time} = [truth.track_list{time} targetNum];
        truth.N(time) = truth.N(time) + 1;
    end
end

truth.total_tracks = n_birth;

ground_truth = truth;


% [X_track,k_birth,k_death]= extract_tracks(truth.X,truth.track_list,truth.total_tracks);
% 
% % 1. plot ground truths
% limit= [ model.range_c(1,1) model.range_c(1,2) model.range_c(2,1) model.range_c(2,2) model.range_c(3,1) model.range_c(3,2) ];
% figure; truths= gcf; hold on;
% for i=1:truth.total_tracks
%     Pt= X_track(:,k_birth(i):1:k_death(i),i); Pt=Pt([1 3 5],:);
%     plot3( Pt(1,:),Pt(2,:), Pt(3,:),'k-'); 
%     plot3( Pt(1,1), Pt(2,1), Pt(3,1), 'ko','MarkerSize',6);
%     plot3( Pt(1,(k_death(i)-k_birth(i)+1)), Pt(2,(k_death(i)-k_birth(i)+1)), Pt(3,(k_death(i)-k_birth(i)+1)), 'k^','MarkerSize',6);
% end
% axis equal; axis(limit); title('Ground Truths');

end

