module logica (amanhecer, anoitecer, controle, LEDG, LEDR, HEX0, CLOCK_50);

//CLOCK_50 é um pino da placa igual os pinos SW e HEX
//trabalha com uma frequência de 50MHz

//LEMBRETE: 50MHz significa 50mi de ciclos por segundo

input amanhecer, anoitecer, controle, CLOCK_50;
output reg[6:0] HEX0;
output LEDG, LEDR;
reg[1:0] estado;
reg LEDG, LEDR;


//ciclos será uma variável de controle
//mesma ideia de for(ciclos = 0; ciclos < 10; ciclos++)
integer ciclos = 0;
integer segundos = 0; //contador de segundos

//definiçao dos estados
parameter Desligado = 2'b 00, Liga30 = 2'b 01, Liga60 = 2'b 10;

//inicia o sistema de irrigação desligado
initial estado = Desligado;

always @(posedge CLOCK_50) begin

	case (estado)

		Desligado : begin

			LEDG = 0;
			LEDR = 1; //led vermelho com sistema desligado

			//como o clock não se altera aqui, ciclos sempre será 0
			//o display ficara aceso apenas no meio
			HEX0 = Sprinkler(ciclos);


			//utilizamos o botão KEY da placa
			//o valor ativo do botão é 0, por isso if cond == 0
			if(anoitecer == 0 || controle == 0)
				estado = Liga60;

			if(amanhecer == 0)
				estado = Liga30;

		end

		//liga o sistema por 3 segundos
		Liga30 : begin

			LEDG = 1; //led verde com sistema ligado
			LEDR = 0;


			//verifica cada ciclo do clock
			if(CLOCK_50 == 1'b 1) begin


				//a funçao Sprinkler retorna como o display será aceso
				//deve ser atualizada constantemente para o movimento funcionar
				HEX0 = Sprinkler(ciclos);

				//incrementa um ciclo
				ciclos = ciclos + 1;


				//se chegou em 50mi de ciclos, aumenta um segundo
				if(ciclos == 50000000) begin
					segundos = segundos + 1;
					ciclos = 0;
				end


				//sai do estado se o controle é acionado
				//zera o ciclo e os segundos
				if(controle == 0) begin
					estado = Desligado;
					ciclos = 0;
					segundos = 0;
				end


				//se atingiu 3 segundos, desliga o irrigador e zera tudo
				if(segundos == 3) begin
					estado = Desligado;
					ciclos = 0;
					segundos = 0;
				end
				
			end
		end


		//liga o sistema de irrigação por 6 segundos
		Liga60 : begin

			LEDG = 1;
			LEDR = 0;

			if(CLOCK_50 == 1'b 1) begin


				HEX0 = Sprinkler(ciclos);

				ciclos = ciclos + 1;


				if(ciclos == 50000000) begin
					segundos = segundos + 1;
					ciclos = 0;
				end


				if(controle == 0) begin
					estado = Desligado;
					ciclos = 0;
					segundos = 0;
				end


				//desliga o sistema após 6 segundos
				if(segundos == 6) begin
					estado = Desligado;
					ciclos = 0;
					segundos = 0;
				end
			end
		end

		default : estado = Desligado;

	endcase

end

endmodule


module Jardim (KEY, LEDG, LEDR, CLOCK_50, HEX0);

input[2:0] KEY;
input CLOCK_50;
output[0:0] LEDR;
output[7:7] LEDG;
output[6:0] HEX0;

logica l (KEY[2], KEY[1], KEY[0], LEDG[7], LEDR[0], HEX0, CLOCK_50);

endmodule
