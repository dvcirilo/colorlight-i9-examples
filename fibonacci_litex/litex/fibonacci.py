from migen import *
from litex.gen import *
from litex.soc.interconnect.csr import *

class Fibonacci(LiteXModule):
    def __init__(self, platform):

        # importa bloco em hardware
        platform.add_source("rtl/fibonacci.sv")

        # CSRs: entradas e saídas
        self._start = CSRStorage(fields=[
            CSRField("start", size=1, offset=0, pulse=True),  # Sinal start, apenas um pulso
        ])
        self._n = CSRStorage(32, name="n")           
        self._result = CSRStatus(32, name="result")  
        self._busy = CSRStatus(1, name="busy")      

        # sinais internos
        start_sig = Signal()
        n_sig = Signal(32)
        result_sig = Signal(32)
        busy_sig = Signal()

        # instância do módulo systemverilog
        self.specials += Instance("fibonacci",
            i_clk_i=ClockSignal(),
            i_rst_ni=~ResetSignal(),
            i_start_i=start_sig,
            i_n_i=n_sig,
            o_result_o=result_sig,
            o_busy_o=busy_sig
        )

        # mapeamento do csr
        self.comb += [
            start_sig.eq(self._start.fields.start),
            n_sig.eq(self._n.storage),
            self._result.status.eq(result_sig),
            self._busy.status.eq(busy_sig)
        ]
