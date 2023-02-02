<b>New Assembly Files for MSX, Z80 | 2022/2023 </b>
<br>
<div style="display:table">
<div style="display:table-row">	
  <div style="display:table-cell;width:200px"><b>vrcheck.asm</b></div><div style="display:table-cell">  Check amount of VRAM, MSX 1 and up. 16Kbytes up to 512Kbytes, TMS9918A, TMS9928A, TMS9929A, V9938, V9948, V9958, V9978 <br></div>
</div>
<div style="display:table-row">	

  <div style="display:table-cell;width:200px"><b>cpuspeed.asm</b></div><div style="display:table-cell"> Check speed 3.57Mhz, 7.13Mhz, R800 (60hz only)<br></div>
</div>
<div style="display:table-row">	

  <div style="display:table-cell;width:200px"><b>speedf.asm</b></div><div style="display:table-cell"> Speed of MSX. Value of CPU * 3.57 Mhz, Normal, 7Mhz and R800(OpenMSX) tested. if EMULAT=1 you are in OpenMSX (50 & 60 hz). Using F bit of status register 0 <br></div>
</div>

<div style="display:table-row">	

  <div style="display:table-cell;width:200px"><b>speedf.bin</b></div><div style="display:table-cell"> Build of speedf.asm<br>
  
  
  Build at &HC000, xcution at same address ..<br>

CPU = &HC092 -> Result R Only <br>
EMULAT = &HC08E -> DOESNT WORK YET<br>
TURBO = &HC08F -> Variable 0,1,2 R800, 0= Z80, 1&2 = R800, W only, used when xcution<br>
RESULT = &HC090 + 1 -> real result, CPU and EMULAT are based on this result, R only<br>
VDP = &HC07A -> routine to toggle 50/60 hz, X only <br>
  
  
  </div>
</div>
<div style="display:table-row">	

  <div style="display:table-cell;width:200px"><b>speedf2.bin</b></div><div style="display:table-cell"> Build of speedf2.asm<br>
  
  
  Build at &HC000, xcution at same address ..<br>
NTSC= &hC082: 0/2/128/130, W only <br>
TURBO = &HC084 -> Variable 0,1,2 R800, 0= Z80, 1&2 = R800, W only, used when xcution<br>
RESULT = &HC085 + 1 -> real result, CPU and EMULAT are based on this result, R only<br>
VDP = &HC06F -> routine to toggle 50/60 hz, X only <br>
<br>
 USAGE: <br>
  10 bload "speedf2.bin"<br>
  20 defusr=&hc000:a=usr(0)<br>
  30 print peek(&hc085)<br>
  30 goto 20<br>
  <br>
  CTRL-STOP to break<br>
  You should see multiple variables on real machine and stable on emulator<b>
  
  
  
  
  </div>
</div>
