function [X_track,k_birth,k_death]= extract_tracks(X,track_list,total_tracks)

K = size(X,1); 
x_dim = size(X{K},1); 
% k=K-1; 
% while x_dim==0
%     x_dim= size(X{k},1); 
%     k= k-1; 
% end
X_track= zeros(x_dim,K,total_tracks);
k_birth = zeros(total_tracks, 1);
k_death = zeros(total_tracks, 1);

max_idx = 0;
min_idx = 0;
n_target = 0;
for k=1:K
    if ~isempty(X{k}),
        X_track(:,k,track_list{k})= X{k};
    end;
    if size(track_list{k}, 2)> n_target % new target born?
%         idx= find(track_list{k}> max_idx);
%         k_birth(track_list{k}(idx))= k;
        idx = [find((track_list{k} < min_idx)) find((track_list{k} > max_idx))];
        k_birth(track_list{k}(idx)) = k;
    end;
    if ~isempty(track_list{k})
%         max_idx= max(track_list{k});
        max_idx = max(track_list{k});
        min_idx = min(track_list{k});
        n_target = size(track_list{k}, 2);
    end
    k_death(track_list{k})= k;
end;