% OrthoRecurtrain.m
% this script uses Pineda's algorithm to train a 
% recurrent ortho model; activation functions are 
% sigmoidal for hidden units and linear
% for output units

% start clock
% tic

% train network
for c = 1:nIts % for every training iteration
    p = datasample(pSel,1); % choose pattern pair at random
    d = desOut(p,:)'; % set desired output col vec to chosen output
    % (note: d will have NaNs from the NaNs in desOut)

    % relax network forward for pattern p
    y = ones(nHid+nOut,1)*0.5; % set initial state col vec
    % y = zeros(nHid+nOut,1); % set initial y value
    z = [In(p,:)'; b; y]; % set initial state col vec
    for t = 2:nRelax % for each relaxation step
        q = Wr * z; % compute weighted input sum to outs, hids
        y(1:nHid) = 1 ./ (1+exp(-q(1:nHid))); % squash hid weighted sum
        y(nHid+1:end) = q(nHid+1:end); % just take out as weigthed sum
        % y = 1 ./ (1+exp(-q)); % squash all hid and out as debug
        z = [In(p,:)'; b; y]; % reset state
    end % end t loop    
    % find the error
    e = zeros(nHid+nOut,1); % zero the error vector
    e(nHid+1:end) = d - y(nHid+1:end); % find error col vec (has NaNs)
    eRec(c) = rms(e(~isnan(e))); % record error
    e(isnan(e)) = 0; % change all NaNs in e to zeros
    
    % compute derivative of activation function for each unit
    dAct(1:nHid)     = y(1:nHid) .* (1-y(1:nHid)); % for hid, sigmoidal
    dAct(nHid+1:end) = 1; % for out, linear
    % dAct = y .* (1-y); % for all hid and out sigmoidal
    
    % set initial values for reverse relaxation
    g = zeros(nHid+nOut,1); % set initial g value
    % Gra(1,:) = g; % set first gradient values
    
    % get transpose of recurrent weight submatrix
    % Vr = Wr(:,nIn+1:nIn+nHid+nOut)';
    Vr = Wr(:,nIn+2:end)';

    % relax network backward for pattern r
    for t = 2:nRelax % for each relaxation step
        g = Vr * (dAct.*g) + e;
        % Gra(t,:) = g; % store gradient g
    end % end t loop
    
    % compute weight update matrix
    DACT = ndgrid(dAct,zeros(1,nIn+1+nHid+nOut)); % grid of act derivs
    dWr = DACT .* (g * z'); % compute raw weight changes
    dWr = dWr .* Mr; % remove output feedback weights using mask
    pdWr = dWr; % update previous weight changes
    
    % update weights
    Wr = Wr + a*dWr + m*pdWr;
    
end % end c loop

% stop the clock
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

