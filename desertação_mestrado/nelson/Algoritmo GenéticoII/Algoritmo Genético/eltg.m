[x1 y1]=pol2cart(acos(0.8),18e3);
S1=x1+j*y1;
[x2 y2]=pol2cart(acos(0.7),10e3);
S2=x2+j*y2;
S3=10e3;
[x4 y4]=pol2cart(acos(0.6),16e3);
S4=x4+j*y4;
S=S1+S2+S3+S4;
I1=S1/(sqrt(3)*280);
I2=S2/(sqrt(3)*280);
I3=S3/(sqrt(3)*280);
I4=S4/(sqrt(3)*280);
I=real(I1)-j*imag(I1)+real(I2)-j*imag(I2)+real(I3)-j*imag(I3)+real(I4)-j*imag(I4)