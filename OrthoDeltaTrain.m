% OrthoDeltTrain.m
% this script trains a 2-layered network of linear units
% using the delta rule 

for c = 1:nIts % for each learning iteration
   pIndx = datasample(pSel,1); % choose pattern pair at random
   d = desOut(pIndx,:)'; % set desired output d to chosen output
   % (note: d will have NaNs from the NaNs in desOut)
   x = In(pIndx,:)'; % set input x to chosen input pattern
   y = W * x; % find the output for the chosen input pattern
   e = d - y; % find the error e for the chosen input (has NaNs)
   eRec(c) =  rms(e(~isnan(e))); % record error
   e(isnan(e)) = 0; % change all NaNs in e to zeros
   % (note: x, y, d, and e are all column vectors here)
   pdW = dW; % save previous weight changes
   dW = e * x'; % compute delta rule weight update
   % (note: e * x' is an outer product so dW is a matrix)
   W = W + a*dW + m*pdW;  % apply the weight update
end % end learning loop

% comment in this return if run from loop
% return

% show error record
figure(4)
clf
plot(eRec)
xlabel('training cycles')
ylabel('rms error')
title('RMS Error vs Training Cycles')

