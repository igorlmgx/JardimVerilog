/*
FUNCTION Sprinkler

A ideia dessa função é fazer o display girar durante um segundo,
retornando a configuração do display sempre que é chamada.

Como são 6 displays que devem ficar acesos, cada um ficará por um intervalo de 0.16666 segundos.

Para a função funcionar, o arquivo deve ser declarado como SystemVerilog no Quartus II:

Files > Properties > HDL Version > SystemVerilog_2005
*/

function[6:0] Sprinkler;

input i; //i é o número de ciclos do clock

begin

	//verifica em qual ciclo o clock está
	//acende um dos segmentos dependendo disso


	if(i == 0)
		Sprinkler = 7'b 0111111; //segmento do meio


	//segmentos externos
	if(i > 0 && i < 8333333)
		Sprinkler = 7'b 1111110;

	if(i >= 8333333 && i < 16666667)
		Sprinkler = 7'b 1111101;

	if(i >= 16666667 && i < 25000000)
		Sprinkler = 7'b 1111011;

	if(i >= 25000000 && i < 33333333)
		Sprinkler = 7'b 1110111;

	if(i >= 33333333 && i < 46666667)
		Sprinkler = 7'b 1101111;

	if(i >= 46666667 && i < 50000000)
		Sprinkler = 7'b 1011111;

end	
endfunction
