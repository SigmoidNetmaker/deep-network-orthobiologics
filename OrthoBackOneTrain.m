% OrthoBackOneTrain.m
% this script trains 3-layered ortho models using 
% backpropagation; the single hidden layer is signoidal;
% the input and output layers are linear
% (note: In and desOut must be available in the workspace)

for c = 1:nIts % for each learning iteration
    pIndx = datasample(pSel,1); % choose pattern pair at random
    d = desOut(pIndx,:)'; % set desired output col vec to chosen output
    % (note: d will have NaNs from the NaNs in desOut)
    % do one pass of forward prop to find actual output and error
    x = [In(pIndx,:) b]'; % set input col vector to chosen input pattern
    q = Wih * x; % compute the hidden unit net input column vector
    s = 1./(1+exp(-q)); % squash the hidden net input column vector
    y = [s; b]; % append the bias to the hidden unit column vector
    z = Who * y; % compute the actual output column vector
    e = d - z; % find the error column vector (has NaNs)
    eRec(c) =  rms(e(~isnan(e))); % record error
    e(isnan(e)) = 0; % change all NaNs in e to zeros
    % do one pass of back prop to find error signals
    % (note: x, y, d, and e are all column vectors here)
    zg = e; % compute output error signal (just e for linear outputs)
    yg = (y .* (1-y)) .* (zg' * Who)'; % compute hidden error signal
    % save previous weight update matrices
    pdWho = dWho; % save previous hid-out changes
    pdWih = dWih; % save previous in-hid changes
    % compute weight update matrices
    dWho = zg * y';  % compute the change in hidden-output weights
    dWih = yg(1:nHid) * x'; % compute change in input-hidden weights
    % now update the weight matrices
    Who = Who + a*dWho + m*pdWho; % update hidden-output weights
    Wih = Wih + a*dWih + m*pdWih; % update input-hidden weights
end

% comment in this return if run from loop
return

% show error record
figure(4)
clf
plot(eRec)
xlabel('training cycles')
ylabel('rms error')
title('RMS Error vs Training Cycles')

