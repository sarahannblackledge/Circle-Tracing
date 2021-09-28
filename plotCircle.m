function [x, y] =  plotCircle(r)

th = 0:pi/50:2*pi;
x = r*cos(th);
y = r*sin(th);

