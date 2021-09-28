function TF = errorDetection(coordPoint, radius_outer, radius_inner)

%input: coordPoint = 1x2 vector of xy position of point.

% global radius_outer
% global radius_inner

r1_2 = (radius_inner)^2; %inner radius
r2_2 = (radius_outer)^2; %outer radius
xc = 0; yc = 0; %xy coordinate of center of circle

d_2 = (coordPoint(1)-xc)^2 + (coordPoint(2) - yc)^2;

if (r1_2 <= d_2) && (d_2 <= r2_2)
    TF = 1;
else
    TF = 0;
end
