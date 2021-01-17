# CalculC1
## Packages
* [MadGraph v2_5_5](https://launchpad.net/mg5amcnlo)
* [LoopTools v2_13 ](http://www.feynarts.de/looptools/)
* [trilinear coupling package](https://cp3.irmp.ucl.ac.be/projects/madgraph/wiki/HiggsSelfCoupling#no1)
## References
1. [Trilinear Higgs Coupling](https://arxiv.org/pdf/1709.08649.pdf)
2. [paper_dummylink](link)
3. [STXS bins](https://twiki.cern.ch/twiki/bin/view/LHCPhysics/LHCHXSWGFiducialAndSTXS)
## Preparation for runing
### Create working directory
```
mkdir produce_c1
cd produce_c1
```
### Download necessary packages
```
wget https://launchpad.net/mg5amcnlo/2.0/2.5.x/+download/MG5_aMC_v2.5.5.tar.gz
wget http://www.feynarts.de/looptools/LoopTools-2.13.tar.gz
wget https://cp3.irmp.ucl.ac.be/projects/madgraph/raw-attachment/wiki/HiggsSelfCoupling/trilinear-RW.tar.gz
```
### Setup packages
install madgraph
```
tar -xzf MG5_aMC_v2.5.5.tar.gz
cd MG5_aMC_v2_5_5/
```
Check madgraph installation
```
 ./bin/mg5_aMC
MG5_aMC> generate p p > t t~
MG5_aMC> display processes
MG5_aMC> display diagrams
MG5_aMC> output testttbar
MG5_aMC> launch
MG5_aMC> quit
``` 
install looptools
```
cd produce_c1
produce_c1]$ tar -xzf LoopTools-2.13.tar.gz 
produce_c1]$ cd LoopTools-2.13/
LoopTools-2.13]$ ./configure
LoopTools-2.13]$ make
LoopTools-2.13]$ make install
```
install lhapdf6
```
MG5_aMC_v2_5_5]$ ./bin/mg5_aMC
MG5_aMC>install lhapdf6 --force
```
setup trilinear-RW
```
produce_c1]$ tar -xzf trilinear-RW.tar.gz
produce_c1]$ mv trilinear-RW MG5_aMC_v2_5_5/
produce_c1]$ cd MG5_aMC_v2_5_5/
MG5_aMC_v2_5_5]$ cp -r trilinear-RW/hhh-model/ models/hhh-model-new/
MG5_aMC_v2_5_5]$ cp trilinear-RW/gevirt.sh .
MG5_aMC_v2_5_5]$ cp trilinear-RW/vvh-loop_diagram_generation.py madgraph/loop/
MG5_aMC_v2_5_5]$ cp trilinear-RW/tth-loop_diagram_generation.py madgraph/loop/
```
Now clone this repository to obtain running scripts

```
MG5_aMC_v2_5_5]$ git clone https://github.com/easilar/CalculC1.git
MG5_aMC_v2_5_5]$ mv CalculC1/proc_* .
MG5_aMC_v2_5_5]$ mv CalculC1/run* .
```
Now you are ready for runnign the trilinear-RW package

## Running the trilinear-RW package
Example for running the hw
```
MG5_aMC_v2_5_5]$ sh run_hw.sh
```
By replacing hw in the name of run file you can run all other processes.
Other processes that can be run hw,hz,ttH,tHj,vbf

## Inclusive Results
These results are obtained using 10k events, while the reference paper uses 500k events
|process| <img src="https://render.githubusercontent.com/render/math?math=\sigma(LO)\cdot Nevents"> | <img src="https://render.githubusercontent.com/render/math?math=\sigma(O(\lambda_3))\cdot Nevents"> | C1(%) | C1(%) paper|
|:---| :-----:| :----:|:----: |:----:|
|HZ  | 6290.6464 | 75.3274|1.1975 |1.19|
|HW  | 11625.76 | 119.1745|1.0250 |1.03|
|ttH | 5404.128| 189.2334|3.5016 |3.52|
|VBF | 30270.987 | 188.30949|0.622|0.63|
|tHj | 388.926 | 3.9591|1.018 |0.91|
## Differential Results
These results are obtained using 10k events.
We currently applied the pT(H) cut in the Subprocess/cuts.f file.
```
do i=1,nexternal
   if(istatus(i).eq.1 .and. ipdg(i).eq.25) then
       if(pt_04(p(0,i)).lt.60 .or. pt_04(p(0,i)).gt.120) then
          passcuts_user=.false.
       endif
   endif
enddo
```
### ttH
|pT(H)[GeV]| C1(%)|
|:---:     |:----:|
|0 - 60    |5.07  |
|60 - 120  |4.07  |
|120 - 200 |2.74  |
|200 - 300 |1.52  |
|>300      |0.58  |
### HZ
|pT(Z)[GeV]| C1(%)|
|:---:     |:----:|
|0 - 75    |1.64  |
|75 - 150  |0.80  |
|>150      |0.14  |
### HW
|pT(Z)[GeV]| C1(%)|
|:---:     |:----:|
|0 - 75    |1.41  |
|75 - 150  |0.69  |
|>150      |0.12  |
### TODO
(OZGUR yapacak)
* Edit README: give paper names and proper links to papers
* Combine all the run scripts in to one script which takes the process name as an argument.
Take care the process directory 
* Run the framework with 500k events and update the result table accordingly 
* Add script for pT binned calculation
