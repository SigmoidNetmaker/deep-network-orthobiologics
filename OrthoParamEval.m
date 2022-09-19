% OrthoParamEval
% this script evaluates some learning parameters
% for ortho models

% set number of retrainings
numReTrain = 10;

% set parameters to try
% for learning rate
pTry = [0.001 0.0025 0.005 0.01 0.025 0.05 0.1 0.25 0.5 1];
% for number of iterations
% pTry = [100 250 500 1000 2500 5000 10000 25000 50000 100000 250000 500000];
% for momentum term
% pTry = [0.0001 0.00025 0.0005 0.001 0.0025 0.005 0.01 0.025 0.05 0.1 0.25 0.5];

% find number of parameters to try
numTry = length(pTry);

% define error hold vectors
ErrReTrain = zeros(1,numReTrain); 
ErrTryPara = zeros(1,numTry);

% do all retrainings for each parameter
for tryNum = 1:numTry % for each parameter
    currentTry = pTry(tryNum)
    for r = 1:numReTrain % for each retraining
        OrthoSetUp % set training parameters and randomize weights
        a = pTry(tryNum); % try different learning rates
        % nIts = pTry(tryNum); % try different numbers of iterations
        % m = pTry(tryNum); % try different momentum terms
        
        % OrthoDeltaTrain % train two layer using delta rule
        % OrthoBackOneTrain % train three layer using backprop
        % OrthoBackTwoTrain % train four layer using backprop
        % OrthoBackTenTrain % train twelve layer using backprop
        % OrthoRecurTrain % train recurrent using Pineada
        OrthoAutoTrain % train autoencoder using backprop
        
        % OrthoDeltaTest % test two layer network
        % OrthoBackOneTest % test three layer network
        % OrthoBackTwoTest % test four layer network
        % OrthoBackTenTest % test twelve layer network
        % OrthoRecurTest % test recurrent network
        OrthoAutoTest % test autoencoder using backprop
        
        ErrReTrain(r) = rmsErr; % save RMS error
        
    end % end retraining loop
    
    % find average RMS error for this parameter value
    ErrTryPara(tryNum) = mean(ErrReTrain);
    
end % end parameter try loop

% plot restuls
figure(8)
clf
stem(pTry,ErrTryPara)
axis([pTry(1)/2 pTry(end)*2 0 max(ErrTryPara)+2])
set(gca,'XScale','log')
xlabel('parameter value')
ylabel('average RMS error')
title('Learning Performance Evaluation')





