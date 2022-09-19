% OrthoDeltaTest.m
% this script tests 2-layered ortho models trained using 
% the delta rule
% (note: In and desOut must be available in the workspace)

% zero hold arrays 
Out = zeros(nPat,nOut); % output hold array
Err = zeros(nPat,nOut); % error hold array
err = []; % error holder (1-D) set to empty

% find actual and desired ouptuts and error for all patterns
for p = pSel
    % set the input column vector
    x = In(p,:)';
    % compute the actual output column vector
    y = W * x;
    % store the actual output as row vector
    Out(p,:) = y';
    % compute the error row vector (with NaNs)
    e = desOut(p,:) - y';
    % store error row vector (with NaNs)
    Err(p,:) = e;
    % find the indices for desired outputs
    desOutIndx = find(~isnan(desOut(p,:)));
    % concatenate error vector to error holder without NaNs
    err = [err e(desOutIndx)];
end
    
% compute total rms error over all patterns
rmsErr = rms(err);

% comment in this return if run from loop
return

% show rms error
rmsErr

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
image(In)
xlabel('in num')
ylabel('pattern number')
title('Input')
subplot(1,4,2)
image(desOutPlot)
xlabel('out num')
title('Des Out')
subplot(1,4,3)
image(actOutPlot)
xlabel('out num')
title('Act Out')
subplot(1,4,4)
image(ErrPlot)
% colorbar
xlabel('out num')
title('Error')














