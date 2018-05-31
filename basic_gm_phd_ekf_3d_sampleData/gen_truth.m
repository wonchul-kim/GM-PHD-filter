function truth= gen_truth(model)

%variables
truth.K= 100;                   %length of data/number of scans
truth.X= cell(truth.K,1);             %ground truth for states of targets  
truth.N= zeros(truth.K,1);            %ground truth for number of targets
truth.L= cell(truth.K,1);             %ground truth for labels of targets (k,i)
truth.track_list= cell(truth.K,1);    %absolute index target identities (plotting)
truth.total_tracks= 0;          %total number of appearing tracks

%target initial states and birth/death times
nbirths= 10;
wturn = 2*pi/180;

xstart(:,1)  = [ 1000+3.8676; -10; 1500-11.7457; -10; 0; 10; wturn/8 ];        tbirth(1)  = 1;     tdeath(1)  = truth.K+1;
xstart(:,2)  = [ -250-5.8857;  20; 1000+11.4102; 3; 0; 5; -wturn/3 ];         tbirth(2)  = 10;    tdeath(2)  = truth.K+1;
xstart(:,3)  = [ -1500-7.3806; 11; 250+6.7993; 10; 0; 7; -wturn/2 ];          tbirth(3)  = 10;    tdeath(3)  = truth.K+1;
xstart(:,4)  = [ -1500; 43; 250; 0; 0; 2; 0 ];                                tbirth(4)  = 10;    tdeath(4)  = 66;
xstart(:,5)  = [ 250-3.8676; 11; 750-11.0747; 5; 0; 15; wturn/4 ];             tbirth(5)  = 20;    tdeath(5)  = 80;
xstart(:,6)  = [ -250+7.3806; -12; 1000-6.7993; -12; 0; 20; wturn/2 ];         tbirth(6)  = 40;    tdeath(6)  = truth.K+1;
xstart(:,7)  = [ 1000; 0; 1500; -10; 0; 3; wturn/4 ];                         tbirth(7)  = 40;    tdeath(7)  = truth.K+1;
xstart(:,8)  = [ 250; -50; 750; 0; 0; 9;-wturn/4 ];                          tbirth(8)  = 40;    tdeath(8)  = 80;
xstart(:,9)  = [ 1000; -50; 1500; 0; 0; 8; -wturn/4 ];                        tbirth(9)  = 60;     tdeath(9)  = truth.K+1;
xstart(:,10)  = [ 250; -40; 750; 25; 0; 4; wturn/4 ];                         tbirth(10)  = 60;    tdeath(10)  = truth.K+1;

%generate the tracks
for targetnum=1:nbirths
    targetstate = xstart(:,targetnum);
    for k=tbirth(targetnum):min(tdeath(targetnum),truth.K)
        targetstate = gen_newstate_fn(model,targetstate,'noiseless');
        truth.X{k}= [truth.X{k} targetstate];
        truth.track_list{k} = [truth.track_list{k} targetnum];
        truth.N(k) = truth.N(k) + 1;
     end
end
truth.total_tracks= nbirths;


% [X_track,k_birth,k_death]= extract_tracks(truth.X,truth.track_list,truth.total_tracks);
% 
% % 1. plot ground truths
% figure(1); truths= gcf; hold on;
% for i=1:truth.total_tracks
%     Pt= X_track(:,k_birth(i):1:k_death(i),i); Pt=Pt([1 3 5],:);
%     plot3( Pt(1,:),Pt(2,:), Pt(3,:),'k-'); 
%     plot3( Pt(1,1), Pt(2,1), Pt(3,1), 'ko','MarkerSize',6);
%     plot3( Pt(1,(k_death(i)-k_birth(i)+1)), Pt(2,(k_death(i)-k_birth(i)+1)), Pt(3,(k_death(i)-k_birth(i)+1)), 'k^','MarkerSize',6);
% end
% axis equal; axis([-model.range_c(3,2) model.range_c(3,2) 0 model.range_c(3,2)]); title('Ground Truths');
% 
% %plot ground truths
% figure(2); truths= gcf; hold on;
% for i=1:truth.total_tracks
%     Zt= gen_observation_fn( model, X_track(:,k_birth(i):1:k_death(i),i),'noiseless');    
% %     polar( -Zt(1,:)+pi/2, Zt(3,:),'k-'  );
% %     polar( -Zt(1,1)+pi/2, Zt(3,1), 'ko');
% %     polar( -Zt(1,k_death(i)-k_birth(i)+1)+pi/2, Zt(3,k_death(i)-k_birth(i)+1),'k^');
% 
%     [x, y, z] = sph2cart(-Zt(1, :)-pi/2, Zt(2, :)+pi/2, Zt(3, :));
%     plot3( x, y, z,'k-'); 
%     plot3( x(1,1), y(1,1), z(1,1), 'ko','MarkerSize',6);
%     plot3( x(1,(k_death(i)-k_birth(i) + 1)), y(1,(k_death(i)-k_birth(i) + 1)), z(1,(k_death(i)-k_birth(i) + 1)), 'k^','MarkerSize',6);
% end
% axis equal; axis([-model.range_c(3,2) model.range_c(3,2) 0 model.range_c(3,2)]);title('Measurements');

end

