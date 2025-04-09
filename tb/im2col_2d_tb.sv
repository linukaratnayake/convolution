`timescale 1ns/1ps

module im2col_2d_tb;
    // Parameters for test bench
    localparam IMAGE_WIDTH = 4;
    localparam IMAGE_HEIGHT = 4;
    localparam KERNEL_SIZE = 2;
    localparam STRIDE = 1;
    localparam PADDING = 0;
    localparam DATA_WIDTH = 8;
    localparam HORIZONTAL_POSITIONS = (IMAGE_WIDTH - KERNEL_SIZE + 2 * PADDING) / STRIDE + 1;
    localparam VERTICAL_POSITIONS = (IMAGE_HEIGHT - KERNEL_SIZE + 2 * PADDING) / STRIDE + 1;
    localparam OUTPUT_WIDTH = HORIZONTAL_POSITIONS * VERTICAL_POSITIONS;
    localparam OUTPUT_HEIGTH = KERNEL_SIZE * KERNEL_SIZE;
    
    // Define signals
    logic [0 : IMAGE_HEIGHT - 1][0 : IMAGE_WIDTH - 1][DATA_WIDTH - 1 : 0] image;
    logic [0 : KERNEL_SIZE - 1][0 : KERNEL_SIZE - 1][DATA_WIDTH - 1 : 0] kernel;
    logic [0 : OUTPUT_HEIGTH - 1][0 : OUTPUT_WIDTH - 1][DATA_WIDTH - 1:0] image_im2col;
    logic [0 : KERNEL_SIZE * KERNEL_SIZE - 1][DATA_WIDTH - 1:0] kernel_im2col;
    
    // Instantiate the im2col_2d module
    im2col_2d #(
        .IMAGE_WIDTH(IMAGE_WIDTH),
        .IMAGE_HEIGHT(IMAGE_HEIGHT),
        .KERNEL_SIZE(KERNEL_SIZE),
        .STRIDE(STRIDE),
        .PADDING(PADDING),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .image(image),
        .kernel(kernel),
        .image_im2col(image_im2col),
        .kernel_im2col(kernel_im2col)
    );
    
    initial begin
        // Set up waveform dump
        $dumpfile("im2col_2d_tb.vcd");
        $dumpvars(0, im2col_2d_tb);
        
        // Initialize inputs - 4x4 image with sequential values
        image = '{
            '{ 8'd1,  8'd2,  8'd3,  8'd4  },
            '{ 8'd5,  8'd6,  8'd7,  8'd8  },
            '{ 8'd9,  8'd10, 8'd11, 8'd12 },
            '{ 8'd13, 8'd14, 8'd15, 8'd16 }
        };
        
        // Initialize kernel - 2x2 kernel
        kernel = '{
            '{ 8'd1, 8'd2 },
            '{ 8'd3, 8'd4 }
        };
        
        // Display input image
        $display("Input Image (4x4):");
        for (int i = 0; i < IMAGE_HEIGHT; i++) begin
            for (int j = 0; j < IMAGE_WIDTH; j++) begin
                $write("%d\t", image[i][j]);
            end
            $display("");
        end
        
        // Display kernel
        $display("\nKernel (2x2):");
        for (int i = 0; i < KERNEL_SIZE; i++) begin
            for (int j = 0; j < KERNEL_SIZE; j++) begin
                $write("%d\t", kernel[i][j]);
            end
            $display("");
        end
        
        #10; // Allow some time for combinational logic to settle
        
        // Display image_im2col matrix
        $display("\nImage im2col Matrix (%0d rows x %0d columns):", OUTPUT_HEIGTH, OUTPUT_WIDTH);
        for (int i = 0; i < OUTPUT_HEIGTH; i++) begin
            for (int j = 0; j < OUTPUT_WIDTH; j++) begin
                $write("%d\t", image_im2col[i][j]);
            end
            $display("");
        end
        
        // Display kernel_im2col vector
        $display("\nKernel im2col (flattened 1x%0d vector):", KERNEL_SIZE * KERNEL_SIZE);
        for (int i = 0; i < KERNEL_SIZE * KERNEL_SIZE; i++) begin
            $write("%d\t", kernel_im2col[i]);
        end
        $display("");
        
        #10 $finish;
    end
endmodule
