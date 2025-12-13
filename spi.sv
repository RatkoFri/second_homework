module spiModule (
    input logic clk,
    input logic rst,
    input logic [7:0] data_in,
    input logic spi_miso,
    input logic start,
    input [15:0] limit,
    output logic spi_clk,
    output logic spi_mosi,
    output logic done,
    output logic [7:0] data_out
);




    // state machine states
    typedef enum logic [1:0] {
        IDLE,
        READ,
        WRITE
    } state_t;
    state_t current_state, next_state;


    logic done_next, spi_clok_next, spi_mosi_next;
    logic [15:0] clk_tick_counter, clk_tick_counter_next;
    logic [3:0] symbol_counter, symbol_counter_next;
    logic [7:0] shift_regI, shift_regI_next;
    logic [7:0] shift_regO, shift_regO_next;

    
endmodule