#!/bin/bash

bin1=$1
bin2=$2
nevents=$3

cp trilinear-RW/tth-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py

cur_dir=tth_mc_"$bin1"_"$bin2"
cur_dir_me=tth_me_"$bin1"_"$bin2"

rm -r $cur_dir
rm -r $cur_dir_me

echo "The results will be written in the",$cur_dir

sed 's/output ttH_MC/output '"$cur_dir"'/g' proc_ttH_mc > proc_ttH_mc_"$bin1"_"$bin2"

./bin/mg5_aMC < proc_ttH_mc_"$bin1"_"$bin2"

sed -i -e "s/10000 = nevents /$nevents = nevents /" $cur_dir/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' $cur_dir/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' $cur_dir/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' $cur_dir/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' $cur_dir/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/235   = muR_ref_fixed/' $cur_dir/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/235   = muF_ref_fixed/' $cur_dir/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' $cur_dir/Cards/run_card.dat
#sed -i -e 's/10.0  = ptj/20.0 = ptj/' $cur_dir/Cards/run_card.dat
#sed -i -e 's/-1.0  = etaj/5.0  = etaj/' $cur_dir/Cards/run_card.dat

echo "run card manipule edildi"

#Pt cut for with bins. Mind the bins!
  
# Mind the folder paths!


sed -i '77a\c Pt cut for H' $cur_dir/SubProcesses/cuts.f
sed -i '78a\ ' $cur_dir/SubProcesses/cuts.f
sed -i '79a\       do i=1,nexternal' $cur_dir/SubProcesses/cuts.f
sed -i '80a\         if(istatus(i).eq.1 .and. ipdg(i).eq.25) then' $cur_dir/SubProcesses/cuts.f

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

echo import model hhh-model-new > proc_ttH_me_"$bin1"_"$bin2"
cat proc_ml >> proc_ttH_me_"$bin1"_"$bin2"
echo output $cur_dir_me >> proc_ttH_me_"$bin1"_"$bin2"
echo collier noinstall >> proc_ttH_me_"$bin1"_"$bin2"
echo quit >> proc_ttH_me_"$bin1"_"$bin2"


./bin/mg5_aMC < proc_ttH_me_"$bin1"_"$bin2"

cd $cur_dir_me/SubProcesses/
cp ../../trilinear-RW/makefile .
cp ../../trilinear-RW/check_OLP.f .
cp ../../check_olp.inc .
cp P0_gg_httx/pmass.inc .
cp P0_gg_httx/nsqso_born.inc .
cp P0_gg_httx/nsquaredSO.inc .


cp ../../$cur_dir/SubProcesses/c_weight.inc .
cp ../../$cur_dir/SubProcesses/P0_gg_httx/nexternal.inc .

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

echo order=LO > genEv_ttH_mc
echo shower=OFF >> genEv_ttH_mc

./bin/generate_events < genEv_ttH_mc


gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../$cur_dir_me/SubProcesses/

cd ../$cur_dir_me/SubProcesses/
./check_OLP | grep -B 2 "C1:" > ../../result_ttH_"$bin1"_"$bin2".txt
#./check_OLP | grep "SUM OF ORIGINAL WEIGHTS:" >> ../../result_ttH_"$bin1"_"$bin2".txt
#./check_OLP | grep "SUM OF NEW WEIGHTS:" >> ../../result_ttH_"$bin1"_"$bin2".txt

cd ../..

#mv  $cur_dir /tmp/odurmus/$cur_dir
#mv  $cur_dir_me /tmp/odurmus/$cur_dir_me



