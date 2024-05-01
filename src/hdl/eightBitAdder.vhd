----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2024 11:45:17 AM
-- Design Name: 
-- Module Name: 8bitadder - Behavioral
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

entity eightBitAdder is
  Port ( i_A    : in std_logic_vector (7 downto 0);
         i_B    : in std_logic_vector (7 downto 0);
         i_Cin  : in std_logic;
         o_S    : out std_logic_vector (7 downto 0);
         o_Cout : out std_logic
       );
end eightBitAdder;

architecture Behavioral of eightBitAdder is

    component fullAdder is
        Port ( i_A     : in  std_logic;
               i_B     : in  std_logic;
               i_Cin   : in std_logic;
               o_S     : out std_logic;
               o_Cout  : out std_logic
        );
    end component fullAdder;
    
    signal w_C0 : std_logic := '0';
    signal w_C1 : std_logic := '0';
    signal w_C2 : std_logic := '0';
    signal w_C3 : std_logic := '0';
    signal w_C4 : std_logic := '0';
    signal w_C5 : std_logic := '0';
    signal w_C6 : std_logic := '0';
    
begin

    fulladd0_inst : fullAdder
        Port map (
	        i_A    => i_A(0),
	        i_B    => i_B(0),
	        i_Cin  => i_Cin,
	        o_S    => o_S(0),
	        o_Cout => w_C0
	    );
	   
    fulladd1_inst : fullAdder
        Port map (
            i_A    => i_A(1),
            i_B    => i_B(1),
            i_Cin  => w_C0,
            o_S    => o_S(1),
            o_Cout => w_C1
        );
              
    fulladd2_inst : fullAdder
        Port map (
            i_A    => i_A(2),
            i_B    => i_B(2),
            i_Cin  => w_C1,
            o_S    => o_S(2),
            o_Cout => w_C2
        );
        
    fulladd3_inst : fullAdder
        Port map (
            i_A    => i_A(3),
            i_B    => i_B(3),
            i_Cin  => w_C2,
            o_S    => o_S(3),
            o_Cout => w_C3
        );
               
    fulladd4_inst : fullAdder
        Port map (
            i_A    => i_A(4),
            i_B    => i_B(4),
            i_Cin  => w_C3,
            o_S    => o_S(4),
            o_Cout => w_C4
        );
                      
    fulladd5_inst : fullAdder
        Port map (
            i_A    => i_A(5),
            i_B    => i_B(5),
            i_Cin  => w_C4,
            o_S    => o_S(5),
            o_Cout => w_C5
        );

    fulladd6_inst : fullAdder
        Port map (
            i_A    => i_A(6),
            i_B    => i_B(6),
            i_Cin  => w_C5,
            o_S    => o_S(6),
            o_Cout => w_C6
        );
        
    fulladd7_inst : fullAdder
        Port map (
            i_A    => i_A(7),
            i_B    => i_B(7),
            i_Cin  => w_C6,
            o_S    => o_S(7),
            o_Cout => o_Cout
        );
    
end Behavioral;
