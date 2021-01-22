#pragma TextEncoding = "Shift_JIS"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function gaussoffset(W,X)
	wave	W;
	variable	X;
	variable	ans;
	ans = W[0] + W[1]*X + W[2]*exp(-((X-W[3])/W[4])^2);
	return	ans;	
end

Function Dualgaussoffset(W,X)
	wave	W;
	variable	X;
	variable	ans;
	ans = W[0] + W[1]*X + W[2]*exp(-((X-W[3])/W[4])^2) + W[5]*exp(-((X-W[6])/W[7])^2);
	return	ans;
end


Function Triplegauss(W,X)
	wave	W;
	variable	X;
	variable	ans;
	ans = W[0]  + W[1]*X + W[2]*exp(-((X-W[3])/W[4])^2) + W[5]*exp(-((X-W[6])/W[7])^2) + W[8]*exp(-((X-W[9])/W[10])^2);
	return	ans;
end

Function Quadruple_gauss(W,X)
	wave	W;
	variable	X;
	variable	ans;
	ans = W[0]  + W[1]*X + W[2]*exp(-((X-W[3])/W[4])^2) + W[5]*exp(-((X-W[6])/W[7])^2) + W[8]*exp(-((X-W[9])/W[10])^2)+ W[11]*exp(-((X-W[12])/W[13])^2);
	return	ans;
end

Function Gauss7(W,X)
	wave	W;
	variable	X;
	variable	ans;
	ans = W[0]  + W[1]*X + W[2]*exp(-((X-W[3])/W[4])^2) + W[5]*exp(-((X-W[6])/W[7])^2) + W[8]*exp(-((X-W[9])/W[10])^2)+ W[11]*exp(-((X-W[12])/W[13])^2)+ W[14]*exp(-((X-W[15])/W[16])^2)+ W[17]*exp(-((X-W[18])/W[19])^2)+W[20]*exp(-((X-W[21])/W[22])^2);
	return	ans;
end



function MakeFitImageMS(frompix, endpix, gausNum, wcoef, zNum)
variable frompix,endpix,gausNum,zNum;
wave wcoef
variable i,j, k,pts;
wave imchi3_data, re_ramanshift2
Variable V_fitOptions=4
variable xNum,yNum
String wavestr
Silent 1; PauseUpdate
print frompix,endpix, gausNum;

make /o/n=23  W_coefQrG
xNum=dimsize(imchi3_data,1);
yNum=dimsize(imchi3_data,2);
pts=dimsize(imchi3_data,0);
make /n=(pts)/o temp

//Single gauss
if (gausNum==1)
	make /O/T/N=1 T_constraint;
	T_constraint = {"K2 > 0"};
	k=0;
	do
		j=0;
		do
			i=0;
			do 
				temp= imchi3_data[p][j][i][k];
				W_coefQrG[0,4]=wcoef[p]
				W_coefQrG[5]=0;
				W_coefQrG[8]=0;
				W_coefQrG[11]=0;
				W_coefQrG[14]=0;
				W_coefQrG[17]=0;
				W_coefQrG[20]=0;
				Funcfit/Q/H="00011111111111111111111"/NTHR=0 Gauss7 W_coefQrG temp[frompix,endpix]/X=re_ramanshift2/D/C=T_constraint;
				wavestr="FitimageZ="+num2str(k)
				make /o/n=(xNum,yNum) $wavestr
				wave tempwv = $wavestr
				SetScale/I x 0,(xNum-1)/2,"", tempwv;
				SetScale/I y 0,(yNum-1)/2,"", tempwv;
				tempwv[j][i]=W_coefQrG[2];
				i+=1;
			while(i<yNum)
			j+=1;
		while(j<xNum)
		display;appendimage $wavestr;
		ModifyGraph width=283.465,height={Aspect,yNum/xNum}
		ModifyImage FitImage ctab= {0,*,Grays,0}	
		k+=1;
	while(k<zNum)
	
	//SetAxis/A/R left;
endif



//Double gauss


end