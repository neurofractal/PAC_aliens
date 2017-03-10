# The Detection of Phase Amplitude Coupling During Sensory Processing
## Robert Seymour, Klaus Kessler & Gina Rippon (2017)

There is increasing interest in understanding how the phase and amplitude of distinct neural oscillations might interact to support dynamic communication within the brain. In particular, previous work has demonstrated a coupling between the phase of low frequency oscillations and the amplitude (or power) of high frequency oscillations during certain tasks, termed phase amplitude coupling (PAC).

![Imgur](http://i.imgur.com/Jsrrwbt.jpg)

**Phase Amplitude Coupling (PAC) is hypothesised to emerge when high frequency gamma-band activity becomes coupled to the phase of a lower frequency oscillation via an Excitation:Inhibition circuit.**


During visual processing in humans, PAC has been reliably observed between ongoing alpha (8-13Hz) and gamma-band (>40Hz) activity (Voytek et al., 2013). However, the application of PAC metrics to MEG data can be problematic due to numerous methodological issues and lack of coherent approaches within the field (Aru et al., 2015). 

Therefore, in this paper we discuss our approach to PAC analysis, using an MEG dataset from 20 participants performing an interactive paradigm with embedded visual grating. 

### Paradigm 

![Imgur](http://i.imgur.com/dzT8Kdp.png)

## Analysis

### Preprocessing

Each dataset was first cleaned using Maxfilter using tSSS with a 0.9 correlation limit. Further preprocessing was performed using the script [preprocessing_elektra_FT_MASTER.m](https://github.com/neurofractal/MEG_preprocessing/blame/master/preprocessing_elektra_FT_MASTER.m) resulting in a variable termed data_clean_noICA for each subject.

### Area V1 Virtual Electrode

In order to investigate PAC representative time course from area V1. 

To do this created a 3D cortical mesh using Freesurfer and registered to a common FS_LR space using the instructions from the [Human Connectome Project](https://wiki.humanconnectome.org/download/attachments/63078513/Resampling-FreeSurfer-HCP.pdf?version=1&modificationDate=1472225460934&api=v2). This mesh was downsampled 4002 vertices per hemisphere.

I used HCP MMP 1.0 Atlas 

### PAC Analysis





