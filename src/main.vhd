----------------------------------------------------------------------------------
-- Company: VNIE ENTITIES
-- Engineer: Vinayaka Jyothi
-- 
-- Create Date:    18:42:34 04/19/2017 
-- Design Name: Variable_Chain_Ring_Oscillator_Generator
-- Module Name:    RO_GENIE - Structural 
-- Project Name: FPGA Trojan Detection
-- Target Devices: Any FPGA Device
-- Tool versions: ISE, Vivado
-- Description: This file allows to describe a N-stage ring oscillator. 
-- 				 User can change the value of RO_ChainLength in Line 30.
--					 RO needs odd number of elements. RO_ChainLength should be odd.
--					 ENABLE=1 to activate RO--> you get oscillations else RO is deactivated 		
--
-- Dependencies: None
--
-- Revision: 
-- 			Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity PUF is
generic (
            COUNTER_LIMIT : integer := 16; -- bits
            ChainLenght : integer := 5
);
PORT(
    clk: in std_logic;
    reset: in std_logic;
    enable: in std_logic;
    challenge: in std_logic_vector (31 downto 0);
    ready: out std_logic;
    result: out std_logic_vector (127 downto 0)
);
end entity;


architecture rtl of PUF is
    signal partial_ready : std_logic_vector (127 downto 0);
begin


COMP_FOR: for i in 0 to 31 generate

comparator_i_1 : entity work.comparator
    generic map (
            COUNTER_LIMIT => COUNTER_LIMIT,
            ChainLenght => ChainLenght
    )
    port map(
        clk => clk,
        enable => enable,
        ready => partial_ready(i),
        sub_challenge => challenge(7 downto 0),
        comparison => result(i)
    );
    
 comparator_i_2 : entity work.comparator
    generic map (
            COUNTER_LIMIT => COUNTER_LIMIT,
            ChainLenght => ChainLenght
    )
    port map(
        clk => clk,
        enable => enable,
        ready => partial_ready(i + 32),
        sub_challenge => challenge(15 downto 8),
        comparison => result(i + 32)
    );
    
comparator_i_3 : entity work.comparator
    generic map (
            COUNTER_LIMIT => COUNTER_LIMIT,
            ChainLenght => ChainLenght
    )
    port map(
        clk => clk,
        enable => enable,
        ready => partial_ready(i + 64),
        sub_challenge => challenge(23 downto 16),
        comparison => result(i + 64)
    );
    
  comparator_i_4 : entity work.comparator
    generic map (
            COUNTER_LIMIT => COUNTER_LIMIT,
            ChainLenght => ChainLenght
    )
    port map(
        clk => clk,
        enable => enable,
        ready => partial_ready(i + 96),
        sub_challenge => challenge(31 downto 24),
        comparison => result(i + 96)
    );
end generate COMP_FOR;

process(partial_ready)
begin
    ready <= and(partial_ready);
end process;


end architecture;

