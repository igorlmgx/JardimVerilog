module logica (amanhecer, anoitecer, controle, LEDG, LEDR, display, CLOCK_50);

//CLOCK_50 eh um pino da placa igual os pinos SW e HEX
//trabalha com uma frequencia de 50MHz

input amanhecer, anoitecer, controle, CLOCK_50;
output display, LEDG, LEDR;
reg[1:0] estado;
reg[4:0] entrada;
reg LEDG, LEDR;

//index sera uma variavel de contador
//funciona igual logica de programacao
integer index = 0;

parameter Desligado = 2'b 00, Liga30 = 2'b 01, Liga60 = 2'b 10;

initial estado = Desligado;

//clock deve ser iniciado aqui
always @(posedge CLOCK_50) begin

 case (estado)
  
  Desligado : begin
   
   LEDG = 0;
   LEDR = 1;
   
   if(anoitecer == 0 || controle == 0)
    estado = Liga60;
   
   if(amanhecer == 0)
    estado = Liga30;
   
  end
  
  
  Liga30 : begin
   
   LEDG = 1;
   LEDR = 0;
   
   //conta cada pulso do clock
   if(CLOCK_50 == 1'b 1) begin

    //incrementa o index
    index = index + 1;
    
    //verifica se o controle nao foi acionado no meio do processo
    if(controle == 0) begin
    
     //desliga o irrigador
     estado = Desligado;
     
     //zera o index
     index = 0;
     
    end
    
    //se o index atingiu 150 milhoes, passaram-se 3 segundos (frequencia de 50MHz)
    if(index == 150000000) begin
    
     //desliga irrigador
     estado = Desligado;
     
     //SEMPRE deve-se zerar o contador antes de sair do estado
     index = 0;
     
    end
    
   end
  end
  
  
  Liga60 : begin
   
   LEDG = 1;
   LEDR = 0;
   
   if(CLOCK_50 == 1'b 1) begin
   
    index = index + 1;
    
    if(controle == 0) begin
     estado = Desligado;
     index = 0;
    end
    
    if(index == 300000000) begin
     estado = Desligado;
     index = 0;
    end
    
   end
  end
  
  default : estado = Desligado;
  
 endcase
 
end

endmodule


module Jardim (KEY, LEDG, LEDR, CLOCK_50);

input[2:0] KEY;
input CLOCK_50; //lembre-se de IMPORTAR o pino CLOCK_50
output[0:0] LEDR;
output[7:7] LEDG;

logica l (KEY[2], KEY[1], KEY[0], LEDG[7], LEDR[0], CLOCK_50);

endmodule
