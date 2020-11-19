# Keypoint_detector

In particular, we will build Gaussian and Difference-of-Gaussians (DoG) scale spaces, and identify keypoints at local DoG scalespace maxima and minima. All of the information you need is in Section 3 of this paper.

provided a demo driver and two MATLAB functions to help you visualize your results:


showPyr(Pyr, ns) will display a pyramid Pyr (either Gaussian or DoG) with ns subband scales.

showKP(DoGPyr, ns, kp, nkp) will display a DoG pyramid with ns subband scales and plot the most extreme nkp DoG maxima and minima stored in kp. Maxima are shown in red, minima are shown in cyan.


[1]  Lowe, D. G. Distinctive image features from scale-invariant keypoints. International Journal of Computer Vision 60, 2 (2004), 91–110.
