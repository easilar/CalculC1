#!/bin/bash

bin1=$1
bin2=$2
nevents=$3

cp trilinear-RW/vvh-loop_diagram_generation.py madgraph/loop/loop_diagram_generation.py


cur_dir=tHj_mc_"$bin1"_"$bin2"
cur_dir_me=tHj_me_"$bin1"_"$bin2"

rm -r $cur_dir
rm -r $cur_dir_me

sed 's/output tHj_MC/output '"$cur_dir"'/g' proc_tHj_mc > proc_tHj_mc_"$bin1"_"$bin2"

./bin/mg5_aMC < proc_tHj_mc_"$bin1"_"$bin2"

sed -i -e "s/10000 = nevents /$nevents = nevents /" $cur_dir/Cards/run_card.dat
sed -i -e 's/nn23nlo = pdlabel/lhapdf = pdlabel/' $cur_dir/Cards/run_card.dat
sed -i -e 's/244600  = lhaid/90500  = lhaid/' $cur_dir/Cards/run_card.dat
sed -i -e 's/False    = fixed_ren_scale/True    = fixed_ren_scale/' $cur_dir/Cards/run_card.dat
sed -i -e 's/False    = fixed_fac_scale/True    = fixed_fac_scale/' $cur_dir/Cards/run_card.dat
sed -i -e 's/91.118   = muR_ref_fixed/148.75   = muR_ref_fixed/' $cur_dir/Cards/run_card.dat
sed -i -e 's/91.118   = muF_ref_fixed/148.75   = muF_ref_fixed/' $cur_dir/Cards/run_card.dat
sed -i -e 's/False = store_rwgt_inf/True = store_rwgt_inf/' $cur_dir/Cards/run_card.dat
sed -i -e 's/10.0  = ptj/0 = ptj/' $cur_dir/Cards/run_card.dat
#sed -i -e 's/20.0  = ptgmin/0  = ptgmin/' $cur_dir/Cards/run_card.dat
#sed -i -e 's/-1.0  = etaj/5.0  = etaj/' $cur_dir/Cards/run_card.dat
#sed -i -e 's/DECAY   6 1.405820e+00/DECAY   6 0e+00/' $cur_dir/Cards/param_card.dat

#Pt cut for H. Mind the bins!

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


./gevirt.sh $cur_dir/

echo import model hhh-model-new > proc_tHj_me_"$bin1"_"$bin2"
cat proc_ml >> proc_tHj_me_"$bin1"_"$bin2"
echo output $cur_dir_me >> proc_tHj_me_"$bin1"_"$bin2"
echo collier noinstall >> proc_tHj_me_"$bin1"_"$bin2"
echo quit >> proc_tHj_me_"$bin1"_"$bin2"

#sed -i -e 's/DECAY   6 1.405820e+00/DECAY   6 0e+00/' $cur_dir_me/Cards/param_card.dat

./bin/mg5_aMC < proc_tHj_me_"$bin1"_"$bin2"


#sed -i -e 's/DECAY   6 1.405820e+00/DECAY   6 0e+00/' $cur_dir_me/Cards/param_card.dat


cd $cur_dir_me/SubProcesses/
cp ../../trilinear-RW/makefile .
cp ../../trilinear-RW/check_OLP.f .
cp ../../check_olp.inc .
cp P0_udx_htbx/pmass.inc .
cp P0_udx_htbx/nsqso_born.inc .
cp P0_udx_htbx/nsquaredSO.inc .

cp ../../$cur_dir/SubProcesses/c_weight.inc .
cp ../../$cur_dir/SubProcesses/P0_udx_htbx/nexternal.inc .

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

echo order=LO > genEv_tHj_mc
echo shower=OFF >> genEv_tHj_mc

./bin/generate_events < genEv_tHj_mc


gunzip Events/run_01_LO/events.lhe.gz Events/run_01_LO/events.lhe
mv Events/run_01_LO/events.lhe ../$cur_dir_me/SubProcesses/

cd ../$cur_dir_me/SubProcesses/
./check_OLP | grep -B 2 "C1:" > ../../result_tHj_"$bin1"_"$bin2".txt

cd ../..

#mv  $cur_dir /tmp/odurmus/$cur_dir
#mv  $cur_dir_me /tmp/odurmus/$cur_dir_me


