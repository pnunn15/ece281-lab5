----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/25/2024 08:48:09 PM
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
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
    use ieee.numeric_std.all;

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture Behavioral of controller_fsm is
    type sm_state is (s_0, s_1, s_2, s_3);
    signal f_Q, f_Q_next : sm_state;

begin

    -- CONCURRENT STATEMENTS ------------------------------------------------------------------------------
	-- Next State Logic
    f_Q_next <= s_0 when (f_Q = s_0 and i_adv = '0') else
                s_0 when (f_Q = s_3 and i_adv = '1') else
                s_1 when (f_Q = s_1 and i_adv = '0') else
                s_1 when (f_Q = s_0 and i_adv = '1') else
                s_2 when (f_Q = s_2 and i_adv = '0') else
                s_2 when (f_Q = s_1 and i_adv = '1') else
                s_3 when (f_Q = s_3 and i_adv = '0') else
                s_3 when (f_Q = s_2 and i_adv = '1') else
                s_0 when (i_reset = '1') else
                f_Q; -- default case: stay
	-- Output logic
     with f_Q select
        o_cycle <= "0111" when s_0,
                   "1011" when s_1,
                   "1101" when s_2,
                   "1110" when s_3,
                   "0111" when others; -- default is s_0
                   
                   
    register_proc : process (i_adv)
                       begin
                           if (i_reset = '1') then
                               f_Q <= s_0;
                           elsif (rising_edge(i_adv)) then
                               f_Q <= f_Q_next;
                           else
                               f_Q <= f_Q;
                           end if;
                       end process register_proc;    
end Behavioral;
