% Copyright 2018 The MathWorks, Inc.

load('offlineSlamData.mat');

mapResolotion = 20;
maxLidarRange = 8;
lidarSlam = robotics.LidarSLAM(mapResolotion, maxLidarRange);

lidarSlam.LoopClosureThreshold = 205;
lidarSlam.LoopClosureSearchRadius = 8;
%%
for i=1:10
    [isScanAccepted, loopClosureInfo, optimizationInfo] = addScan(lidarSlam, scans{i});
    if isScanAccepted
        fprintf('Added scan %d \n',i);
    end
end

ax = newplot;
show(lidarSlam, 'Parent', ax);
title(ax, {'Map of the Environment','Pose Graph for Intial 10 Scans'});

firstTimeLCDetected = false;

ax = newplot;

for i=10:length(scans)
    [isScanAccepted, loopClosureInfo, optimizationInfo] = addScan(lidarSlam, scans{i});
    if ~isScanAccepted
        continue;
    end
    % visualize the first detected loop closure, if you want to see the
    % complete map building process, remove the if condition below
    if optimizationInfo.IsPerformed && ~firstTimeLCDetected
        show(lidarSlam, 'Poses', 'off', 'Parent', ax); hold on;
        lidarSlam.PoseGraph.show('Parent', ax);
        firstTimeLCDetected = true;
        drawnow
    end
end
title(ax, 'First loop closure');

figure
ax = newplot;
show(lidarSlam, 'Parent', ax);
title(ax, {'Final Built Map of the Environment', 'Trajectory of the Robot'});