% OrthoMakeTruthTable.m
% this script makes the Orthobiologics truth table;
% OrthoReadDataset must be run first

% make the input array
In = N(:,1:17); % segregate input values
In(isnan(In)) = 0; % set all NaNs to zero
% process the input column names
InNameLong   = CnameLong(2:18,:);  % remove the zero col names
InNameAbbrev = CnameAbbrev(2:18,:); % remove the zero col names

% make the desired output array
desOut = N(:,20:47); % segregate the desired output values
desOutSpy = desOut; % set up a spy array for desOut
desOutSpy(isnan(desOutSpy)) = 0; % set all NaNs to zero in desOutSpy
desOut = desOut(:,[1:20 23:28]); % remove two cols of all zeros
desOutSpy = desOutSpy(:,[1:20 23:28]); % remove two cols of all zeros
% (note: Excel file colums 44 and 45 are all zeros)
% process the desired output column names
desOutNameLong   = CnameLong([21:40 43:48],:); % remove zero col names
desOutNameAbbrev = CnameAbbrev([21:40 43:48],:); % remove zero col names

% scale some of the assigned inputs
% (note: what is being scaled are drug masses in ug rather than mg,
%  but the scaling does not brin the ug into the mg range; for that
%  they would have to be divided by 1000)
In(:,[1 10:11]) = In(:,[1 10:11]) ./ 100;

% view truth table using spy
figure(7)
clf
subplot(1,2,1)
spy(In)
axis square
xlabel('input number')
ylabel('pattern number')
title('Training Input')
subplot(1,2,2)
spy(desOutSpy)
axis square
xlabel('output number')
ylabel('pattern number')
title('Desired Output')










