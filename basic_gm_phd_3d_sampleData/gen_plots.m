function get_plot(model, truth, meas, est)

[X_track,k_birth,k_death]= extract_tracks(truth.X,truth.track_list,truth.total_tracks);

% 1. plot ground truths
limit= [ model.range_c(1,1) model.range_c(1,2) model.range_c(2,1) model.range_c(2,2) model.range_c(3,1) model.range_c(3,2) ];
figure; truths= gcf; hold on;
for i=1:truth.total_tracks
    Pt= X_track(:,k_birth(i):1:k_death(i),i); Pt=Pt([1 3 5],:);
    plot3( Pt(1,:),Pt(2,:), Pt(3,:),'k-'); 
    plot3( Pt(1,1), Pt(2,1), Pt(3,1), 'k.','MarkerSize', 27);
    plot3( Pt(1,(k_death(i)-k_birth(i)+1)), Pt(2,(k_death(i)-k_birth(i)+1)), Pt(3,(k_death(i)-k_birth(i)+1)), 'ko','MarkerSize',7);
end
axis equal; axis(limit); title('Ground Truths');

%plot tracks and measurments in x/y
figure; tracking= gcf; hold on;

%plot x measurement ====================================================================



subplot(311); box on; 
for k=1:meas.length
    if ~isempty(meas.Z{k})
        hlined= line(k*ones(size(meas.Z{k},2),1),meas.Z{k}(1,:),'LineStyle','none','Marker','x','Markersize',5,'Color',0.7*ones(1,3));
    end   
end

%plot x track
for i=1:truth.total_tracks
    Px= X_track(:,k_birth(i):1:k_death(i),i); Px=Px([1 3 5],:);
    hline1= line(k_birth(i):1:k_death(i),Px(1,:),'LineStyle','-','Marker','none','LineWidth',1,'Color',0*ones(1,3));
end

%plot x estimate
for k=1:meas.length
    if ~isempty(est.X{k})
        P= est.X{k}([1 3 5],:);
        hline2= line(k*ones(size(est.X{k},2),1),P(1,:),'LineStyle','none','Marker','.','Markersize',8,'Color',0*ones(1,3));
    end
end


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
        yhline2= line(k*ones(size(est.X{k},2),1),P(2,:),'LineStyle','none','Marker','.','Markersize',8,'Color',0*ones(1,3));
    end
end


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

%plot y estimate
for k=1:meas.length
    if ~isempty(est.X{k}),
        P= est.X{k}([1 3 5],:);
        zhline2= line(k*ones(size(est.X{k},2),1),P(3,:),'LineStyle','none','Marker','.','Markersize',8,'Color',0*ones(1,3));
    end
end