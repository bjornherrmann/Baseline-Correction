function Y = bh_baseline_correction(X, t, tw, btype)

% Y = bh_baseline_correction(X, t, tw, btype)
%
% Inputs:
%	X     - matrix or vector with time in the first dimension
%	t     - vector with time information
%	tw    - baseline time window [min max]
%	btype - baseline type: 
%	   'absolute' (default): - same results for averaing trials before or after baseline correction 
%	                         - scaling: minmax = [-inf inf]; is 0 for X == B
%	                         - provides the different results for X and X.^2, i.e. for amplitude and power
%                          - according to Cohen MX (2014, Analyzing neural time series data. The MIT Press), this baseline does not adress 1/f power-law scaling
%
%	   'relative': - same results for averaing trials before or after baseline correction
%	               - scaling: minmax = [0 inf]; is 1 for X == B
%	               - provides the same results for X and X.^2, i.e. for amplitude and power
%
%	   'relchange': - same results for averaing trials before or after baseline correction
%	                - scaling: minmax = [-1 inf]; is 0 for X == B
%	                - provides the different results for X and X.^2, i.e. for amplitude and power
%
%	   'decibelP': - is defined only for power values
%	               - different results for averaing trials before or after baseline correction
%	               - scaling: minmax = [-inf inf]; is 0 for X == B
%	               - provides the different results for X and X.^2, i.e. for amplitude and power (but is only defined for power anyways)
%                - don't use it on single trials (Cohen MX, 2014, Analyzing neural time series data. The MIT Press.)
%
%	   'decibelA': - is defined only for amplitude values
%	               - different results for averaing trials before or after baseline correction
%	               - scaling: minmax = [-inf inf]; is 0 for X == B
%	               - provides the different results for X and X.^2, i.e. for amplitude and power (but is only defined for amplitude anyways)
%                - don't use it on single trials (Cohen MX, 2014, Analyzing neural time series data. The MIT Press.)
%
% Output:
%	Y - baseline-corrected data matrix
%
% Description: The script does a baseline correction on a data matrix.
% ---------
%
%    Copyright (C) 2020
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
% --------------------------------------------------------------------
% B. Herrmann, email: herrmann.b@gmail.com, 2012-02-16

% check inputs
Y = [];
if nargin < 3, fprintf('Error: Not enough inputs provided!\n'); return; end
if nargin < 4 || isempty(btype), btype = 'absolute'; end
if ~ismember(btype,{'absolute' 'relative' 'relchange' 'decibelP' 'decibelA'}), fprintf('Info: Unsupported method! ''absolute'' will be used!\n'); btype = 'absolute'; end
if numel(tw) ~= 2, fprintf('Error: tw only allows two values!\n'); return; end
if isvector(X), X = X(:); end


% get baseline matrix
tsamp = tw(1) <= t & tw(2) >= t;
siz   = size(X);
B     = repmat(reshape(mean(X(tsamp,:),1),[1 siz(2:end)]),[siz(1) ones(1,numel(siz)-1)]);

% do baseline correction
if strcmp(btype, 'absolute')
	Y = X - B;
elseif strcmp(btype, 'relative')
	Y = X ./ B;
elseif strcmp(btype, 'relchange')
	Y = (X - B) ./ B;
elseif strcmp(btype, 'decibelP')
	Y = 10 .* log10(X ./ B);
elseif strcmp(btype, 'decibelA')
	Y = 20 .* log10(X ./ B);
end

return;
