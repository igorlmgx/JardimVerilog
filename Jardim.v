module logica (amanhecer, anoitecer, controle, LEDG, LEDR, HEX0, CLOCK_50);

//CLOCK_50 é um pino da placa igual os pinos SW e HEX
//trabalha com uma frequência de 50MHz

//LEMBRETE: 50MHz significa 50mi de ciclos por segundo

input amanhecer, anoitecer, controle, CLOCK_50;
output HEX0, LEDG, LEDR;
reg[1:0] estado;
reg LEDG, LEDR;

//index será uma variável de controle
//mesma ideia de for(index = 0; index < 10; index++)
integer index = 0;
integer indexSpin = 50000000; //para poder ligar o spinner no primeiro ciclo

//in será uma variável de controle para spinner,
//a função que fará o display girar ou ficar parado
reg in = 0;

parameter Desligado = 2'b 00, Liga30 = 2'b 01, Liga60 = 2'b 10;

//inicia o sistema de irrigação desligado
initial estado = Desligado;

always @(posedge CLOCK_50) begin

	case (estado)

		Desligado : begin

			LEDG = 0;
			LEDR = 1; //led vermelho com sistema desligado
			in = 0; //spinner desligado (aceso no meio)

			//deixa o display aceso apenas no meio (parado)
			Spinner(CLOCK_50, in, HEX0);

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
			in = 1; //spinner ligado (girando)

			//faz o display rodar
			Spinner(CLOCK_50, in, HEX0);


			//verifica cada ciclo do clock
			if(CLOCK_50 == 1'b 1) begin


				//faz o display girar por um segundo quando o clock atinge 50mi
				if(indexSpin == 50000000) begin
					Spinner(CLOCK_50, in, HEX0);
					indexSpin = 0;
				end

				indexSpin = indexSpin + 1;

				//enquanto index não atingir 150mi de ciclos (3 segundos)
				//incrementa index e não sai do estado

				index = index + 1;

				//sai do estado se o controle é acionado
				//zera o index
				if(controle == 0) begin
					estado = Desligado;
					index = 0;
				end



				//se atingiu 150mi, desliga o irrigador e zera o index
				if(index == 150000000) begin
					estado = Desligado;
					index = 0;
				end
				
			end
		end


		//liga o sistema de irrigação por 6 segundos
		Liga60 : begin

			LEDG = 1;
			LEDR = 0;
			in = 1;


			if(CLOCK_50 == 1'b 1) begin


				if(indexSpin == 50000000) begin
					Spinner(CLOCK_50, in, HEX0);
					indexSpin = 0;
				end


				indexSpin = indexSpin + 1;
				index = index + 1;


				if(controle == 0) begin
					estado = Desligado;
					index = 0;
				end

				//desliga o sistema após 300mi ciclos (6 segundos)
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
input CLOCK_50;
output[0:0] LEDR;
output[7:7] LEDG;

logica l (KEY[2], KEY[1], KEY[0], LEDG[7], LEDR[0], CLOCK_50);

endmodule
