# !/bin/bash 

#===============================
# Ambresh Shivaji & Xiaoran Zhao
# CP3, UCL
# XX/03/2017
#===============================

# This script is a collection of steps described in "ReadMe.txt" file in 'trilinear-RW'.
# It should be kept in 'MG5_aMC_v2_5_5' folder along with "proc_hz_mc".
# The script assumes that "libpdf.a", "libLHAPDF.a", 'Pdfdata', 'PDFsets' are kept in 
# 'MG5_aMC_v2_5_5/HHH-libs' folder. Clarify with step 6 in "ReadMe.txt". It also
# assumes that "vvh-loop_diagram_generation.py" is kept in 'MG5_aMC_v2_5_5/madgraph/loop' folder.
# "run_card.dat" and "param_card.dat" are provided for benchmarking.


cp madgraph/loop/vvh-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py

./bin/mg5_aMC < proc_hz_mc

sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' hz_MC/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' hz_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' hz_MC/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' hz_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/108.0938   = muR_ref_fixed/' hz_MC/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/108.0938   = muF_ref_fixed/' hz_MC/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' hz_MC/Cards/run_card.dat


./gevirt.sh hz_MC

echo import model hhh-model > proc_hz_me
cat proc_ml >> proc_hz_me
echo output hz_ME >> proc_hz_me

./bin/mg5_aMC < proc_hz_me

cd hz_ME/SubProcesses/

cp $HOME/temp_dir/trilinear-coupling-code/trilinear-RW/makefile .
cp $HOME/temp_dir/trilinear-coupling-code/trilinear-RW/check_OLP.f .

cp ../../check_olp.inc .

cp P0_uux_hz/pmass.inc .
cp P0_uux_hz/nsqso_born.inc .
cp P0_uux_hz/nsquaredSO.inc .

cp ../../hz_MC/SubProcesses/c_weight.inc .
cp ../../hz_MC/SubProcesses/P0_uux_hz/nexternal.inc .

cd ../lib/
 
cp $HOME/temp_dir/trilinear-coupling-code/MG5_aMC_v2_5_5/HHH-libs/libpdf.a .
cp -r $HOME/temp_dir/trilinear-coupling-code/MG5_aMC_v2_5_5/HHH-libs/Pdfdata .
cp $HOME/temp_dir/trilinear-coupling-code/MG5_aMC_v2_5_5/HHH-libs/libLHAPDF.a .
cp -r $HOME/temp_dir/trilinear-coupling-code/MG5_aMC_v2_5_5/HHH-libs/PDFsets .

cd ../SubProcesses/

make OLP_static
make check_OLP


cd ../../
cp madgraph/loop/loop_diagram_generation_original.py madgraph/loop/loop_diagram_generation.py
