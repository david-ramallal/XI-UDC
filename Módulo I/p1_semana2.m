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

%=================== Parametros ==================================
N=10;		 % Periodo de simbolo
L=10;		 % Numero de bits a transmitir
tipopulso=1; %1: pulso rectangular
EbNo=100 ; % EbNo en dB



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

%Cambio a unidades naturales y calculo de No
Eb = Ep;

EbNo=10^(EbNo/10);
No=Eb/EbNo;
ruido=sqrt(No/2)*randn(1,N*L);

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

s_rec=s_mod+ruido;

%=================== Representacion grafica ===================
figure(1)
plot(n,pulso);
title('Pulso transmitido: p(n)');
grid;

%Escriba el codigo para representar la senal
figure(2)
plot(s_mod, 'LineWidth', 2);
title('Señal modulada y recibida');
hold on;
plot(s_rec, 'LineWidth', 2);
grid;

diagramaojo(s_rec,N,L)

