%%%%%%           SISTEMA DE TRANSMISION BANDA BASE         %%%%%%


clear all;
close all;

%=================== Funciones ==================================

function diagramaojo(senal,N,L)
%Representacion del diagrama de ojo

figure;
hold on;
S=(2*N);
T=floor(L/2)+mod(L,2)-1;
for i=1:T
  dib=senal(1,(((2*N)*(i-1))+1):((2*N*i)+1));
  ejex2=0:S;
  plot(ejex2,dib);
endfor
end

function [H,W]=dtft(h,N)

%DTFT	calculate DTFT at N equally spaced frequencies
%	usage: [H,W]=dtft(h,N);
%	h: finite-length input vector, whose length is L
%	N: number of frequencies for evaluation over [-pi,pi]
%		==> constraint: N>=L
%
%	H: DTFT values (complex)
%	W: vector of freqs where DTFT is computed
%
N=fix(N);
L=length(h);
h=h(:);		%<-- for vectors ONLY %
if (N<L)
	error('DTFT: # data samples cannot exceed # freq samples')
end
W=(2*pi/N) * [0:(N-1)]';
mid=ceil(N/2)+1;
W(mid:N)=W(mid:N)-2*pi;		%<-- move [pi,2pi] to [-pi,0]
W=fftshift(W);
H=fftshift(fft(h,N));		%<-- move negative freq components

end

%=================== Parametros ==================================
N=10;		 % Periodo de simbolo
L=10;		 % Numero de bits a transmitir
tipopulso=1; %1: pulso rectangular
EbNo=100 ; % EbNo en dB
W=pi/2; % Ancho de banda del canal


%=================== Generacion del pulso =========================

n=0:N-1;
pulso=zeros(1,N);

if tipopulso == 1  %pulso rectangular
  pulso(:) = 1;
elseif tipopulso == 2 %escrina un elseif por cda tipo
  pulso(1:N/2) = 1;
elseif tipopulso == 3
  pulso(1:N/2) = 1;
  pulso(N/2:end) = -1;
elseif tipopulso == 4
  pulso=linspace(0,1,N);
end;


%=================== Calculo de la energia del pulso =============
%Escriba el codigo para calcular la energia

Ep = sum(abs(pulso).^2)
%Ep = pulso * pulso.'

%=================== Generacion de ruido ==========================

%Cambio a unidades naturales y calculo de No
Eb = Ep;

EbNo=10^(EbNo/10);
No=Eb/EbNo;
ruido=sqrt(No/2)*randn(1,N*L);

%=================== Generacion del canal de banda limitada =========

NL2=fix(N*L/2);
n2=-NL2:NL2-1;
h=sin(W*n2)./(pi*n2);
pos=find(n2==0);
h(pos)=W/pi;
if (pi/N)>W
  h=h*pi/W/N;
end;

%=================== Generacion de la senal (modulacion) =========

bits=rand(1,L) < 0.5; %genera 0 y 1 a partir de un vector de numeros
                      %aleatorios con distribucion uniforme

%Escriba un bucle que asocie un pulso con amplitud positiva a 0 y
%un pulso con amplitud negativa a 1

s_mod = [];
for i = 1:L
  Ai = 1 - 2*bits(i);
  s_mod = [s_mod, pulso*Ai];
end

%s_rec=s_mod+ruido;

s_rec=conv(s_mod,h);
s_rec=s_rec(NL2+1:length(s_rec)-NL2+1);
ruido=sqrt(No/2)*rand(1,N*L);
s_rec=s_rec+ruido;

%=================== Representacion grafica ===================
figure(1)
plot(n,pulso);
title('Pulso transmitido: p(n)');
grid;

%Escriba el codigo para representar la senal
figure;
plot(0:N*L-1,s_mod);
hold on;
plot(0:N*L-1,s_rec,'r');
axis([0 N*L-1 -2 2]);
title('Senal modulada y recibida')

diagramaojo(s_rec,N,L)

%Calcular y representar la transformada de Fourier del pulso y canal

[H,Wrad]=dtft(h,(2*L*N)+50);
[P,Wrad]=dtft(pulso,(2*L*N)+50);
figure;
plot(Wrad,abs(P)/max(abs(P)));
grid;
hold on;
plot(Wrad,abs(H)/max(abs(H)),'r');
title('Respuesta en frecuencia del canal H(W) y T.F. del pulso P(W)');

