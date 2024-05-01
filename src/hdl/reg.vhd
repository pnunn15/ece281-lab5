----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2024 09:35:42 AM
-- Design Name: 
-- Module Name: register - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
    Port ( i_clk : in STD_LOGIC;
           f_Q_next : in STD_LOGIC_VECTOR (7 downto 0);
           i_reset : in STD_LOGIC;
           f_Q : inout STD_LOGIC_VECTOR (7 downto 0));
end reg;

architecture Behavioral of reg is

begin
    
    f_Q <= f_Q_next when i_clk = '1' else
           "00000000" when i_reset = '1' else
           f_Q;

end Behavioral;
