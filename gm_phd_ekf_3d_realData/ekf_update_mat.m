function [H,U]= ekf_update_mat(model,mu)

%  p= mu([1 3],:);
%  mag= p(1)^2 + p(2)^2;
%  sqrt_mag= sqrt(mag);
%  H= [ p(2)/mag  0  -p(1)/mag  0  0; ...
%          p(1)/sqrt_mag  0  p(2)/sqrt_mag 0  0 ];
%  U= eye(2);
%  

% theta phi r

p= mu([1 3 5],:);
mag1= p(1)^2 + p(2)^2;
mag2 = p(1)^2 + p(2)^2 + p(3)^2;
sqrt_mag1 = sqrt(mag1);
sqrt_mag2 = sqrt(mag2);
H= [ p(2)/mag1                   0           -p(1)/mag1          0            0       0   ; ...
     p(1)*p(3)/(mag2*sqrt_mag1)  0   p(2)*p(3)/(mag2*sqrt_mag1)  0   -sqrt_mag1/mag2  0   ; ...
     p(1)/sqrt_mag2              0       p(2)/sqrt_mag2          0    p(3)/sqrt_mag2  0   ];
U= eye(3);
 