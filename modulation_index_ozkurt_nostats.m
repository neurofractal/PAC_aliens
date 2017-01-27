function [m_raw1 m_raw2] = modulation_index_ozkurt_nostats(a, p)
 
  N = length(a);
  z = a.*exp(1i*p);
  m_raw1 = abs(mean(z));   %Compute the mean length 
  m_raw2 = (1./sqrt(N)) * abs(mean(z)) / sqrt(mean(a.*a)); % compute the direct estimate