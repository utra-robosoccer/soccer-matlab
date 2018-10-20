%% Test 1

close all;
hold off;

imgh = 500;
imgw = 500;

figure;

hold on;
for i = -1.5:0.01:3.1
    l = Geometry.Line2f(250, i);
    l.draw(imgh, imgw);
end

ylim([-200,imgh+200]);
xlim([-200,imgw+200]);

%% Test 2

close all;
hold off;

imgh = 500;
imgw = 500;

figure;

hold on;
for i = 1.5:0.01:3.1*2
    l = Geometry.Line2f(-250, i);
    l.draw(imgh, imgw);
end

ylim([-200,imgh+200]);
xlim([-200,imgw+200]);

%% Test 3


close all;
hold off;

imgh = 500;
imgw = 500;

figure;

hold on;
for i = -1.5:0.1:3.1
    for j = 0:50:300
        l = Geometry.Line2f(j, i);
        l.draw(imgh, imgw);
    end
end

ylim([-200,imgh+200]);
xlim([-200,imgw+200]);

%% Test 4

close all;
hold off;

imgh = 500;
imgw = 500;

figure;

hold on;
for i = -3.1:0.1:3.1
    for j = 50:50:250
        l = Geometry.Line2f(j, i);
        l2 = l.newOrigin(250,250);
        l2.draw(imgh, imgw);
    end
end

ylim([-200,imgh+200]);
xlim([-200,imgw+200]);
