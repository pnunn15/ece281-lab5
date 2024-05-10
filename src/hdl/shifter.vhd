----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2024 11:05:12 AM
-- Design Name: 
-- Module Name: shifter - Behavioral
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

entity shifter is
  Port ( i_A : in std_logic_vector (7 downto 0);
         i_B : in std_logic_vector (7 downto 0);
         i_LorR : in std_logic;
         o_result : out std_logic_vector (7 downto 0)
  );
end shifter;

architecture Behavioral of shifter is
    signal w_sLeft : std_logic_vector (7 downto 0) := "00000000";
    signal w_sRight : std_logic_vector (7 downto 0) := "00000000";
begin
    w_sLeft <= std_logic_vector(shift_left(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0)))));
    w_sRight <= std_logic_vector(shift_right(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0)))));
    
    -- MUX ---------------------------------
    o_result <= w_sLeft when i_LorR = '0' else
                w_sRight;

end Behavioral;
