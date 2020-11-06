# CalculC1
## Packages
* [MadGraph v2_5_5](https://launchpad.net/mg5amcnlo)
* [LoopTools v2_13 ](http://www.feynarts.de/looptools/)
* [trilinear coupling package](https://cp3.irmp.ucl.ac.be/projects/madgraph/wiki/HiggsSelfCoupling#no1)
## ReferenceReference Papers
1. [paper](link)
2. [paper](link)
3. [paper](link)
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
```
Now clone this repository to obtain running scripts

```
MG5_aMC_v2_5_5]$ git clone https://github.com/easilar/CalculC1.git
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
|process| <img src="https://render.githubusercontent.com/render/math?math=\sigma(LO)"> | <img src="https://render.githubusercontent.com/render/math?math=\sigma(O(\lambda_3))"> | C1(%) | C1(%) paper|
|:---| :-----| :----|----: |:----|
|HZ  | Value | Value|Value |Value|
|HW  | Value | Value|Value |Value|
|ttH | Value | Value|Value |Value|
|VBF | Value | Value|Value |Value|
|tHj | Value | Value|Value |Value|
### TODO
* Combine all the run scripts in to one script which takes the process name as an argument.
Take care the process directory 
* Run the framework with 500k events and update the result table accordingly 
* Add script for pT binned calculation
