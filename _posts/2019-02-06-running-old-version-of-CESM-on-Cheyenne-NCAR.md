---
layout: post
title:  running old version of CESM (1.3) on Cheyenne @NCAR
---
Here I kept some notes on how to run an oder version of CESM on the new HPC at NCAR (Cheyenne). I mainly followed the guideline on [Google doc](https://docs.google.com/document/d/1V5_oIA_ZPmLsMKp0rZlQ99CqQshx2pqcZsVQhT7lCb0/edit#), which is organized by [Jim Edwards](https://staff.ucar.edu/users/jedwards).  

I used mainly 4 steps:  
1. copy two files to source code folder/scripts/ccsm_utils/Machines  
[env_mach_specific.cheyenne](https://svn-ccsm-models.cgd.ucar.edu/Machines/release_tags/cesm1_2_x_n27_Machines_140528/env_mach_specific.cheyenne)   
[mkbatch.cheyenne](https://svn-ccsm-models.cgd.ucar.edu/Machines/release_tags/cesm1_2_x_n27_Machines_140528/mkbatch.cheyenne)   
*need to use this to download file: guestuser  friendly*  

2. add the following machine description to config_machines.xml  
<machine MACH="cheyenne">  
<DESC>NCAR SGI, os is Linux, 36 pes/node, batch system is PBS</DESC>  
<OS>LINUX</OS>  
<COMPILERS>intel,gnu</COMPILERS>  
<MPILIBS>mpt,mpi-serial</MPILIBS>  
<RUNDIR>/glade/scratch/$CCSMUSER/$CASE/run</RUNDIR>  
<EXEROOT>/glade/scratch/$CCSMUSER/$CASE/bld</EXEROOT>  
<DIN_LOC_ROOT>$ENV{CESMDATAROOT}/inputdata</DIN_LOC_ROOT>  
<DIN_LOC_ROOT_CLMFORC>$ENV{CESMDATAROOT}/lmwg</DIN_LOC_ROOT_CLMFORC>  
<DOUT_S_ROOT>/glade/scratch/$CCSMUSER/archive/$CASE</DOUT_S_ROOT>  
<DOUT_L_MSROOT>csm/$CASE</DOUT_L_MSROOT>  
<CCSM_BASELINE>$ENV{CESMDATAROOT}/ccsm_baselines</CCSM_BASELINE>  
<CCSM_CPRNC>$ENV{CESMDATAROOT}/tools/cime/tools/cprnc/cprnc.cheyenne</CCSM_CPRNC>  
<BATCHQUERY>qstat -f</BATCHQUERY>  
<BATCHSUBMIT>qsub</BATCHSUBMIT>  
<SUPPORTED_BY>cseg</SUPPORTED_BY>  
<GMAKE_J>8</GMAKE_J>  
<MAX_TASKS_PER_NODE>36</MAX_TASKS_PER_NODE>  
<PES_PER_NODE>36</PES_PER_NODE>  
</machine>  

3. check & revise a few script that may have a bad syntax  
look for the following code (or similar structure) “foreach $var qw(a b c)”,  
change it to “foreach $var (qw(a b c))”     
i.e. add () outside qw  

The following files are worth checking, and I only found one case in "models/drv/bld/build-namelist"  
ccsm_utils/Case.template/ConfigCase.pm   
ccsm_utils/Tools/cesm_setup   
models/drv/bld/build-namelist   

4. after create a new case, add “#PBS -A XXXXXAccountNumberXXXXX” to cesm1.3_CASENAME.run   

Note that, after submit the job, there will be only one active job, which is different from CESM2.0 that has an additional archive job.    


