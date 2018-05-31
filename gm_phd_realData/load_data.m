function ground_truth = load_data(model)

load('ballistic_target_old');
data = ballistic_target; 

n_birth = length(data);

% variables
t = [];
for i = 1:n_birth
    t(i) = data(i).time(end);
end

[t_max, id] = max(t);

step = floor(t_max/0.1) + 1;
time = zeros(n_birth, step);
truth.initial = zeros(n_birth,1);                                   % truth.initial time of each target
truth.terminal = zeros(n_birth,1);                                     % truth.terminal time of each target
for i = 1: n_birth
    truth.initial(i) = floor(data(i).time(1)/0.1) + 1;
    truth.terminal(i) = floor(data(i).time(end)/0.1) + 1;
    time(i, truth.initial(i):truth.terminal(i)) = data(i).time;
    x(1:2, truth.initial(i):truth.terminal(i), i) = data(i).geodetic;           % x, y position
    x(3, truth.initial(i):truth.terminal(i), i) = data(i).Alt/1000;           % z position
end
x_ = zeros([6 size(x,2) size(x,3)]);
x_(1, :, :) = x(2, :, :);
x_(3, :, :) = x(1, :, :);
x_(5, :, :) = x(3, :, :);

truth.length = step;                                  % length of data/number of scan
truth.X = cell(truth.length, 1);                     % states of targets 
truth.N = zeros(truth.length, 1);                    % number of targets
truth.L = cell(truth.length, 1);                     % labels of targets (k, i)
truth.track_list = cell(truth.length, 1);            % for plotting
truth.total_tracks = 0;                         % total number of appearing tracked targets

for targetNum = 1:n_birth
%     state = startS(:, targetNum);
    for time = truth.initial(targetNum):min(truth.terminal(targetNum), truth.length)
        truth.X{time} = [truth.X{time} x_(:, time, targetNum) ];
        truth.track_list{time} = [truth.track_list{time} targetNum];
        truth.N(time) = truth.N(time) + 1;
    end
end

truth.total_tracks = n_birth;
ground_truth = truth ;



% TEST BY GRAPHING ......................................................................
% X = truth.X;
% track_list = truth.track_list;
% total_tracks = truth.total_tracks;
% [X_track,k_birth,k_death]= extract_tracks(X,track_list,total_tracks);
% % 1. plot ground truths
% figure(34); 
% truths= gcf; 
% hold on; 
% map_plot; 
% axis([124 130.6 34.1 42.2 0 400]); grid on ;
% for i=1:truth.total_tracks
%     Pt= X_track(:,k_birth(i):k_death(i),i); 
%     Pt=Pt([1 3 5],:);
%     plot3( Pt(1,:),Pt(2,:), Pt(3,:)); 
% %     plot3( Pt(1,1), Pt(2,1), Pt(3,1), 'k.','MarkerSize', 27);
% %     plot3( Pt(1,(k_death(i)-k_birth(i)+1)), Pt(2,(k_death(i)-k_birth(i)+1)), Pt(3,(k_death(i)-k_birth(i)+1)), 'ko','MarkerSize',7);
% end
% xlabel('Latitude [degree]'); ylabel('Logitude [degree]'); zlabel('Altitude [km]');
% title('Ground Truths');

end

