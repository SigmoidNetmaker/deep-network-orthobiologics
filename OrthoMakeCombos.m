% OrthoMakeCombos.m
% this script makes input combinaitons to be tested
% with the best neural network for the Ortho dataset;
% levels of inputs are either binary or quantized into
% several integer levels; all resulting inputs are
% normalized into [0,1] after the combinations are set;
% there should be 3840 combinations in all

% set the levels of all the inputs
BMP7levs = [0,5];
OGlevs   = [0, 50, 100, 150];
PDGFlevs = [0, 50, 100, 150, 200];
PUlevs   = [0, 50, 100, 150];
ESlevs   = [0, 1];
BMAClevs = [0, 1];
PRPlevs  = [0, 1];
BMP2levs = [0, 5, 10, 15];
EBGlevs  =  1;

% make the 5120 combinaitons of all 9 input factors
orthoCombos = zeros(5120,9); % define array
count = 1; % set counter to one
for BMP7 = BMP7levs % for all BMP7 levels
    for OG = OGlevs % for all OG levels
        for PDGF = PDGFlevs % for all PDGF levels
            for PU = PUlevs % for all PU levels
                for ES = ESlevs % for all ES levels
                    for BMAC = BMAClevs % for all BMAC levels
                        for PRP = PRPlevs % for all PRP levels
                            for BMP2 = BMP2levs % for all BMP2 levels
                                for EBG = EBGlevs % for all EGB levels
                                    orthoCombos(count,:) = ...
            [BMP7, OG, PDGF, PU, ES, BMAC, PRP, BMP2, EBG]; % make combo
            count = count + 1; % increment counter
                                end % end EBG loop
                            end % end BMP2 loop
                        end % end PRP loop
                    end % end BMAC loop
                end % end ES loop
            end % end PU loop
        end % end PDGF loop
    end % end OG loop
end % end BMP7 loop

% remove all combos with PU and ES both nonzero
orthoCombos = ...
    orthoCombos(find(~(orthoCombos(:,4) > 0 & orthoCombos(:,5) > 0)),:);

% remove all combos with BMAC and PRP both nonzero
orthoCombos = ...
    orthoCombos(find(~(orthoCombos(:,6) > 0 & orthoCombos(:,7) > 0)),:);

% confirm size of orthoCombo
comboNum = size(orthoCombos,1);

% normalize columns of orthoCombos
% (note: all factors have min 0, so just divide 
%  all columns by their max to normalize)
numCols = size(orthoCombos,2);
for col = 1:numCols
    orthoCombos(:,col) = orthoCombos(:,col) / max(orthoCombos(:,col));
end % end normalizaion loop

% show orthoCombos as an image
figure(6)
clf
imagesc(orthoCombos)
title('Orthobiologics Input Combinations')
ylabel('combination number')
xlabel('input factor')
xticklabels({'BMP7','OG','PDGF','PU','ES','BMAC','PRP','BMP2','EBG'})




            
            
 
    






                   
    







