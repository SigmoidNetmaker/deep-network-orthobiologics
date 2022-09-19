% OrthoBackTenTrain.m
% this script trains 12-layered ortho models using 
% backpropagation; the 10 hidden layers are signoidal;
% the input and output layers are linear
% (note: In and desOut must be available in the workspace)

% set timer
% tic

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
    q = Wh2h3 * y2; % compute hid3 net input col vec
    s = 1./(1+exp(-q)); % squash hid3 net input col vec
    y3 = [s; b]; % append bias to hid3 col vec
    q = Wh3h4 * y3; % compute hid4 net input col vec
    s = 1./(1+exp(-q)); % squash hid4 net input col vec
    y4 = [s; b]; % append bias to hid4 col vec
    q = Wh4h5 * y4; % compute hid5 net input col vec
    s = 1./(1+exp(-q)); % squash hid5 net input col vec
    y5 = [s; b]; % append bias to hid5 col vec
    q = Wh5h6 * y5; % compute hid6 net input col vec
    s = 1./(1+exp(-q)); % squash hid6 net input col vec
    y6 = [s; b]; % append bias to hid6 col vec
    q = Wh6h7 * y6; % compute hid7 net input col vec
    s = 1./(1+exp(-q)); % squash hid7 net input col vec
    y7 = [s; b]; % append bias to hid7 col vec
    q = Wh7h8 * y7; % compute hid8 net input col vec
    s = 1./(1+exp(-q)); % squash hid8 net input col vec
    y8 = [s; b]; % append bias to hid8 col vec
    q = Wh8h9 * y8; % compute hid9 net input col vec
    s = 1./(1+exp(-q)); % squash hid9 net input col vec
    y9 = [s; b]; % append bias to hid9 col vec
    q = Wh9h10 * y9; % compute hid10 net input col vec
    s = 1./(1+exp(-q)); % squash hid10 net input col vec
    y10 = [s; b]; % append bias to hid10 col vec
    z = Who * y10; % compute actual output col vec
    
    % find the error
    e = d - z; % find the error column vector (has NaNs)
    eRec(c) =  rms(e(~isnan(e))); % record error
    e(isnan(e)) = 0; % change all NaNs in e to zeros
    
    % do one pass of back prop to find error signals
    % (note: x, z, d, e, and all y's are col vecs here)
    zg = e; % compute output error signal (just e for linear outputs)
    yg10 = (y10 .* (1-y10)) .* (zg' * Who)';  % compute y10 error signal
    yg9 = (y9 .* (1-y9)) .* (yg10(1:nHid)' * Wh9h10)'; % compute y9 err sig
    yg8 = (y8 .* (1-y8)) .* (yg9(1:nHid)'  * Wh8h9)'; % compute y8 err sig
    yg7 = (y7 .* (1-y7)) .* (yg8(1:nHid)'  * Wh7h8)'; % compute y7 err sig
    yg6 = (y6 .* (1-y6)) .* (yg7(1:nHid)'  * Wh6h7)'; % compute y6 err sig
    yg5 = (y5 .* (1-y5)) .* (yg6(1:nHid)'  * Wh5h6)'; % compute y5 err sig
    yg4 = (y4 .* (1-y4)) .* (yg5(1:nHid)'  * Wh4h5)'; % compute y4 err sig
    yg3 = (y3 .* (1-y3)) .* (yg4(1:nHid)'  * Wh3h4)'; % compute y3 err sig
    yg2 = (y2 .* (1-y2)) .* (yg3(1:nHid)'  * Wh2h3)'; % compute y2 err sig
    yg1 = (y1 .* (1-y1)) .* (yg2(1:nHid)'  * Wh1h2)'; % compute y1 err sig

    % save previous weight update matrices
    pdWho    = dWho; % save previous hid10-out weight change
    pdWh9h10 = dWh9h10; % save previous hid9-hid10 weight change
    pdWh8h9  = dWh8h9; % save previous hid8-hid9 weight change
    pdWh7h8  = dWh7h8; % save previous hid7-hid8 weight change
    pdWh6h7  = dWh6h7; % save previous hid6-hid7 weight change
    pdWh5h6  = dWh5h6; % save previous hid5-hid6 weight change
    pdWh4h5  = dWh4h5; % save previous hid4-hid5 weight change
    pdWh3h4  = dWh3h4; % save previous hid3-hid4 weight change
    pdWh2h3  = dWh2h3; % save previous hid2-hid3 weight change
    pdWh1h2  = dWh1h2; % save previous hid1-hid2 weight change
    pdWih    = dWih;  % save previous change in in-hid1 weights
    
    % compute weight update matrices
    dWho    = zg           * y10'; % compute hid10-out weight change
    dWh9h10 = yg10(1:nHid) * y9'; % compute hid9-hid10 weight change
    dWh8h9  = yg9(1:nHid)  * y8'; % compute hid8-hid9 weight change
    dWh7h8  = yg8(1:nHid)  * y7'; % compute hid7-hid8 weight change
    dWh6h7  = yg7(1:nHid)  * y6'; % compute hid6-hid7 weight change
    dWh5h6  = yg6(1:nHid)  * y5'; % compute hid5-hid6 weight change
    dWh4h5  = yg5(1:nHid)  * y4'; % compute hid4-hid5 weight change
    dWh3h4  = yg4(1:nHid)  * y3'; % compute hid3-hid4 weight change
    dWh2h3  = yg3(1:nHid)  * y2'; % compute hid2-hid3 weight change
    dWh1h2  = yg2(1:nHid)  * y1'; % compute hid1-hid2 weight change
    dWih    = yg1(1:nHid)  * x';  % compute change in in-hid1 weights
    
    % now update the weight matrices
    Who    = Who    + a*dWho    + m*pdWho; % update hidden-output weights
    Wh9h10 = Wh9h10 + a*dWh9h10 + m*pdWh9h10; % update hid9-hid10 weights 
    Wh8h9  = Wh8h9  + a*dWh8h9  + m*pdWh8h9; % update hid8-hid9 weights 
    Wh7h8  = Wh7h8  + a*dWh7h8  + m*pdWh7h8; % update hid7-hid8 weights 
    Wh6h7  = Wh6h7  + a*dWh6h7  + m*pdWh6h7; % update hid6-hid7 weights 
    Wh5h6  = Wh5h6  + a*dWh5h6  + m*pdWh5h6; % update hid5-hid6 weights 
    Wh4h5  = Wh4h5  + a*dWh4h5  + m*pdWh4h5; % update hid4-hid5 weights 
    Wh3h4  = Wh3h4  + a*dWh3h4  + m*pdWh3h4; % update hid3-hid4 weights 
    Wh2h3  = Wh2h3  + a*dWh2h3  + m*pdWh2h3; % update hid2-hid3 weights 
    Wh1h2  = Wh1h2  + a*dWh1h2  + m*pdWh1h2; % update hid1-hid2 weights 
    Wih    = Wih    + a*dWih    + m*pdWih;   % update input-hidden weights
    
end

% show elapsed time
% toc

% comment in this return if run from loop
return

% show error record
figure(4)
clf
plot(eRec)
xlabel('training cycles')
ylabel('rms error')
title('RMS Error vs Training Cycles')

