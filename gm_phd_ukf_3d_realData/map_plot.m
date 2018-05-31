% figure();
% hold on;
xlabel('x');
ylabel('y');
zlabel('z');
img = imread('map_image2.bmp');                                  ; % Load a sample image
xImage = [124 130.6; 124 130.6]                                     ; % The x data for the image corners
yImage = [42.2 42.2; 34.1 34.1]                                     ; % The y data for the image corners
zImage = [0 0; 0 0]                                             ; % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img,'FaceColor','texturemap') ; %Plot the surface


plot3(124.82,  40,  0, 'ro')            ; % Tongchangdong site
plot3(127.12,  41.4, 0, 'ro')           ; % Yongjuri site
plot3(128.62, 40.95, 0, 'ro')           ; % Sangnamri site
plot3(129.32, 40.95, 0, 'ro')           ; % Musudanri site


plot3(126.96, 37.53, 0, 'bo')           ; % seoul
plot3(127.38, 36.35, 0, 'bo')           ; % daejeon
plot3(127.92, 37.34, 0, 'bo')           ; % wonju
plot3(128.6,  35.87, 0, 'bo')           ; % daegu
plot3(126.9,  35.16, 0, 'bo')           ; % gwangju
plot3(129.08, 35.18, 0, 'bo')           ; % busan


airportPostion = [ 125+0.85   125+0.85  124.7+0.85  124.6+0.85  125.1+0.85  125.4+0.85  123.9+0.85   125+0.85  124.5+0.85  124.5+0.85  126.7+0.85  126.5+0.85  126.6+0.85  126.7+0.85  126.3+0.85  127+0.85  126.8+0.85  128.3+0.85  128.6+0.85  128.7+0.85  127.5+0.85  127.7+0.85  125.8+0.85  126.5+0.85  127.3+0.85;
                  38.9  39.2   38.8   38.1   38.5   38.1     40  39.8   39.8     40   39.1   39.3   39.4   38.6   38.6   40   39.9     41   41.5   41.8   41.5     42   41.3   40.3   40.7];
for i = 1:1:length(airportPostion)
    plot3(airportPostion(1,i),airportPostion(2,i),0,'go');
end