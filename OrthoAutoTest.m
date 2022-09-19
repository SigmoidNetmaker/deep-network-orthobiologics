% OrthoAutoTest
% this script tests autoencoders trained using 
% backpropagation; the single hidden layer is signoidal;
% the input and output layers are linear
% (note: In and desOutAuto must be available in the workspace)

% zero hold arrays 
Out = zeros(nPat,nOutA); % output hold array
Err = zeros(nPat,nOutA); % error hold array
err = []; % error holder (1-D) set to empty

% find actual and desired ouptuts and error for all patterns
for p = pSel
    % set the input column vector and append the bias
    x = [In(p,:) b]';
    % compute the hidden net input column vector
    q = WihA * x;
    % squash the hidden net input column vector
    s = 1./(1+exp(-q)); 
    % append the bias to the hidden unit column vector
    y = [s; b]; 
    % compute the actual output column vector
    z = WhoA * y; 
    % store the actual output as row vector
    Out(p,:) = z';
    % compute the error row vector
    e = desOutA(p,:) - z';
    % store error row vector
    Err(p,:) = e;
    % concatenate error vector to error holder
    err = [err e];
end

% compute total rms error over all patterns
rmsErr = rms(err);

% comment-in this return for using his script in a loop
return

% show rms error
rmsErr

% for plotting, set all NaNs to zeros
actOutPlot = Out;
desOutPlot = desOutA;
ErrPlot = Err;

% show the desire and actual outputs and the error
figure(2)
clf
subplot(1,4,1)
imagesc(In)
xlabel('in num')
ylabel('pattern number')
title('Input')
subplot(1,4,2)
imagesc(desOutPlot)
xlabel('out num')
title('Des Out')
subplot(1,4,3)
imagesc(actOutPlot)
xlabel('out num')
title('Act Out')
subplot(1,4,4)
imagesc(ErrPlot)
% colorbar
xlabel('out num')
title('Error')

