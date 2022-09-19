% OrthoAutoTrain.m
% this script trains autoencoders using 
% backpropagation; the single hidden layer is signoidal;
% the input and output layers are linear
% (note: In and desOutAuto must be available in the workspace)

% Questions: How to use bias? How to know nHid?

for c = 1:nIts % for each learning iteration
    pIndx = datasample(pSel,1); % choose pattern pair at random
    d = desOutA(pIndx,:)'; % set desired output col vec to chosen output
    % do one pass of forward prop to find actual output and error
    x = [In(pIndx,:) b]'; % set input col vector to chosen input pattern
    q = WihA * x; % compute the hidden unit net input column vector
    s = 1./(1+exp(-q)); % squash the hidden net input column vector
    y = [s; b]; % append the bias to the hidden unit column vector
    z = WhoA * y; % compute the actual output column vector
    e = d - z; % find the error column vector (has NaNs)
    eRec(c) =  rms(e); % record error
    % do one pass of back prop to find error signals
    % (note: x, y, d, and e are all column vectors here)
    zg = e; % compute output error signal (just e for linear outputs)
    yg = (y .* (1-y)) .* (zg' * WhoA)'; % compute hidden error signal
    % compute weight update matrices
    fWhoA = zg * y'; % fraction of the common weight change
    fWihA = yg(1:nHid) * x'; % fraction of the common weight change
    dWtied = fWhoA(:,1:nHid) + fWihA(:,1:nIn)';
    dWhoA = dWhoA + [dWtied  fWhoA(:,end)]; % get dWhoA
    dWihA = dWihA + [dWtied' fWihA(:,end)]; % get dWihA
    count = count + 1; % increment counter
    if count == SGDnum
        % compute average weight updates
        dWhoA = dWhoA / count;
        dWihA = dWihA / count;
        % now update the weight matrices
        WhoA = WhoA + [(a/2)*dWhoA(:,1:nHid) a*dWhoA(:,end)]; % update 
        WihA = WihA + [(a/2)*dWihA(:,1:nIn)  a*dWihA(:,end)]; % update 
        % zero weight change matrices and counter
        dWhoA = zeros(nOutA, nHid+1); 
        dWihA = zeros(nHid, nIn+1);
        count = 0;
    end
end

% comment in this return if run from loop
return

% are the tied weights equal?
tiedWeightsEqual = isequal(WhoA(:,1:nHid),WihA(:,1:nIn)')

% show error record
figure(4)
clf
plot(eRec)
xlabel('training cycles')
ylabel('rms error')
title('RMS Error vs Training Cycles')

