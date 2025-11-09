% Baseline correction simulations (the script)
% Determine distributions for data from baseline correction %
% M.J. Henry & B. Herrmann, updated: 2016-03-25
% --------------------------------------------------------- % 

% Scaling of the baseline corrections 
% 'absolute' baseline 
% with a == b -> a-b = 0; minmax = [-inf inf] 

% 'relative' baseline 
% with a == b -> a/b = 1; minmax = [0 inf] 

% 'relchange' baseline 
% with a == b -> (a-b)/b = 0; minmax = [-1 inf] 

% 'decibel' baseline 
% with a == b -> 10*log10(a/b) = 0; minmax = [-inf inf]; 
% a and b must be positive 

% --------------------------------------------------------- % 
clear all

% User defined % 
Xm  = 10; % mean of a dist. 
Bm  = 5; % mean of b dist. - baseline 
SDx = .2; % std as percent of mean 
SDb = .2; 
it  = 100000; % number of iterations 

% --------------------------------------------------------- % 

x = randn(1,it).*(Xm*SDx) + Xm; % assuming constant shift in amplitude dist with stimulation 
b = randn(1,it).*(Bm*SDb) + Bm; % assuming normal distribution of baseline amplitudes 

% 'absolute' baseline 
A = x - b; 

% 'relative' baseline 
R = x ./ b; 

% 'relchange' baseline 
C = (x - b) ./ b; 

% 'decibel' baseline 
D = 10 * log10(x ./ b); 


h = figure; 
Ah = hist(A); 
Rh = hist(R); 
Ch = hist(C); 
Dh = hist(D); 

subplot(2,2,1),hist(A,50),title('Absolute'),set(gca,'YTickLabel',{''}); 
subplot(2,2,2),hist(R,50),title('Relative'),set(gca,'YTickLabel',{''}); 
subplot(2,2,3),hist(C,50),title('Relchange'),set(gca,'YTickLabel',{''}); 
subplot(2,2,4),hist(D,50),title('Decibel'),set(gca,'YTickLabel',{''}); 
% --------------------------------------------------------- % 
