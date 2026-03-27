
LBCN_INPUT_T1="/Users/heejungj/Documents/SANDBOX_ATLAS/T1.nii.gz"
NAME_FOR_STEP01_AFFINE_MAT="/Users/heejungj/Documents/SANDBOX_ATLAS/subject2MNI_affine.mat"
NAME_FOR_STEP01_T1_LINEAR="/Users/heejungj/Documents/SANDBOX_ATLAS/T1_in_MNI_linear.nii.gz"
NAME_FOR_STEP02_T1_NONLINEAR="/Users/heejungj/Documents/SANDBOX_ATLAS/T1_in_MNI_nonlinear.nii.gz"
NAME_FOR_STEP02_WARP="/Users/heejungj/Documents/SANDBOX_ATLAS/subject2MNI_warp.nii.gz"
NAME_FOR_STEP03_MNI="/Users/heejungj/Documents/SANDBOX_ATLAS/MNI2subject_warp.nii.gz"
HO_IN_SUBJECT="/Users/heejungj/Documents/SANDBOX_ATLAS/HarvardOxford_in_subject_space.nii.gz"


flirt \
-in ${LBCN_INPUT_T1} \
-ref $FSLDIR/data/standard/MNI152_T1_1mm.nii.gz \
-omat ${NAME_FOR_STEP01_AFFINE_MAT} \
-dof 12 \
-out /Users/heejungj/Documents/SANDBOX_ATLAS/T1_in_MNI_linear.nii.gz

# register T1 -> MNI 152
fnirt \
--in=/Users/heejungj/Documents/SANDBOX_ATLAS/T1.nii.gz \
--ref=$FSLDIR/data/standard/MNI152_T1_1mm.nii.gz \
--aff=/Users/heejungj/Documents/SANDBOX_ATLAS/subject2MNI_affine.mat \
--cout=${NAME_FOR_STEP02_WARP} \
--iout=/Users/heejungj/Documents/SANDBOX_ATLAS/T1_in_MNI_nonlinear.nii.gz

# Invert wrap
invwarp \
-w ${NAME_FOR_STEP02_WARP} \
-r ${LBCN_INPUT_T1} \
-o ${NAME_FOR_STEP03_MNI}

import nibabel as nib
img = nib.load('aseg.mgz')
nib.save(nib.Nifti1Image(img.get_fdata(), img.affine), 'aseg.nii.gz')

mri_convert /Users/heejungj/Documents/SANDBOX_ATLAS/aseg.mgz /Users/heejungj/Documents/SANDBOX_ATLAS/aseg.nii.gz


# apply atlas
applywarp \
--in=$FSLDIR/data/atlases/HarvardOxford/HarvardOxford-cort-maxprob-thr25-1mm.nii.gz \
--ref=${LBCN_INPUT_T1} \
--warp=${NAME_FOR_STEP03_MNI} \
--out=HarvardOxford_in_subject_space.nii.gz \
--interp=nn