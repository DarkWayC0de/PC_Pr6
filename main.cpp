//
// Created by darkwaycode on 19/05/19.
//

#include <iostream>

double comprobar(double base){
  return (base==0.0)?-1:1;
}
double  calculoIT(double base, int exponete){
  double resultado = base;
  for (int i = exponete-1; i >0 ; i--) {
    resultado *=base;
  }
  return resultado;
}
double potenciaIT(double base,int exponente){
  double resultado;
  if (exponente==0){
    resultado = comprobar(base);
  }else{
    if(exponente<0){
      exponente=0-exponente;
      resultado=calculoIT(base,exponente);
      resultado=1/resultado;
    }else{
      resultado=calculoIT(base,exponente);
    }
  }
  return resultado;
}
double potenciaRC(double base,int exponente){
  double resultado;
  if (exponente==0){
    resultado = comprobar(base);
  }else{
    if(exponente<0){
      exponente=0-exponente;
      resultado=potenciaRC(base,exponente);
      resultado = 1/resultado;
    }else{
      exponente-=1;
      resultado=potenciaRC(base,exponente);
      resultado*=base;
    }
  }
  return resultado;
}




int main(void){
  double base,resultado;
  int exponente, selector;
  std::cout<<"Práctica 6 de Principios de computadores. Potencia.\nIntroduzca la base:\t";
  std::cin>>base;
  std::cout<<"Introduzca el exponente:\t";
  std::cin>>exponente;
  std::cout<<"Introzuca 0 para hacerlo iterativo, otro número para recursivo:\t";
  std::cin>>selector;
  if(selector==0){
    resultado=potenciaIT(base,exponente);
  }else{
    resultado=potenciaRC(base,exponente);
  }
  if(resultado!=-1) {
    std::cout << "El resultadoes:\t" << resultado;
  }else{
    std::cout<<"La operación no puede realizarse, es una indeterminación\n";
  }
  return 0;
};
