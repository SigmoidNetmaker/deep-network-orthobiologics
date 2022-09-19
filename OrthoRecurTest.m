% OrthoRecurTest.m
% this script tests recurrent ortho models; activation
% functions are sigmoidal for hidden units and linear
% for output units

% set some hold arrays
% Out = zeros(nRelax,nOut); % output hold array
OUT = zeros(nRelax,nOut,nPat); % output hold deck
Err = zeros(nPat,nOut); % error hold array
% ERR = zeros(nRelax,nOut,nPat); % error hold deck
err = []; % error holder set to empty

% relax network for all patterns
for p = pSel % pSel is a vector of pattern numbers 
    y = ones(nHid+nOut,1)*0.5; % set initial state col vec
    OUT(1,:,p) = y(nHid+1:end)'; % hold first output state as row
    z = [In(p,:)'; b; y]; % set initial state col vec
    for t = 2:nRelax % for each relaxation step
        q = Wr * z; % compute weighted input sum to outs, hids
        y(1:nHid) = 1 ./ (1+exp(-q(1:nHid))); % squash hid weighted sum
        y(nHid+1:end) = q(nHid+1:end); % just take out as weigthed sum
        % y = 1 ./ (1+exp(-q)); % squash all hid and out weighted sums
        OUT(t,:,p) = y(nHid+1:end)'; % store y output
        z = [In(p,:)'; b; y]; % reset state
    end % end t loop    
    % find the indices for desired outputs
    desOutIndx = find(~isnan(desOut(p,:)));
    err = [err [desOut(p,desOutIndx) - y(nHid+desOutIndx)']]; % find errs
    Err(p,:) = desOut(p,:) - y(nHid+1:end)'; % has NaNs
end % end p loop

% compute rms error
rmsErr = rms(err);

% comment-in this return for mgRNNtest in a loop
return

% show rms error
rmsErr

% get the steady-state outputs and make Out
Out = squeeze(OUT(nRelax,:,:))';

% for plotting, set all NaNs to zeros
actOutPlot = Out;
desOutPlot = desOut;
ErrPlot = Err;
actOutPlot(isnan(desOutPlot)) = 0;
desOutPlot(isnan(desOutPlot)) = 0;
ErrPlot(isnan(ErrPlot)) = 0;

% show the desire and actual outputs and the error
figure(2)
clf
subplot(1,4,1)
image(In(pSel,:))
xlabel('in num')
ylabel('pattern number')
title('Input')
subplot(1,4,2)
image(desOutPlot(pSel,:))
xlabel('out num')
title('Des Out')
subplot(1,4,3)
image(actOutPlot(pSel,:))
xlabel('out num')
title('Act Out')
subplot(1,4,4)
image(ErrPlot(pSel,:))
% colorbar
xlabel('out num')
title('Error')

% set a time vector
tVec = 1:nRelax;

% show temporal results (outputs only)
figure(3)
clf
% plot actual and desired response for each output
for i=1:nOut
subplot(4,7,i)
% plot(tVec,squeeze(OUT(:,i,find(~isnan(desOut(:,i))))),...
%     tVec,squeeze(DESOUT(:,i,find(~isnan(desOut(:,i))))),'--')
plot(tVec,squeeze(OUT(:,i,pSel)),...
    tVec,squeeze(DESOUT(:,i,pSel)),'--')
% axis([0 nRelax -0.1 1.1])
end
% label some y axes
subplot(4,7,1)
ylabel('output res')
subplot(4,7,8)
ylabel('output res')
subplot(4,7,15)
ylabel('output res')
subplot(4,7,22)
ylabel('output res')
% label some x axes
subplot(4,7,22)
xlabel('time steps')
subplot(4,7,23)
xlabel('time steps')
subplot(4,7,24)
xlabel('time steps')
subplot(4,7,25)
xlabel('time steps')
subplot(4,7,26)
xlabel('time steps')
subplot(4,7,27)
xlabel('time steps')
subplot(4,7,28)
xlabel('time steps')


