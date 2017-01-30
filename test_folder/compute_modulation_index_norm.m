function [m_norm_length, p_values, m_raw] = compute_modulation_index_norm(a, p, srate)
 
  numpoints = length(a);
  numsurrogate=200;                                 %Use 200 surrogates.
  
  minskip=srate;                                  %The min amount to shift amplitude.
  maxskip=numpoints-srate;                        %The max amount to shift amplitude.
  skip = ceil(numpoints.*rand(numsurrogate*2,1)); %Create a list of amplitude shifts.
%   skip(find(skip > maxskip))=[];                  %Make sure they're not too big.
%   skip(find(skip < minskip))=[];                  %Or too small.
%   skip = skip(1:numsurrogate,1);
  
  z = a.*exp(1i*p);
  m_raw = mean(z);   %Compute the mean length of unshuffled data.
  

 
  surrogate_m = zeros(numsurrogate, 1);
  for s=1:numsurrogate                                      %For each surrogate,
   surrogate_amplitude = [a(skip(s):end) a(1:skip(s)-1)];   %Shift the amplitude,
   %and compute the mean length.
   surrogate_m(s) = abs(mean(surrogate_amplitude.*exp(1i*p)));
  end
 
  %Compare true mean to surrogates.
  [surrogate_r_mean, surrogate_r_std] = normfit(surrogate_m);
  m_norm_length = (abs(m_raw) - surrogate_r_mean)/surrogate_r_std;  %Create a z-score.
  
  p_values = 1 - normcdf(abs(m_raw), surrogate_r_mean, surrogate_r_std); % Tolga added this part!