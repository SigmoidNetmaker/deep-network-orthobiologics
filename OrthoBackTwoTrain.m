% OrthoBackTwoTrain.m
% this script trains 4-layered ortho models using 
% backpropagation; the 2 hidden layers are signoidal;
% the input and output layers are linear
% (note: In and desOut must be available in the workspace)

for c = 1:nIts % for each learning iteration
    pIndx = datasample(pSel,1); % choose pattern pair at random
    d = desOut(pIndx,:)'; % set desired output col vec to chosen output
    % (note: d will have NaNs from the NaNs in desOut)
    
    % do one pass of forward prop to find act out and all hids
    x = [In(pIndx,:) b]'; % set input col vec and append bias
    q = Wih * x; % compute hid1 net input col vec
    s = 1./(1+exp(-q)); % squash hid1 net input col vec
    y1 = [s; b]; % append bias to hid1 col vec
    q = Wh1h2 * y1; % compute hid2 net input col vec
    s = 1./(1+exp(-q)); % squash hid2 net input col vec
    y2 = [s; b]; % append bias to hid2 col vec
    z = Who * y2; % compute actual output col vec
    
    % find the error
    e = d - z; % find the error column vector (has NaNs)
    eRec(c) =  rms(e(~isnan(e))); % record error
    e(isnan(e)) = 0; % change all NaNs in e to zeros
    
    % do one pass of back prop to find error signals
    % (note: x, z, d, e, and all y's are col vecs here)
    zg = e; % compute output error signal (just e for linear outputs)
    yg2 = (y2 .* (1-y2)) .* (zg'          * Who)';   % compute y2 err sig
    yg1 = (y1 .* (1-y1)) .* (yg2(1:nHid)' * Wh1h2)'; % compute y1 err sig

    % save previous weight update matrices
    pdWho   = dWho; % save hid-out change weights
    pdWh1h2 = dWh1h2; % save h1-h2 change weights
    pdWih   = dWih; % save in-hid change weights
    
    % compute weight update matrices
    dWho   = zg          * y2'; % compute hid2-out weight change
    dWh1h2 = yg2(1:nHid) * y1'; % compute hid1-hid2 weight change
    dWih   = yg1(1:nHid) * x';  % compute change in in-hid1 weights

    % now update the weight matrices
    Who   = Who   + a*dWho   + m*pdWho; % update hidden-output weights
    Wh1h2 = Wh1h2 + a*dWh1h2 + m*pdWh1h2; % update hid1-hid2 weights 
    Wih   = Wih   + a*dWih   + m*pdWih;   % update input-hidden weights
    
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


