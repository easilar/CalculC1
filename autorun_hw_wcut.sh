#!/bin/bash

#Input parameters defined: lower(upper) bound of the PT bin as bin1 (bin2), number of events as nevents

bin1=$1
bin2=$2
nevents=$3

#Relevant loop diagram generation script is copied. Note that the one for ttH is different.

cp trilinear-RW/vvh-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py

#Output files are defined

cur_dir=hw_mc_"$bin1"_"$bin2"
cur_dir_me=hw_me_"$bin1"_"$bin2"

rm -r $cur_dir
rm -r $cur_dir_me

echo "The results will be written in the",$cur_dir

sed 's/output hw_MC/output '"$cur_dir"'/g' proc_hw_mc > proc_hw_mc_"$bin1"_"$bin2"

./bin/mg5_aMC < proc_hw_mc_"$bin1"_"$bin2"

#Necessary modifications to the Cards are done.

sed -i -e "s/10000 = nevents /$nevents = nevents /" $cur_dir/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' $cur_dir/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' $cur_dir/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' $cur_dir/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' $cur_dir/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/102.693   = muR_ref_fixed/' $cur_dir/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/102.693   = muF_ref_fixed/' $cur_dir/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' $cur_dir/Cards/run_card.dat
#sed -i -e 's/10.0  = ptj/20.0 = ptj/' $cur_dir/Cards/run_card.dat
#sed -i -e 's/-1.0  = etaj/5.0  = etaj/' $cur_dir/Cards/run_card.dat

#echo "run card manipule edildi"

#Pt cut for with bins. Mind the bins!

# Mind the folder paths!

#PT cut is defined. Note that the cuts are put on different particles in STXS bins. Careful when merging the code into one!

sed -i '77a\c Pt cut for W' $cur_dir/SubProcesses/cuts.f
sed -i '78a\ ' $cur_dir/SubProcesses/cuts.f
sed -i '79a\       do i=1,nexternal' $cur_dir/SubProcesses/cuts.f
sed -i '80a\         if(istatus(i).eq.1 .and. abs(ipdg(i)).eq.24) then' $cur_dir/SubProcesses/cuts.f

if [ $bin2 -lt 0 ]
then
sed -i "81a\           if(pt_04(p(0,i)).lt.$bin1) then" $cur_dir/SubProcesses/cuts.f
else
sed -i "81a\           if(pt_04(p(0,i)).lt.$bin1 .or. pt_04(p(0,i)).gt.$bin2) then" $cur_dir/SubProcesses/cuts.f
fi

sed -i '82a\             passcuts_user=.false.' $cur_dir/SubProcesses/cuts.f
sed -i '83a\           endif' $cur_dir/SubProcesses/cuts.f
sed -i '84a\         endif' $cur_dir/SubProcesses/cuts.f
sed -i '85a\       enddo' $cur_dir/SubProcesses/cuts.f
sed -i '86a\' $cur_dir/SubProcesses/cuts.f

echo "Pt cut eklendi"


./gevirt.sh $cur_dir/

echo import model hhh-model-new > proc_hw_me_"$bin1"_"$bin2"
cat proc_ml >> proc_hw_me_"$bin1"_"$bin2"
echo output $cur_dir_me >> proc_hw_me_"$bin1"_"$bin2"
echo collier noinstall >> proc_hw_me_"$bin1"_"$bin2"
echo quit >> proc_hw_me_"$bin1"_"$bin2"


./bin/mg5_aMC < proc_hw_me_"$bin1"_"$bin2"

#Following the Readme file of Trilinear-RW

cd $cur_dir_me/SubProcesses/
cp ../../trilinear-RW/makefile .
cp ../../trilinear-RW/check_OLP.f .
cp ../../check_olp.inc .
cp P0_udx_hwp/pmass.inc .
cp P0_udx_hwp/nsqso_born.inc .
cp P0_udx_hwp/nsquaredSO.inc .


cp ../../$cur_dir/SubProcesses/c_weight.inc .
cp ../../$cur_dir/SubProcesses/P0_udx_hwp/nexternal.inc .

cd ../lib/
cp ../../HHH-libs/libpdf.a .
cp -r ../../HHH-libs/Pdfdata .
cp ../../HHH-libs/libLHAPDF.a .
cp -r ../../HHH-libs/PDFsets .


cd ../SubProcesses/

make OLP_static
make check_OLP

cd ../../
cd $cur_dir/

#No shower for hw. tHj and VBF will need it.

echo order=LO > genEv_hw_mc
echo shower=OFF >> genEv_hw_mc
echo analysis=EXROOTANALYSIS >> genEv_hw_mc #we don't use the analysis feature so no need to add actually. We do this stand alone.

./bin/generate_events < genEv_hw_mc


gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../$cur_dir_me/SubProcesses/

cd ../$cur_dir_me/SubProcesses/
./check_OLP | grep -B 2 "C1:" > ../../result_hw_"$bin1"_"$bin2".txt

#Below part is necessary for the storage space shortage. Especially when the calculations are done in parallel in STXS bins.

cd ../..

#mv  $cur_dir /tmp/odurmus/$cur_dir
#mv  $cur_dir_me /tmp/odurmus/$cur_dir_me


