function handles= plot_results(model,truth,meas,est)

[X_track,k_birth,k_death]= extract_tracks(truth.X,truth.track_list,truth.total_tracks);

%% 1. plot ground truth
figure(2); truths= gcf; hold on;
for i=1:truth.total_tracks
    Zt= gen_observation_fn( model, X_track(:,k_birth(i):1:k_death(i),i),'noiseless');    
%     polar( -Zt(1,:)+pi/2, Zt(3,:),'k-'  );
%     polar( -Zt(1,1)+pi/2, Zt(3,1), 'ko');
%     polar( -Zt(1,k_death(i)-k_birth(i)+1)+pi/2, Zt(3,k_death(i)-k_birth(i)+1),'k^');

    [x, y, z] = sph2cart(-Zt(1, :)-pi/2, Zt(2, :)+pi/2, Zt(3, :));
    plot3( x, y, z,'k-'); 
    plot3( x(1,1), y(1,1), z(1,1), 'ko','MarkerSize',6);
    plot3( x(1,(k_death(i)-k_birth(i) + 1)), y(1,(k_death(i)-k_birth(i) + 1)), z(1,(k_death(i)-k_birth(i) + 1)), 'k^','MarkerSize',6);
end
axis equal; axis([-model.range_c(3,2) model.range_c(3,2) 0 model.range_c(3,2)]);title('Ground Truth');

%% 2. plot the results
figure(); hold on;
for i=1:truth.total_tracks
    Zt= gen_observation_fn( model, X_track(:,k_birth(i):1:k_death(i),i),'noiseless');    
%     polar( -Zt(1,:)+pi/2, Zt(3,:),'k-'  );
%     polar( -Zt(1,1)+pi/2, Zt(3,1), 'ko');
%     polar( -Zt(1,k_death(i)-k_birth(i)+1)+pi/2, Zt(3,k_death(i)-k_birth(i)+1),'k^');

    [x, y, z] = sph2cart(-Zt(1, :)-pi/2, Zt(2, :)+pi/2, Zt(3, :));
    plot3( x, y, z,'k-'); 
    plot3( x(1,1), y(1,1), z(1,1), 'ko','MarkerSize',6);
    plot3( x(1,(k_death(i)-k_birth(i) + 1)), y(1,(k_death(i)-k_birth(i) + 1)), z(1,(k_death(i)-k_birth(i) + 1)), 'k^','MarkerSize',6);
end

hold on;
for j = 1:meas.K
    for k = 1:est.N(j)
        est_P = est.X{j}([1 3 5], k);
        plot3(est_P(1, 1), est_P(2, 1), est_P(3, 1), 'k.', 'MarkerSize', 0.1);
    end
end
xlabel('Latitude [degree]'); ylabel('Logitude [degree]'); zlabel('Altitude [km]');
title('Estimation Results');

%% 3. Results
figure; tracking= gcf; hold on;
%plot x measurement -------------------------------------------------------------------------------
subplot(311); box on; 
for k=1:meas.K
    if ~isempty(meas.Z{k})
        hlined= line(k*ones(size(meas.Z{k},2),1),meas.Z{k}(2,:).*sin(meas.Z{k}(1,:)),'LineStyle','none','Marker','x','Markersize',5,'Color',0.7*ones(1,3));
    end   
end

for i=1:truth.total_tracks
    Px= X_track(:,k_birth(i):1:k_death(i),i); Px=Px([1 3 5],:);
    hline1= line(k_birth(i):1:k_death(i),Px(1,:),'LineStyle','-','Marker','none','LineWidth',1,'Color',0*ones(1,3));
end

%plot x estimate
for k=1:meas.K
    if ~isempty(est.X{k})
        P= est.X{k}([1 3 5],:);
        hline2= line(k*ones(size(est.X{k},2),1),P(1,:),'LineStyle','none','Marker','.','Markersize',8,'Color',0*ones(1,3));
    end
end

%plot y measurement -------------------------------------------------------------------------------
subplot(312); box on;
    
for k=1:meas.K
    if ~isempty(meas.Z{k})
        yhlined= line(k*ones(size(meas.Z{k},2),1),meas.Z{k}(2,:).*cos(meas.Z{k}(1,:)),'LineStyle','none','Marker','x','Markersize',5,'Color',0.7*ones(1,3));
    end
end

%plot y track
for i=1:truth.total_tracks
        Py= X_track(:,k_birth(i):1:k_death(i),i); Py=Py([1 3 5],:);
        yhline1= line(k_birth(i):1:k_death(i),Py(2,:),'LineStyle','-','Marker','none','LineWidth',1,'Color',0*ones(1,3));
end

%plot y estimate
for k=1:meas.K
    if ~isempty(est.X{k}),
        P= est.X{k}([1 3 5],:);
        yhline2= line(k*ones(size(est.X{k},2),1),P(2,:),'LineStyle','none','Marker','.','Markersize',8,'Color',0*ones(1,3));
    end
end
%plot z measurement -------------------------------------------------------------------------------
subplot(313); box on;
for k=1:meas.K
    if ~isempty(meas.Z{k})
        zhlined= line(k*ones(size(meas.Z{k},2),1),meas.Z{k}(2,:).*cos(meas.Z{k}(1,:)),'LineStyle','none','Marker','x','Markersize',5,'Color',0.7*ones(1,3));
    end
end

%plot z track
for i=1:truth.total_tracks
        Pz= X_track(:,k_birth(i):1:k_death(i),i); Pz=Pz([1 3 5],:);
        zhline1= line(k_birth(i):1:k_death(i),Pz(3,:),'LineStyle','-','Marker','none','LineWidth',1,'Color',0*ones(1,3));
end

%plot z estimate
for k=1:meas.K
    if ~isempty(est.X{k}),
        P= est.X{k}([1 3 5],:);
        zhline2= line(k*ones(size(est.X{k},2),1),P(3,:),'LineStyle','none','Marker','.','Markersize',8,'Color',0*ones(1,3));
    end
end



%% 4. 
% subplot(211); xlabel('Time'); ylabel('x-coordinate (m)');
% set(gca, 'XLim',[1 truth.K]); set(gca, 'YLim',[-model.range_c(2,2) model.range_c(2,2)]);
% legend([hline2 hline1 hlined],'Estimates          ','True tracks','Measurements');

% subplot(212); xlabel('Time'); ylabel('y-coordinate (m)');
% set(gca, 'XLim',[1 truth.K]); set(gca, 'YLim',[ model.range_c(1,2) model.range_c(2,2)] );
%legend([yhline2 yhline1 yhlined],'Estimates          ','True tracks','Measurements');

%plot error
ospa_vals= zeros(truth.K,3);
ospa_c= 100;
ospa_p= 1;
for k=1:meas.K
    [ospa_vals(k,1), ospa_vals(k,2), ospa_vals(k,3)]= ospa_dist(get_comps(truth.X{k},[1 3]),get_comps(est.X{k},[1 3]),ospa_c,ospa_p);
end

figure; ospa= gcf; hold on;
subplot(3,1,1); plot(1:meas.K,ospa_vals(:,1),'k'); grid on; set(gca, 'XLim',[1 meas.K]); set(gca, 'YLim',[0 ospa_c]); ylabel('OSPA Dist');
subplot(3,1,2); plot(1:meas.K,ospa_vals(:,2),'k'); grid on; set(gca, 'XLim',[1 meas.K]); set(gca, 'YLim',[0 ospa_c]); ylabel('OSPA Loc');
subplot(3,1,3); plot(1:meas.K,ospa_vals(:,3),'k'); grid on; set(gca, 'XLim',[1 meas.K]); set(gca, 'YLim',[0 ospa_c]); ylabel('OSPA Card');
xlabel('Time');

%plot cardinality
figure; cardinality= gcf; 
subplot(2,1,1); box on; hold on;
stairs(1:meas.K,truth.N,'k'); 
plot(1:meas.K,est.N,'k.');

grid on;
legend(gca,'True','Estimated');
set(gca, 'XLim',[1 meas.K]); set(gca, 'YLim',[0 max(truth.N)+1]);
xlabel('Time'); ylabel('Cardinality');

%return
handles=[ truths tracking ospa cardinality ];


function Xc= get_comps(X,c)

if isempty(X)
    Xc= [];
else
    Xc= X(c,:);
end
