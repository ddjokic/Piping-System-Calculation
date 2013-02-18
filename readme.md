<h4>Piping System Calculation</h4>

Octave scripts to calculate interaction between piping system and pump, by use of H-Q (Headloss - Flow) curves.</p>
<h5>What is <u>not</u> in here</h5>
It is <u>not</u> replacement for full fledged Hydraulic Flow Calculation program. </p>
Scripts are written as a tool which handles numbers correctly, I hope. Engineering conclusion and judgment are on you.</p>
<h5>What is in here</h5>
Few scripts which can speed up process of initial dimensioning pipelines in piping system. Usable (at least for me) for **preliminary** calculation.</p>
Scripts:</p>
1. eq_pump.m - calculates **equivalent pump** characterisitics. Just pump minus pressure losses in suction line;</p>
2. pipeloop.m - main calculation script, uses "flow.m" octave function file. Number of serial and parallel pipes is limited to 15 each</p>
3. pump.m - fitting pump curve with 2nd degree curve, given **minimum 3 points**. Original calculation script (and bit more) can be found [here](https://github.com/ddjokic/Pump-Calculation)</p>
4. Flow.m - function called by pipeloop script
As all is about curves, results are witten in "dxf" and "png" files.</p>
**dxf file** is needed as solution is graphical. Numerical solution can be obtained, but not subject of this excersise (yet).
<h5>You may need</h5>
Darcy-Weisbach pressure loss calculation in **single pipe**. My script can be found [here](https://github.com/ddjokic/Headloss-in-Pipe), together with few more infos. Or any other script, spreadsheet or means to get pipe Q-H Curve in form **H=A*Q^2+B**.
<h5>How to use?</h5>
Detailed workflow will be posted in near future. If interested, stay tuned.</p>
<h5>Limits</h5>
Scripts are limited to open piping systems (Loops/Subloops) of 30 pipes - 15 in parallel and 15 in serial, one pump and one suction pipe. There is a trick to handle more than 1 pump and 1 suction line - calculate equivalent pump(s) and feed results to appropriate section of "pipeloop" script.
Note that for both, serial and parallel pipes, subloops minimum 1 pipe is required. If you do not need them, just input A and B as '0' (zero).
<h5>Units</h5>
Scripts are calling for Flow expressed in cubic meters per hour [cum/h] and Headloss in meters [m]. Any other, consistent unit system will do. 
<h5>Edit Feb-2013</h5>
Added numerical solution, file "pipeloopnum.m" and output example files - png and dxf.</p>
Note that work is not finished and that scripts can return unexpected, even wrong, results.
<h5>Disclaimer</h5>
There is no any kind of warranty. You are using all scripts posted here on your own risk. Those will not break your computer or format your disk, but may break your engineering reputation. </p>
If that happens do not call me. </p>
<h5>Licence</h5>
As script are coming without any kind of Warranty, feel free to modify them as it fit your needs. 

© D. Djokic, 2013

