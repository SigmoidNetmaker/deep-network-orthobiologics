% OrthoSetUp.m
% this script sets up the Ortho learning environment

% set some parameters
a = 0.1; % set the learning rate
m = 0.0001; % set momentum term
b = 1; % set the bias
nIts = 50000; % set number of iterations
SGDnum = 1; % number in gradient average
count = 0; % zero counter
nHid = 10; % number of hidden units per layer
wScale = 1; % initial weight scale
nRelax = 10; % set relaxation time steps

% make some input/desired-output patterns as a debug
% (note: these are normally COMMENTED OUT)
% In = round(randn(10) * 20); 
% desOut = round(randn(10) * 20); 
% desOut(abs(desOut) < 10) = NaN;
% In = eye(10) * 20;
% desOut = eye(10) * 20;
% desOut = diag((rand(1,10)- 0.5)*100);

% set the desired output for the autoencoder
desOutA = In;

% get numbers of inputs, outputs, and patterns
[nPat nIn]  = size(In);
[nPat nOut] = size(desOut); 
[nPat nOutA] = size(desOutA);

% select the patterns on which to train
% (note: pSel = 1:nPat selects all patterns and is default)
pSel = 1:nPat;
% pSel = 2:2:nPat;
% pSel = 60:80;
% pSel = [1:62 75:nPat];
% pSel = 1:100;

% set some hold arrays
% Out = zeros(nRelax,nHid+nOut); % output hold array
% OUT = zeros(nRelax,nHid+nOut,nPat); % output hold deck
% Err = zeros(nRelax,nHid+nOut); % error hold array
% ERR = zeros(nRelax,nHid+nOut,nPat); % error hold deck
% Gra = zeros(nRelax,nHid+nOut); % gradient hold array
eRec = zeros(nIts,1); % error record array

% generate randomized connectivity matrices (normal)
W      = randn(nOut,nIn)    * wScale;
Wih    = randn(nHid,nIn+1)  * wScale;
Who    = randn(nOut,nHid+1) * wScale;
Wh1h2  = randn(nHid,nHid+1) * wScale;
Wh2h3  = randn(nHid,nHid+1) * wScale;
Wh3h4  = randn(nHid,nHid+1) * wScale;
Wh4h5  = randn(nHid,nHid+1) * wScale;
Wh5h6  = randn(nHid,nHid+1) * wScale;
Wh6h7  = randn(nHid,nHid+1) * wScale;
Wh7h8  = randn(nHid,nHid+1) * wScale;
Wh8h9  = randn(nHid,nHid+1) * wScale;
Wh9h10 = randn(nHid,nHid+1) * wScale;
Wr     = randn(nHid+nOut,nIn+1+nHid+nOut) * wScale;
Wtied  = randn(nHid,nIn);
WihA   = [Wtied  randn(nHid,1)]  * wScale;
WhoA   = [Wtied' randn(nOutA,1)] * wScale;


% % generate randomized connectivity matrices (uniform)
% W      = (rand(nOut,nIn) - 0.5)    * 2 * wScale;
% Wih    = (rand(nHid,nIn+1) - 0.5)  * 2 * wScale;
% Who    = (rand(nOut,nHid+1) - 0.5) * 2 * wScale;
% Wh1h2  = (rand(nHid,nHid+1) - 0.5) * 2 * wScale;
% Wh2h3  = (rand(nHid,nHid+1) - 0.5) * 2 * wScale;
% Wh3h4  = (rand(nHid,nHid+1) - 0.5) * 2 * wScale;
% Wh4h5  = (rand(nHid,nHid+1) - 0.5) * 2 * wScale;
% Wh5h6  = (rand(nHid,nHid+1) - 0.5) * 2 * wScale;
% Wh6h7  = (rand(nHid,nHid+1) - 0.5) * 2 * wScale;
% Wh7h8  = (rand(nHid,nHid+1) - 0.5) * 2 * wScale;
% Wh8h9  = (rand(nHid,nHid+1) - 0.5) * 2 * wScale;
% Wh9h10 = (rand(nHid,nHid+1) - 0.5) * 2 * wScale;
% Wr     = (rand(nHid+nOut,nIn+1+nHid+nOut) - 0.5) * 2 * wScale;
% Wtied  = rand(nHid,nIn);
% WihA   = ([Wtied  rand(nHid,1)]  - 0.5) * 2 * wScale;
% WhoA   = ([Wtied' rand(nOutA,1)] - 0.5) * 2 * wScale;

% zero weigth change matrices
dW      = zeros(nOut,nIn);
dWih    = zeros(nHid,nIn+1);
dWho    = zeros(nOut,nHid+1);
dWh1h2  = zeros(nHid,nHid+1);
dWh2h3  = zeros(nHid,nHid+1);
dWh3h4  = zeros(nHid,nHid+1);
dWh4h5  = zeros(nHid,nHid+1);
dWh5h6  = zeros(nHid,nHid+1);
dWh6h7  = zeros(nHid,nHid+1);
dWh7h8  = zeros(nHid,nHid+1);
dWh8h9  = zeros(nHid,nHid+1);
dWh9h10 = zeros(nHid,nHid+1);
dWr     = zeros(nHid+nOut,nIn+1+nHid+nOut);
dWihA   = zeros(nHid,nIn+1);
dWhoA   = zeros(nOutA,nHid+1);

% zero previous weigth change matrices
pdW      = zeros(nOut,nIn);
pdWih    = zeros(nHid,nIn+1);
pdWho    = zeros(nOut,nHid+1);
pdWh1h2  = zeros(nHid,nHid+1);
pdWh2h3  = zeros(nHid,nHid+1);
pdWh3h4  = zeros(nHid,nHid+1);
pdWh4h5  = zeros(nHid,nHid+1);
pdWh5h6  = zeros(nHid,nHid+1);
pdWh6h7  = zeros(nHid,nHid+1);
pdWh7h8  = zeros(nHid,nHid+1);
pdWh8h9  = zeros(nHid,nHid+1);
pdWh9h10 = zeros(nHid,nHid+1);
pdWr     = zeros(nHid+nOut,nIn+1+nHid+nOut);
pdWihA   = zeros(nHid,nIn+1);
pdWhoA   = zeros(nOutA,nHid+1);

% zero activation derivative vector
dAct = zeros(nHid+nOut,1); 

% set a mask for Wr to remove output feedback connections
Mr = [ones(nHid+nOut,nIn+1+nHid) zeros(nHid+nOut,nOut)];
% Mr(nHid+1:end,1:nIn) = 0; % mask out in-out weights
% now mask out the output feedback connection weights
Wr = Wr .* Mr;

% make temporal output array for plotting
DESOUT = zeros(nRelax,nOut,nPat);
for p = 1:nPat
    DESOUT(:,:,p) = meshgrid(desOut(p,:),zeros(1,nRelax));
end






