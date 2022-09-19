% OrthoBatchTrain
% this script trains a bunch of ortho models and
% finds their average generalizatin error

% set number of retrainings
numReTrain = 10;

% set number of patterns in test set
% (note: the rest are in the training set)
nTestPat = 50;

% compute number of patterns in train set
nTrainPat = nPat - nTestPat;

% define generalization error hold vector
GenErr = zeros(1,nTestPat);

% do all of the retrainings
for r = 1:numReTrain
    permPat = randperm(nPat); % randomly permute pattern numbers
    pTrain  = permPat(1:nTrainPat); % grab train pattern numbers
    pTest   = permPat(nTrainPat:end); % grab test pattern numbers
    
    OrthoSetUp % set training parameters and randomize weights
    
    pSel = pTrain; % set patterns to training patterns
    % OrthoDeltaTrain % train two layer using delta rule
    % OrthoBackOneTrain % train three layer using backprop
    % OrthoBackTwoTrain % train four layer using backprop
    % OrthoBackTenTrain % train twelve layer using backprop
    % OrthoRecurTrain % train recurrent using Pineada
    OrthoAutoTrain % train autoencoder using backprop
    
    pSel = pTest; % set patterns to testng patterns
    % OrthoDeltaTest % test two layer network
    % OrthoBackOneTest % test three layer network
    % OrthoBackTwoTest % test four layer network
    % OrthoBackTenTest % test twelve layer network
    % OrthoRecurTest % test recurrent network
    OrthoAutoTest % test autoencoder network
    
    GenErr(r) = rmsErr; % save RMS error over test set
    
end % end retraining loop

% find average generalization error
meanGenErr = mean(GenErr)


    
    