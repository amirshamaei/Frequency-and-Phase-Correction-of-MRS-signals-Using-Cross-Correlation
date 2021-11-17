% Frequency and Phase Correction of MRS signals Using Cross-Correlation
% Written by Amir Shamaei amirshamaei@isibrno.cz 2021
% The algorithm is based on the "Automatic frequency and phase alignment 
% of in vivo J-difference-edited MR spectra by frequency domain correlation" paper. 
% The authors of the paper find the maximum using manual grid search. 
% But here, the problem is converted to a non-linear minimization problem 
% which can be solved by direct search or Newton family methods.

function rslt = FPCcorr(fid, signals, method, range, dwelltime, visus )

global fid
% fid = refrence;
global t
global signals
% signals = inSignals;
global range
% range = ranges;
global shifted
global visu
visu = visus
global k
k = 1
t=0:dwelltime:(length(fid)-1)*dwelltime;
parsFit=[0,0];
if visu == true
    if method == "fminunc"
        options = optimoptions('fminunc','PlotFcns',@optimplotfval);
    elseif method == "fminsearch"
        options = optimset('PlotFcns',@optimplotfval);
    end
elseif visu == false
    if method == "fminunc"
        options = optimoptions('fminunc');
    elseif method == "fminsearch"
        options = optimset("fminsearch");
    end
end

for(i=1:length(signals))
    shifted = signals(:,i);
    parsFit=[0 0];
    if method == "fminunc"
        parsFit=fminunc(@func,parsFit,options);
    else
        parsFit=fminsearch(@func,parsFit,options);
    end
    k = k+1;
    rslt(1,i) = parsFit(1);
    rslt(2,i) = round(parsFit(2),5);
end

end
function y=func(pars)
f=pars(1);     %Frequency Shift [Hz]
p=pars(2);     %Phase Shift [deg]
global t
global range
global fid;
global shifted
global visu
global k
ffid = fftshift(fft(addphase(fid.*exp(1i*t'*f*2*pi*0.001),p)));
fshifted = fftshift(fft(shifted));
corr = dot(ffid(range),fshifted(range));
if visu == true
    figure(99)
    plot(range,ffid(range),range,fshifted(range))
    drawnow;
    title(k)
end
y= -1 * double((real(corr)))/(sum(abs(ffid(range)))*sum(abs(fshifted(range))));
end
%from addphase.m
% Jamie Near, McGill University 2014. 
function PhasedSpecs=addphase(specs,AddedPhase);
PhasedSpecs=specs.*(ones(size(specs))*exp(1i*AddedPhase*pi/180));
end
