# Exemplos usando a Colorlight i9

Exemplos simples apenas para demonstrar o uso da toolchain e conceitos básicos de SystemVerilog com a "placa de desenvolvimento" Colorlight i9.

## Toolchain
A toolchain utilizada é a [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build), que integra binários de todas as etapas necessárias:
- Simulação: [Verilator](https://www.veripool.org/verilator/) ou [Icarus Verilog](https://steveicarus.github.io/iverilog/);
- Visualização de waveforms: [GTKWave](https://gtkwave.sourceforge.net/);
- Síntese RTL: [Yosys](https://github.com/YosysHQ/yosys);
- Place and Route: [nextpnr](https://github.com/YosysHQ/nextpnr) e (Project Trellis)[https://github.com/YosysHQ/prjtrellis];
- Gravação da FPGA: [ECPDAP](https://github.com/adamgreig/ecpdap). **Obs.** a versão que vem no OSS CAD Suite está linkada com alguma biblioteca que não reconhece a placa no meu SO (Arch), então eu uso o binário do repositório da própria ferramenta;

## Makefile
Há um `Makefile` padrão (importa `rules.mk` na raiz) disponível que facilita o trabalho. Os targets básicos são:
- `all`: executa o target `bit`;
- `lint`: executa o linter do Verilator, detecta erros no código mais cedo no processo de compilação;
- `bit`: processo de compilação completo, gera o bitstream na pasta build;
- `prog`: compila tudo e executa a gravação com o ECPDAP;
- `sim`: compila o testbench com o Verilator e roda o executável (gera um `.vcd` e/ou saída na tela);
- `wave`: executa o `sim` e invoca o GTKWave para `out.vcd`.

## Padrões
Há alguns padrões para facilitar o uso do Makefile:
- Diretórios:
    - `rtl`: arquivos do design
    - `tb`: arquivos de testbench
    - `fpga`: arquivos auxiliares da FPGA (especialmente o `.lpf`)
    - `build`: arquivos de saída (ex. o bitstream)
- Todos os arquivos de saída terão o nome do TOPLEVEL (definido no Makefile);
- O arquivo `.vcd` deve ser `build/nome-do-toplevel.vcd`. Ex. `$dumpfile("build/blink.vcd")`;
