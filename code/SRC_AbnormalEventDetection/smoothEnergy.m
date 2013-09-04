function [ smoothEnergy ] = smoothEnergy( energy )
%SMOOTHENERGY Summary of this function goes here
%   Detailed explanation goes here
smoothEnergy = energy;
len = size(energy, 1);
threshold = 100;
average = mean(energy);
for i=2:len-1
    if energy(i) > energy(i-1)*threshold && energy(i) > energy(i+1)*threshold
        smoothEnergy(i) = average;
    end
end

end

