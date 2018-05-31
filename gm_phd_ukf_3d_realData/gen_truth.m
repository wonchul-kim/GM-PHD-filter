function truth= gen_truth(model)

load('ballistic_target_old');
truth.data = ballistic_target;

nbirth = length(truth.data);
% variables
t = [];
for i = 1:nbirth
    t(i) = truth.data(i).time(end);
end

[t_max, id] = max(t);

step = floor(t_max/0.1) + 1;
time = zeros(nbirth, step);
truth.initial = zeros(nbirth,1);                                   % truth.initial time of each target
truth.terminal = zeros(nbirth,1);                                     % truth.terminal time of each target
for i = 1: nbirth
    truth.initial(i) = floor(truth.data(i).time(1)/0.1) + 1;
    truth.terminal(i) = floor(truth.data(i).time(end)/0.1) + 1;
    time(i, truth.initial(i):truth.terminal(i)) = truth.data(i).time;
    x(1:2, truth.initial(i):truth.terminal(i), i) = truth.data(i).geodetic;           % x, y position
    x(3, truth.initial(i):truth.terminal(i), i) = truth.data(i).Alt/1000;           % z position
end
x_ = zeros([6 size(x,2) size(x,3)]);
x_(1, :, :) = x(2, :, :);
x_(3, :, :) = x(1, :, :);
x_(5, :, :) = x(3, :, :);

%variables
truth.K= step;                   %length of truth.data/number of scans
truth.X= cell(truth.K,1);             %ground truth for states of targets  
truth.N= zeros(truth.K,1);            %ground truth for number of targets
truth.L= cell(truth.K,1);             %ground truth for labels of targets (k,i)
truth.track_list= cell(truth.K,1);    %absolute index target identities (plotting)
truth.total_tracks= 0;          %total number of appearing tracks

%generate the tracks
for targetnum=1:nbirth
    for k=truth.initial(targetnum):min(truth.terminal(targetnum),truth.K)
        truth.X{k}= [truth.X{k} x_(:, k, targetnum)];
        truth.track_list{k} = [truth.track_list{k} targetnum];
        truth.N(k) = truth.N(k) + 1;
     end
end
truth.total_tracks= nbirth;


% %% TEST
% X = truth.X;
% track_list = truth.track_list;
% total_tracks = truth.total_tracks;
% [X_track,k_birth,k_death]= extract_tracks(X,track_list,total_tracks);
% figure(34); 
% truths= gcf; 
% hold on; 
% map_plot; 
% axis([124 130.6 34.1 42.2 0 400]); grid on ;
% for i=1:truth.total_tracks
%     Pt= X_track(:,k_birth(i):k_death(i),i); 
%     Pt=Pt([1 3 5],:);
%     plot3( Pt(1,:),Pt(2,:), Pt(3,:)); 
%     plot3( Pt(1,1), Pt(2,1), Pt(3,1), 'k.','MarkerSize', 27);
%     plot3( Pt(1,(k_death(i)-k_birth(i)+1)), Pt(2,(k_death(i)-k_birth(i)+1)), Pt(3,(k_death(i)-k_birth(i)+1)), 'ko','MarkerSize',7);
% end
% xlabel('Latitude [degree]'); ylabel('Logitude [degree]'); zlabel('Altitude [km]');
% title('Ground Truths 1');
% 
% X = truth.X;
% track_list = truth.track_list;
% total_tracks = truth.total_tracks;
% [X_track,k_birth,k_death]= extract_tracks(X,track_list,total_tracks);
% figure(35); 
% truths= gcf; 
% hold on; 
% map_plot; 
% axis([124 130.6 34.1 42.2 0 400]); grid on ;
% for i=1:truth.total_tracks
%     Zt= gen_observation_fn( model, X_track(:,k_birth(i):1:k_death(i),i),'noiseless');    
% %     polar( -Zt(1,:)+pi/2, Zt(3,:),'k-'  );
% %     polar( -Zt(1,1)+pi/2, Zt(3,1), 'ko');
% %     polar( -Zt(1,k_death(i)-k_birth(i)+1)+pi/2, Zt(3,k_death(i)-k_birth(i)+1),'k^');
% 
%     [xx, yy, zz] = sph2cart(-Zt(1, :)-pi/2, Zt(2, :)+pi/2, Zt(3, :));
%     plot3( xx, yy, zz,'k-'); 
%     plot3( xx(1,1), yy(1,1), zz(1,1), 'ko','MarkerSize',6);
%     plot3( xx(1,(k_death(i)-k_birth(i) + 1)), yy(1,(k_death(i)-k_birth(i) + 1)), zz(1,(k_death(i)-k_birth(i) + 1)), 'k^','MarkerSize',6);
% end
% xlabel('Latitude [degree]'); ylabel('Logitude [degree]'); zlabel('Altitude [km]');
% title('Ground Truths 2');

end

