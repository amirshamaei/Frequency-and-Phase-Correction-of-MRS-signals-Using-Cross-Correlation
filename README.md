# Frequency and Phase Correction of MRS signals Using Cross-Correlation
Written by Amir Shamaei amirshamaei@isibrno.cz 2021

The algorithm is based on the "Automatic frequency and phase alignment of in vivo J-difference-edited MR spectra by frequency domain correlation" paper. The authors of the paper find the maximum using manual grid search. But here, the problem is converted to a non-linear minimization problem which can be solved by direct search or Newton family methods.
FPCcorr(refrence signal, data(number of points, number of signals), method("fminunc" or "fminsearch"), range(in points, e.g: 1:1:1000), dwelltime, visus(true or false) )
* I didn't normalize the dot product but in case you find it neccessary you can add it to the @func.
## This project was supported by:
European Union's Horizon 2020 research and innovation program under the Marie Sklodowska-Curie grant agreement No 813120 (INSPiRE-MED)
