# Exemplos usando a Colorlight i9

Projetos básicos de demonstração para a Colorlight i9 usando ferramentas open-source.

## Toolchain
A toolchain utilizada é a [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build), que integra binários de todas as etapas necessárias:
- Simulação: [Verilator](https://www.veripool.org/verilator/) ou [Icarus Verilog](https://steveicarus.github.io/iverilog/);
- Visualização de waveforms: [GTKWave](https://gtkwave.sourceforge.net/);
- Síntese RTL: [Yosys](https://github.com/YosysHQ/yosys);
- Place and Route: [nextpnr](https://github.com/YosysHQ/nextpnr) e [Project Trellis](https://github.com/YosysHQ/prjtrellis);
- Gravação da FPGA: [ECPDAP](https://github.com/adamgreig/ecpdap). **Obs.** a versão que vem no OSS CAD Suite está linkada com alguma biblioteca que não reconhece a placa no meu SO (Arch), então eu uso o binário do repositório da própria ferramenta;

Além disso, há exemplos utilizando o [LiteX](https://github.com/enjoy-digital/litex), descritos mais abaixo.

## Makefile
Há um `Makefile` padrão para o fluxo Yosys (importa `rules.mk` na raiz) disponível que facilita o trabalho. Os targets básicos são:
- `all`: executa o target `bit`;
- `lint`: executa o linter do Verilator, detecta erros no código mais cedo no processo de compilação;
- `bit`: processo de compilação completo, gera o bitstream na pasta build;
- `prog`: compila tudo e executa a gravação com o ECPDAP;
- `sim`: compila o testbench com o Verilator e roda o executável (gera um `.vcd` e/ou saída na tela);
- `wave`: executa o `sim` e invoca o GTKWave para `build/nome-do-top-level.vcd`.

Obs.: esse Makefile não tem relação com o LiteX

## Padrões
Há alguns padrões para facilitar o uso do Makefile:
- Diretórios:
    - `rtl`: arquivos do design (systemverilog)
    - `tb`: arquivos de testbench (systemverilog)
    - `fpga`: arquivos auxiliares da FPGA (especialmente o `.lpf`)
    - `litex`: definições de SoC usando LiteX (python)
    - `build`: arquivos de saída (ex. o bitstream). Também armazena a saída do LiteX.
- Todos os arquivos de saída terão o nome do TOPLEVEL (definido no Makefile);
- O arquivo `.vcd` deve ser `build/nome-do-toplevel.vcd`. Ex. `$dumpfile("build/blink.vcd")`;

## Instalação do LiteX

O LiteX é uma ferramenta em Python, e o uso dentro de um *venv* (ambiente virtual) costuma ser mais prático. Ele gera os arquivos HDL a partir de scripts Python, mas a síntese lógica e física é feita pela toolchain do OSS-CAD-Suite, que já cria seu próprio ambiente virtual Python.

Para unificar os dois no mesmo ambiente, o ideal é instalar e ativar primeiro o OSS-CAD-Suite e só depois instalar o LiteX.

Com o ambiente do OSS-CAD-Suite instalado e ativado, seguimos a instalação do LiteX:

- Crie uma pasta para conter os arquivos

```sh
mkdir -p litex
```

- Entre na pasta e faça o download do script de setup

```sh
cd litex
wget https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py
``` 

- Execute o script. É importante usar o `python3` pois é o do *env* do OSS-CAD-Suite. Na dúvida confira com `which python3`, deve indicar o caminho do python na pasta onde você instalou o OSS-CAD-Suite. O `--config=full` importa todos os cores disponíveis, o que é útil nesse momento de exploração da ferramenta.

```sh
python3 litex_setup.py --init --install --config=full
```

- Instale também os pacotes `meson` e `ninja`. Garanta que o `pip3` é o do OSS-CAD-Suite.

```sh
pip3 install meson ninja
```

- Por fim, instale a toolchain bare-metal do RISC-V, especialmente o `riscv32-unknown-elf-gcc`, disponível em [riscv-gnu-toolchain](https://github.com/riscv-collab/riscv-gnu-toolchain/releases). Busque instruções de instalação para o seu sistema.

Após a instalação, sempre que o ambiente do OSS-CAD-Suite estiver ativado, o LiteX também estará disponível no Python.

## Exemplos LiteX no repositório

- **Blink/Hellorld**: instância básica do do target `colorlight_i5.py` (configurado para Colorlight i9 v7.2) com um *blink* no led da placa e um [*Hellorld*](https://github.com/Nakazoto/Hellorld/wiki) via terminal serial. O firmware *bare metal* é *baseado* no [demo](https://github.com/enjoy-digital/litex/tree/master/litex/soc/software/demo)
Serve como modelo para como compilar e carregar código em um SoC.

- **Fibonacci**: bloco customizado em hardware descrito em SystemVerilog conectado ao target `colorlight_i5` e usando o barramento CSR. Também demonstra como acessar os blocos em hardware via software com as funções do `csr.h`.
