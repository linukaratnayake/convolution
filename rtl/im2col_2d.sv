module im2col_2d
#(
    parameter IMAGE_WIDTH = 20,
    parameter IMAGE_HEIGHT = 20,
    parameter KERNEL_SIZE = 3,
    parameter STRIDE = 1,
    parameter PADDING = 0,
    parameter DATA_WIDTH = 8,
    parameter HORIZONTAL_POSITIONS = (IMAGE_WIDTH - KERNEL_SIZE + 2 * PADDING) / STRIDE + 1,
    parameter VERTICAL_POSITIONS = (IMAGE_HEIGHT - KERNEL_SIZE + 2 * PADDING) / STRIDE + 1,
    parameter OUTPUT_WIDTH = HORIZONTAL_POSITIONS * VERTICAL_POSITIONS,
    parameter OUTPUT_HEIGTH = KERNEL_SIZE * KERNEL_SIZE
)
(
    input logic [0 : IMAGE_HEIGHT - 1][0 : IMAGE_WIDTH - 1][DATA_WIDTH - 1 : 0] image,
    input logic [0 : KERNEL_SIZE - 1][0 : KERNEL_SIZE - 1][DATA_WIDTH - 1 : 0] kernel,
    output logic [0 : OUTPUT_HEIGTH - 1][0 : OUTPUT_WIDTH - 1][DATA_WIDTH - 1:0] output_matrix
);

    always_comb begin
        int offset_x;
        int offset_y;
        int image_y;
        int image_x;
        
        for (int i = 0; i < OUTPUT_HEIGTH; i++) begin
            offset_x = i % KERNEL_SIZE;
            offset_y = (i / KERNEL_SIZE) % KERNEL_SIZE;
            
            for (int j = 0; j < VERTICAL_POSITIONS; j++) begin
                for (int k = 0; k < HORIZONTAL_POSITIONS; k++) begin
                    image_y = j + offset_y;
                    image_x = k + offset_x;
                    
                    if (image_y < IMAGE_HEIGHT && image_x < IMAGE_WIDTH) begin
                        output_matrix[i][j * HORIZONTAL_POSITIONS + k] = image[image_y][image_x];
                    end else begin
                        output_matrix[i][j * HORIZONTAL_POSITIONS + k] = '0;
                    end
                end
            end
        end
    end

endmodule
