function Y = bh_baseline_correction(X, t, tw, btype)

% Y = bh_baseline_correction(X, t, tw, btype)
%
% Inputs:
%	X     - matrix or vector with time in the first dimension
%	t     - vector with time information
%	tw    - baseline time window [min max]
%	btype - baseline type (B = mean of X in the baseline window):
%	   'absolute' (default): X - B
%	   'relative':           X ./ B
%	   'relchange':          (X - B) ./ B
%	   'meanlogP':           10*log10(X) minus its baseline mean (power; recommended for dB)
%	   'meanlogA':           20*log10(X) minus its baseline mean (amplitude)
%	   'decibelP':           10*log10(X ./ B)  (power; negatively biased, see below)
%	   'decibelA':           20*log10(X ./ B)  (amplitude; negatively biased)
%
% Notes:
%	- Only 'absolute' gives the same result whether trials are averaged before or after correction.
%	- 'decibelP'/'decibelA' are negatively biased: they show decreases relative to baseline
%	  even when there is no change (Kinley et al., 2026, J Neurosci Methods 434:110826).
%	  'meanlogP'/'meanlogA' (mean-log-ratio) avoid this and are otherwise interpreted the same way.
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
% B. Herrmann, email: herrmann.b@gmail.com, 2012-02-16 (updated 2026)


% check inputs
if nargin < 3, error('Not enough inputs provided!'); end
if nargin < 4 || isempty(btype), btype = 'absolute'; end
if numel(tw) ~= 2, error('tw only allows two values!'); end
if isvector(X), X = X(:); end

% log-transform first for mean-log-ratio, then treat as absolute baseline
if strcmp(btype, 'meanlogP'), X = 10 .* log10(X); btype = 'absolute'; end
if strcmp(btype, 'meanlogA'), X = 20 .* log10(X); btype = 'absolute'; end

% get baseline matrix
tsamp = t >= min(tw) & t <= max(tw);
if numel(t) ~= size(X,1) || ~any(tsamp), error('t must match size(X,1), and tw must contain time points.'); end
siz   = size(X);
B     = repmat(reshape(mean(X(tsamp,:),1),[1 siz(2:end)]),[siz(1) ones(1,numel(siz)-1)]);

% do baseline correction
switch btype
	case 'absolute',  Y = X - B;
	case 'relative',  Y = X ./ B;
	case 'relchange', Y = (X - B) ./ B;
	case 'decibelP',  Y = 10 .* log10(X ./ B);
	case 'decibelA',  Y = 20 .* log10(X ./ B);
	otherwise, error('Unsupported baseline type: %s', btype);
end