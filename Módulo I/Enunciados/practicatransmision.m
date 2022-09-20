%%%%%%           SISTEMA DE TRANSMISION BANDA BASE         %%%%%%


clear all;
close all;

%=================== Parametros ==================================
N=10;		 % Periodo de simbolo
L=10;		 % Numero de bits a transmitir
tipopulso=1; %1: pulso rectangular 
        


%=================== Generacion del pulso =========================

if tipopulso == 1  %pulso rectangular
  n=0:N-1;
  pulso=ones(1,N); 
elseif tipopulso == 2 %escrina un elseif por cda tipo
end;


%=================== Calculo de la energia del pulso =============
%Escriba el codigo para calcular la energia

%=================== Generacion de la senal (modulacion) =========

bits=rand(1,L) < 0.5; %genera 0 y 1 a partir de un vector de numeros 
                      %aleatorios con distribucion uniforme

%Escriba un bucle que asocie un pulso con amplitud positiva a 0 y 
%un pulso con amplitud negativa a 1

%=================== Representacion grafica ===================
figure(1)
plot(n,pulso);
title('Pulso transmitido: p(n)');
grid;
 
figure(2)
%Escriba el codigo para representar la senal 