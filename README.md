# electrode_localization

code for overlaying atlas in subject native space

## Input
* subject T1
* subject warped atlas

## Pipeline
* LBCN pipeline (as of 2026) uses Freesurfer for T1/CT coregistration and normalization for extracting standard space electrode coordinages. 
* In this process, we obtain a Freesurfer atlas, warped into subject native space `aseg.mgz`

## Atlas other than Freesurfer aseg
* with normalization and corresponding affine matrix, we can also project standard atlases into subject native space.
* Code is in NORMALIZE_ATLAS.sh
