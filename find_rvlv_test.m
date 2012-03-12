function [ RV, LV ] = find_rvlv_test( mrData )
%FIND_RVLV Summary of this function goes here
%   Detailed explanation goes here
%   author: Konrad Werys konradwerys@gmail.com

[nX, nY, ~, nTime] = size(mrData);
smoothedMrData = zeros([nX, nY, 1, nTime]);

h = fspecial('gaussian',[nX, nY], 1);
for iTime=1:nTime
    smoothedMrData(:,:,1,iTime) = filter2(h,mrData (:,:,1,iTime));
end

% image of maximal values of whole series
myMax = squeeze(max(smoothedMrData,[],4));
% time integral images
mySum = squeeze(sum(smoothedMrData,4));

% temporal differential
myDiff = (diff(smoothedMrData,1,4));
% sum of temporal differential
myDiffSum = sum(abs(myDiff),4);
% smoothing
myDiffSumSmoothed = filter2(fspecial('gaussian',size(myDiffSum), 4),myDiffSum);
% spatial gradient
[grad1,grad2]=gradient(myDiffSumSmoothed);
myGrad=sqrt(grad1+grad2);
%myGrad=sqrt(grad1.^2+grad2.^2);

[r,c]=find(myGrad==max(myGrad(:)));
LV(1)=c;LV(2)=r;
[r,c]=find(myGrad==min(myGrad(:)));
RV(1)=c;RV(2)=r;

% subplot(1,3,1),imshow(myMax,[]),hold on,
% plot(RV(2), RV(1),'o');
% plot(LV(2), LV(1),'or');
% subplot(1,3,2),imshow(mySum,[]),hold on,
% plot(RV(2), RV(1),'o');
% plot(LV(2), LV(1),'or');
% subplot(1,3,3),imshow(mrData(:,:,1,1),[]),hold on,
% plot(RV(2), RV(1),'o');
% plot(LV(2), LV(1),'or');

end

