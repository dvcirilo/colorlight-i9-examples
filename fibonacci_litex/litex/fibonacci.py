from migen import Module, Signal, Instance, ClockSignal, ResetSignal
from litex.soc.interconnect.csr import AutoCSR, CSRStorage, CSRStatus, CSR

class Fibonacci(Module, AutoCSR):
    def __init__(self, platform):
        # adiciona o source SystemVerilog
        platform.add_source("rtl/fibonacci.sv")

        # CSRs: entradas e saídas
        self._start  = CSR()   # inicia cálculo
        self._n      = CSRStorage(32, name="n")       # índice Fibonacci
        self._result = CSRStatus(32, name="result")   # resultado
        self._busy   = CSRStatus(1,  name="busy")     # busy flag

        # sinais internos
        start_sig  = Signal()
        n_sig      = Signal(32)
        result_sig = Signal(32)
        busy_sig   = Signal()

        # instância do módulo SystemVerilog
        self.specials += Instance("fibonacci",
                                  i_clk=ClockSignal(),
                                  i_rst=ResetSignal(),
                                  i_start=start_sig,
                                  i_n=n_sig,
                                  o_result=result_sig,
                                  o_busy=busy_sig)

        # mapeamento CSRs <-> sinais
        self.comb += [
            start_sig.eq(self._start.re),
            n_sig.eq(self._n.storage),
            self._result.status.eq(result_sig),
            self._busy.status.eq(busy_sig)
        ]
