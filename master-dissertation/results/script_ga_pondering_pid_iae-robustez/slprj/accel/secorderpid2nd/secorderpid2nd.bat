@echo off
set MATLAB=D:\Program Files\Matlab R2020a

call  "\\itrack-desktop\D$\Program Files\Matlab R2020a\bin\win64\checkMATLABRootForDriveMap.exe" "\\itrack-desktop\D$\Program Files\Matlab R2020a"  > mlEnv.txt
for /f %%a in (mlEnv.txt) do set "%%a"\n
"%MATLAB%\bin\win64\gmake" -f secorderpid2nd.mk MATLAB_ROOT=%MATLAB_ROOT% ALT_MATLAB_ROOT=%ALT_MATLAB_ROOT% MATLAB_BIN=%MATLAB_BIN% ALT_MATLAB_BIN=%ALT_MATLAB_BIN%  OPTS="-DTID01EQ=0"
