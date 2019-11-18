function bodePlot(f, varargin)
% myBode
%
% Creates Bode plots for given system objects
%
% Usage:
%   myBode(f, sys0, sys1, ... )
%
%   f: The frequency vector in Hz
%   sys0, sys1, ... : Any number of system objects (created by ss) for which to plot bode plots

% Frequency vector
w = 2*pi*f;
s = 1i * w;
Nf = length(f);

db20 = @(x) 20*log10(abs(x));
phase = @(x) (180/pi)*unwrap(angle(x));

% Process each one of the given systems
Nsystems = nargin - 1;

% Loop over all systems
for sysind = 1:Nsystems

	sysx = varargin{sysind};
	N = length(sysx.b);
	myI = sparse(eye(N));

	% A, b and c
	A = sparse(sysx.a);
	b = sysx.b;
	c = sysx.c;

	y = zeros(Nf,1);

	for ind=1:Nf
		si = s(ind);
		y(ind) = c * ( (myI*si - A) \ b );
	end

	ydb = db20(y);
	yphase = phase(y);

	subplot1 = subplot(2,1,1);
	hold all
	semilogx(f,ydb)
	xlim([min(f) max(f)])
	ylim([-125 25])
	xlabel('Freq [Hz]'); ylabel('|H(f)| [dB]'); grid on

	subplot2 = subplot(2,1,2);
	hold all
	semilogx(f,yphase)
	xlim([min(f) max(f)])
	xlabel('Freq [Hz]'); ylabel('\angleH(f) [\circ]'); grid on

end % for Nsystems

set(subplot1, 'XScale', 'log')
set(subplot2, 'XScale', 'log')
