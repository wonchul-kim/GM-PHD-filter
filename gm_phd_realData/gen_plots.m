function get_plot(model, truth, meas, est)

% 1. plot ground truths
[X_track,k_birth,k_death]= extract_tracks(truth.X, truth.track_list, truth.total_tracks);

% limit= [ model.range_c(1,1) model.range_c(1,2) model.range_c(2,1) model.range_c(2,2) model.range_c(3,1) model.range_c(3,2) ];
figure; 
truths= gcf; 
hold on; 
map_plot; 
axis([124 130.6 34.1 42.2 0 400]); grid on ;
for i=1:truth.total_tracks
    Pt= X_track(:,k_birth(i):k_death(i),i); 
    Pt=Pt([1 3 5],:);
    plot3( Pt(1,:),Pt(2,:), Pt(3,:)); 
%     plot3( Pt(1,1), Pt(2,1), Pt(3,1), 'k.','MarkerSize', 27);
%     plot3( Pt(1,(k_death(i)-k_birth(i)+1)), Pt(2,(k_death(i)-k_birth(i)+1)), Pt(3,(k_death(i)-k_birth(i)+1)), 'ko','MarkerSize',7);
end
xlabel('Latitude [degree]'); ylabel('Logitude [degree]'); zlabel('Altitude [km]');
title('Ground Truths');



% 2. plot the results
figure; 
truths= gcf; 
hold on; 
map_plot; 
axis([124 130.6 34.1 42.2 0 400]); grid on ;
% for i=1:truth.total_tracks
%     Pt= X_track(:,k_birth(i):k_death(i),i); 
%     Pt=Pt([1 3 5],:);
%     plot3( Pt(1,:),Pt(2,:), Pt(3,:)); 
% %     plot3( Pt(1,1), Pt(2,1), Pt(3,1), 'k.','MarkerSize', 27);
% %     plot3( Pt(1,(k_death(i)-k_birth(i)+1)), Pt(2,(k_death(i)-k_birth(i)+1)), Pt(3,(k_death(i)-k_birth(i)+1)), 'ko','MarkerSize',7);
% end

hold on;
for j = 1:meas.length
    for k = 1:est.N(j)
        est_P = est.X{j}([1 3 5], k);
        plot3(est_P(1, 1), est_P(2, 1), est_P(3, 1), 'k.', 'MarkerSize', 0.1);
    end
end
xlabel('Latitude [degree]'); ylabel('Logitude [degree]'); zlabel('Altitude [km]');
title('Estimation Results');





% 3. plot tracks and measurments in x, y, z respectively
figure; tracking = gcf; hold on;

%plot x measurement ====================================================================
subplot(311); box on; 
for k=1:meas.length
    if ~isempty(meas.Z{k})
        hlined= line(k*ones(size(meas.Z{k},2),1),meas.Z{k}(1,:),'LineStyle','none','Marker','x','Markersize',1,'Color',0.7*ones(1,3));
    end   
end

%plot x track
for i=1:truth.total_tracks
    Px= X_track(:,k_birth(i):1:k_death(i),i); Px=Px([1 3 5],:);
    hline1= line(k_birth(i):1:k_death(i),Px(1,:),'LineStyle','-','Marker','none','LineWidth',0.1,'Color',0*ones(1,3));
end

%plot x estimate
for k=1:meas.length
    if ~isempty(est.X{k})
        P= est.X{k}([1 3 5],:);
        hline2= line(k*ones(size(est.X{k},2),1),P(1,:),'LineStyle','none','Marker','*','Markersize',2,'Color', [0,0,1]);
    end
end

axis([0 k_death(1) 124   130.6]);
                 
%plot y measurement ====================================================================
subplot(312); box on;
for k=1:meas.length
    if ~isempty(meas.Z{k})
        yhlined= line(k*ones(size(meas.Z{k},2),1),meas.Z{k}(2,:),'LineStyle','none','Marker','x','Markersize',5,'Color',0.7*ones(1,3));
    end
end

%plot y track
for i=1:truth.total_tracks
        Py= X_track(:,k_birth(i):1:k_death(i),i); Py=Py([1 3 5],:);
        yhline1= line(k_birth(i):1:k_death(i),Py(2,:),'LineStyle','-','Marker','none','LineWidth',1,'Color',0*ones(1,3));
end

%plot y estimate
for k=1:meas.length
    if ~isempty(est.X{k}),
        P= est.X{k}([1 3 5],:);
        yhline2= line(k*ones(size(est.X{k},2),1),P(2,:),'LineStyle','none','Marker','.','Markersize',8,'Color', [0,0,1]);
    end
end

axis([0 k_death(1) 36  42.2]);
                 

%plot z measurement ====================================================================
subplot(313); box on;
for k=1:meas.length
    if ~isempty(meas.Z{k})
        zhlined= line(k*ones(size(meas.Z{k},2),1),meas.Z{k}(3,:),'LineStyle','none','Marker','x','Markersize',5,'Color',0.7*ones(1,3));
    end
end

%plot z track
for i=1:truth.total_tracks
        Py= X_track(:,k_birth(i):1:k_death(i),i); Py=Py([1 3 5],:);
        zhline1= line(k_birth(i):1:k_death(i),Py(3,:),'LineStyle','-','Marker','none','LineWidth',1,'Color',0*ones(1,3));
end

%plot z estimate
for k=1:meas.length
    if ~isempty(est.X{k}),
        P= est.X{k}([1 3 5],:);
        zhline2= line(k*ones(size(est.X{k},2),1),P(3,:),'LineStyle','none','Marker','.','Markersize',8,'Color',[0,0,1]);
    end
end

axis([0 k_death(1) 0 400]); 

subplot(311); xlabel('Time'); ylabel('x-coordinate (degree)');
legend([hline2 hline1 hlined],'Estimates          ','True tracks', 'Measurements');
% 
subplot(312); xlabel('Time'); ylabel('y-coordinate (degree)');
%legend([yhline2 yhline1 yhlined],'Estimates          ','True tracks','Measurements');

subplot(313); xlabel('Time'); ylabel('z-coordinate (km)');







% 
% %% 4. Evaluation
% %plot error
% ospa_vals= zeros(truth.length,3);
% ospa_c= 100;
% ospa_p= 1;
% for k=1:meas.length
%     [ospa_vals(k,1), ospa_vals(k,2), ospa_vals(k,3)]= ospa_dist(get_comps(truth.X{k},[1 3 5]),get_comps(est.X{k},[1 3 5]),ospa_c,ospa_p);
% end
% 
% figure; ospa= gcf; hold on;
% subplot(3,1,1); plot(1:meas.length,ospa_vals(:,1),'k'); grid on; set(gca, 'XLim',[1 meas.length]); set(gca, 'YLim',[0 ospa_c]); ylabel('OSPA Dist');
% subplot(3,1,2); plot(1:meas.length,ospa_vals(:,2),'k'); grid on; set(gca, 'XLim',[1 meas.length]); set(gca, 'YLim',[0 ospa_c]); ylabel('OSPA Loc');
% subplot(3,1,3); plot(1:meas.length,ospa_vals(:,3),'k'); grid on; set(gca, 'XLim',[1 meas.length]); set(gca, 'YLim',[0 ospa_c]); ylabel('OSPA Card');
% xlabel('Time');
% 
% %plot cardinality
% figure; cardinality= gcf; 
% hold on;
% stairs(1:meas.length,truth.N,'k'); 
% plot(1:meas.length,est.N,'k.');
% 
% grid on;
% legend(gca,'True','Estimated');
% set(gca, 'XLim',[1 meas.length]); set(gca, 'YLim',[0 max(truth.N)+2]);
% xlabel('Time'); ylabel('Cardinality');
% 
% %return
% % handles=[ truths tracking ospa cardinality ];
% 
% function Xc= get_comps(X,c)
% 
% if isempty(X)
%     Xc= [];
% else
%     Xc= X(c,:);
% end
