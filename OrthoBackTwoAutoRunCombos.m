% OrthoBackTwoAutoRunCombos
% this script finds the outputs predicted from the
% the back-two network with autoencoder first stage
% for all of the inputs in the combinaiton screen;
% the predictions are the average over the outputs
% of ten networks, each with its own unique set of
% connectivity matrices as read in from a MAT file;
% OrthoMakeCombos must be run first

% load matrices
% (note: these matrices are: WihAn, Wuhn, Wh1h2_n, and Whon,
%  where n is an integer from 1 to 10)
load('Orthoweights_Auto')

% zero output hold array
nOut   = 26; b = 1; % a few needed parameters
Out    = zeros(numCombos,nOut); % output array
OutSum = zeros(numCombos,nOut); % output sum array

% set a timer
tic

% set up each of the ten networks
for n = 1:10
    if n == 1
        WihA = WihA1; Wuh = Wuh1; Wh1h2 = Wh1h2_1; Who = Who1;
    elseif n == 2
        WihA = WihA2; Wuh = Wuh2; Wh1h2 = Wh1h2_2; Who = Who2;
    elseif n == 3
        WihA = WihA3; Wuh = Wuh3; Wh1h2 = Wh1h2_3; Who = Who3;
    elseif n == 4
        WihA = WihA4; Wuh = Wuh4; Wh1h2 = Wh1h2_4; Who = Who4;
    elseif n == 5
        WihA = WihA5; Wuh = Wuh5; Wh1h2 = Wh1h2_5; Who = Who5;
    elseif n == 6
        WihA = WihA6; Wuh = Wuh6; Wh1h2 = Wh1h2_6; Who = Who6;
    elseif n == 7
        WihA = WihA7; Wuh = Wuh7; Wh1h2 = Wh1h2_7; Who = Who7;
    elseif n == 8
        WihA = WihA8; Wuh = Wuh8; Wh1h2 = Wh1h2_8; Who = Who8;
    elseif n == 9
        WihA = WihA9; Wuh = Wuh9; Wh1h2 = Wh1h2_9; Who = Who9;
    elseif n == 10
        WihA = WihA10; Wuh = Wuh10; Wh1h2 = Wh1h2_10; Who = Who10;
    end
    
    % find actual ouptutsfor all combinations
    for c = 1:numCombos % for all combination inputs
        x = [InCombos(c,:) b]'; % set input col vec and append bias
        q = WihA * x; % compute autoencoder representation using WihA
        s = 1./(1+exp(-q)); % squash hidden (hid1) net input col vec
        u = [s; b]; % append bias to autoencoder representation
        q = Wuh * u; % compute the hidden net input column vector
        s = 1./(1+exp(-q)); % squash the hidden net input column vector
        y1 = [s; b]; % append bias to hid1 col vec
        q = Wh1h2 * y1; % compute hid2 net input col vec
        s = 1./(1+exp(-q)); % squash hid2 net input col vec
        y2 = [s; b]; % append bias to hid2 col vec
        z = Who * y2; % compute actual output col vec
        Out(c,:) = z'; % store actual output as row vec
    end % end combination loop
    
    OutSum = OutSum + Out; % sum the outputs
    
end % end network loop

% compute the average output
OutAvg = OutSum / 10;

% compute efficacy scores
% based on 17 of the 26 outputs
% (note: leave out PS and the rest)
% here is the output scaling table:
% DR	higher is better	1	as is
% BF3	higher is better	2	as is
% BF6	higher is better	3	as is
% MV/TV	higher is better	4	as is
% PLF FRhigher is better	5	as is
% ODI	higher is better	6	as is
% FR	higher is better	7	as is
% FH	higher is better	8	as is
% TWB/CHlower is better!!	9	invert
% TRU	lower is better!!	10	invert
% OW	higher is better	11	as is
% PS	not included    	12	leave out
% RBG	lower is better!!	13	invert
% NH	lower is better!!	14	invert
% DY	lower is better!!	15	invert
% RO	higher is better	16	as is
% HO	higher is better	17	as is
% IS	higher is better	18	as is
% the rest		            19+	leave out
effiArr = zeros(numCombos,17); % define efficacy array
effiArr = OutAvg(:,[1:11 13:18]); % leave out PS column
% effiHld = effiArr; % hold unprocessed effiArr as a check
for col = 1:17 % for all cols of effiArr (just 17 of 26 outputs)
    if col == 9 || col == 10 || col == 12 || col == 13 || col == 14
        effiArr(:,col) = max(effiArr(:,col)) - effiArr(:,col); % invert
    else
        effiArr(:,col) = effiArr(:,col) - min(effiArr(:,col)); % shift
    end
    effiArr(:,col) = effiArr(:,col) / max(effiArr(:,col)); % normalize
end % end col loop

% compute efficacy score as average over rows of effiArr
effiScore = mean(effiArr');
[effiSort effiRank] = sort(effiScore);

% swap some columns in orthoCombos so that they make more sense medically
orthoCombos = orthoCombos(:,[8,1:7,9]); % BMP2 moved first
% rank, normalize, and grap top ortho combos
orthoRanked = orthoCombos(flip(effiRank),:);
for col = 1:9
    orthoRankNorm(:,col) = orthoRanked(:,col) / max(orthoRanked(:,col));
end
orthoTop200 = orthoRankNorm(1:200,:);
orthoTop20  = orthoRankNorm(1:20,:);

% find collelations between top ortho combinations
[rTop200,pTop200] = corr(orthoTop200);
[rTop20,pTop20]   = corr(orthoTop20);

% show elapsed time
toc

% show InCombos, OutAvg, and effiArr as images
figure(2)
clf
subplot(1,3,1)
imagesc(InCombos)
xlabel('input number')
ylabel('combination number')
title('Combination Input')
subplot(1,3,2)
imagesc(OutAvg)
xlabel('output number')
title('Average Output')
subplot(1,3,3)
imagesc(effiArr)
xlabel('selected output number')
title('Inverted (some) and Normalized Selected Outputs')

% show ranked ortho factor combos as images
% (note: this version is pretty)
figure(3)
clf
subplot(1,3,1)
imagesc(orthoRankNorm)
title('All Orthobiologics Combinations')
ylabel('combination rank')
xlabel('input factor')
xticks([1:17])
xticklabels({'BMP2','BMP7','OG','PDGF','PU','ES','BMAC','PRP','EBG'})
set(gca,'fontweight','bold')
subplot(1,3,2)
imagesc(orthoTop200)
title('Top 200 Orthobiologics Combinations')
ylabel('combination rank')
xlabel('input factor')
xticks([1:17])
xticklabels({'BMP2','BMP7','OG','PDGF','PU','ES','BMAC','PRP','EBG'})
set(gca,'fontweight','bold')
subplot(1,3,3)
imagesc(orthoTop20)
title('Top 20 Orthobiologics Combinations')
ylabel('combination rank')
xlabel('input factor')
xticks([1:17])
xticklabels({'BMP2','BMP7','OG','PDGF','PU','ES','BMAC','PRP','EBG'})
set(gca,'fontweight','bold')

% show correlations between factors for top 200 or top 20
% (note: this is not too useful)
% figure(4)
% clf
% subplot(2,2,1)
% imagesc(rTop200)
% colorbar
% subplot(2,2,2)
% imagesc(pTop200)
% colorbar
% subplot(2,2,3)
% imagesc(rTop20)
% colorbar
% subplot(2,2,4)
% imagesc(pTop20)
% colorbar



