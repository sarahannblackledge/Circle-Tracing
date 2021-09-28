function [rotationNumber, cycleLengths, partialLength] = timePerCycle(coordPoints, timeStamp)


%Calculate number of complete rotations
[pks, locs] = findpeaks(coordPoints(:,2));

%Remove first peak if occurs before completion of circle possible
if locs(1) < 100
    pks = pks(2:end);
    locs = locs(2:end);
end

% %Display
% figure(); plot(coordPoints(:,2)); hold on;
% scatter(locs, pks, 'b^');

%Find theta of last point
theta_last = atand(coordPoints(end,1)/coordPoints(end, 2));

%format to 360 degrees
if coordPoints(end,2) < 0
    theta_last = theta_last + 180;
end

if (coordPoints(end,2) > 0) && (coordPoints(end, 1) < 0)
    theta_last = theta_last + 360;
end

%Calculate last rotation as percentage of full rotation
rotationNumber = length(locs) + theta_last/360;


%Calculate time for each full cycle
loc_inds = [1; locs];

for i = 2:length(loc_inds)
    cycleLengths(i-1) = timeStamp(loc_inds(i)) - timeStamp(loc_inds(i-1));
end

%Calculate time required for last incomplete cycle 
partialLength = timeStamp(end) - timeStamp(loc_inds(end));



