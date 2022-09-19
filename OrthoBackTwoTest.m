% OrthoBackTwoTrain
% this script tests 4-layered ortho models trained using 
% backpropagation; the 2 hidden layer are signoidal;
% the input and output layers are linear
% (note: In and desOut must be available in the workspace)

% zero hold arrays 
Out = zeros(nPat,nOut); % output hold array
Err = zeros(nPat,nOut); % error hold array
err = []; % error holder (1-D) set to empty

% find actual and desired ouptuts and error for all patterns
for p = pSel % pSel is a vector of pattern numbers 
    x = [In(p,:) b]'; % set input col vec and append bias
    q = Wih * x; % compute hid1 net input col vec
    s = 1./(1+exp(-q)); % squash hid1 net input col vec
    y1 = [s; b]; % append bias to hid1 col vec
    q = Wh1h2 * y1; % compute hid2 net input col vec
    s = 1./(1+exp(-q)); % squash hid2 net input col vec
    y2 = [s; b]; % append bias to hid2 col vec
    z = Who * y2; % compute actual output col vec
    Out(p,:) = z'; % store actual output as row vec
    e = desOut(p,:) - z'; % compute error row vec (with NaNs)
    Err(p,:) = e; % store error row vec (with NaNs)
    desOutIndx = find(~isnan(desOut(p,:))); % find desOut indices 
    err = [err e(desOutIndx)]; % concat err vec to err hold, no NaNs
 end

% compute total rms error over all patterns
rmsErr = rms(err);

% comment-in this return for using his script in a loop
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

