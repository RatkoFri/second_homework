`timescale 1ns/1ps
`include "spi.sv"

module spiModule_tb;

    // Testbench signals
    logic clk;
    logic rst;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic spi_miso;
    logic test_signal;
    logic start;
    logic [15:0] limit;
    logic spi_clk;
    logic spi_mosi;
    logic done;
    logic prev_signal;
    // Simulate SPI MISO behavior
    logic [7:0] miso_reg = 8'b00101111; // Example MISO data
    int i = 0;

    // DUT instantiation
    spiModule dut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out),
        .spi_miso(spi_miso),
        .start(start),
        .limit(limit),
        .spi_clk(spi_clk),
        .spi_mosi(spi_mosi),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Task to trigger on posedge of spi_clk
    
    always_ff @(posedge clk) begin
        if (rst) begin
            spi_miso <= 1'b0; // Reset MISO to low
            prev_signal <= 1'b1; // Reset MISO to low
        end else begin
            prev_signal <= spi_clk; // Store the previous state of spi_clk
            if (prev_signal && !spi_clk) begin
                spi_miso <= miso_reg[7-i]; // Assign MISO data from the register
                i = i + 1; // Increment index for next bit
                if (i == 8) begin
                    i = 0; // Reset index after sending 8 bits
                end
            end 
        end
    end


    // Test sequence
    initial begin
        // Initialize inputs
        $dumpfile("spi_tb.vcd");
        $dumpvars(0, spiModule_tb);
        // Initialize signals
  
        rst = 1;
        start = 0;
        data_in = 8'b10101010; // Example input data
        limit = 16'd4; // Example limit for clock ticks
        miso_reg = 8'b00101110; 
        // Apply reset
        #20;
        rst = 0;

        // Wait for a few clock cycle
        
        // Test 1: Start SPI transaction
        $display("Starting SPI transaction...");
        start = 1;
        #10;
        start = 0;

        // Wait for the transaction to complete
        wait (done);
        $display("SPI transaction completed at time %0t.", $time);

        // Test 2: Another SPI transaction with different data
        #50;
        $display("Starting another SPI transaction...");
        data_in = 8'b11001100; // New input data
        start = 1;
        #10;
        start = 0;

        // Wait for the transaction to complete
        wait (done);
        $display("Second SPI transaction completed at time %0t.", $time);

        // End simulation
        $finish;
    end

    

endmodule

