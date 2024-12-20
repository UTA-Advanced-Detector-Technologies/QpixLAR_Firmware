#include <stdlib.h>
#include <iostream>

#include <verilated.h>
#include <verilated_vcd_c.h>
#include "../obj_dir/VLoader.h"

#define MAX_TIME 6000
vluint64_t sim_time = 0;


// loop control
const int QUEUE_SIZE_ADDR = 0;
const int QUEUE_HEAD_ADDR = 4;

static int packets_sent = 0;


void init(VLoader* const topModule)
{
    // input              clk;
    topModule->clk = 0;
}

int main(int argc, char** argv, char** env)
{
    VerilatedContext* const contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);

    // Construct a VerilatedContext to hold simulation time, etc.
    VLLC_AC_TxMilLoader* const top = new VLLC_AC_TxMilLoader{contextp};
    Verilated::traceEverOn(true);

    // assign defaults
    init(top);

    // Simulate until $finish
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    top->trace(m_trace,5);
    m_trace->open("Loader_waveform.vcd");

    int i = 0;
    int j = 0;
    while (!contextp->gotFinish() and contextp->time() < MAX_TIME) {
        contextp->timeInc(1);
        top->clk = !top->clk;
        ++j;
        if(j==1){
            printf("start loading!\n");
        }

        // pulsed values;
        if(!top->clk)
        {
            // stim
        }

        top->eval();
        m_trace->dump(++i);
    }

    // Final model cleanup
    m_trace->close();
    top->final();

    // Destroy model
    delete top;

    // Return good completion status
    return 0;
}
