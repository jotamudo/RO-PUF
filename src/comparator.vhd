----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2023 09:36:40 AM
-- Design Name: 
-- Module Name: comparator - rtl
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator is
    generic(
            COUNTER_LIMIT : integer := 16; -- bits
            ChainLenght : integer := 5
    );
    port (
        clk: in std_logic;
        enable : in std_logic;
        ready : out std_logic;
        sub_challenge: in std_logic_vector (7 downto 0);
        comparison: out std_logic
    );
end comparator;

architecture rtl of comparator is
    type StateType is (idle, reseting, counting, compare);
    signal CurrentState, NextState : Statetype;
    signal counter_out_1 : std_logic_vector (COUNTER_LIMIT - 1 downto 0);
    signal counter_out_2 : std_logic_vector (COUNTER_LIMIT - 1 downto 0);
    signal reset : std_logic;
    signal comb_comparison : std_logic;
    signal comb_ready : std_logic;
    signal internal_enable : std_logic;
begin

Counter_1 : entity work.Counter
    generic map(
            COUNTER_LIMIT => COUNTER_LIMIT, -- counter bits
            ChainLenght => ChainLenght
            )
    port map ( 
           reset => reset,
           enable => internal_enable,
           sub_challenge => sub_challenge(3 downto 0),
           counter => counter_out_1
     );
     
Counter_2 : entity work.Counter
    generic map(
            COUNTER_LIMIT => COUNTER_LIMIT, -- counter bits
            ChainLenght => ChainLenght
            )
    port map ( 
           reset => reset,
           enable => internal_enable,
           sub_challenge => sub_challenge(7 downto 4),
           counter => counter_out_2
     );

process(clk)
begin
    if(rising_edge(clk)) then
        CurrentState <= NextState;
        ready <= comb_ready;
        comparison <= comb_comparison;
    end if;
end process;


process(CurrentState, enable) is
begin
    NextState <= idle;
    comb_ready <= '0';
    comb_comparison <= '0';
    reset <= '0';
    case CurrentState is
        when idle =>
            if enable = '1' then
                internal_enable <= '1';
                NextState <= reseting;
                comb_ready <= '0';
            else
                internal_enable <= '0';
                comb_ready <= '1';
            end if;


        when reseting =>
            internal_enable <= '1'; -- start clock earlier to pass off the wind-up stage of the internal Ring oscillators
            reset <= '1';
            NextState <= counting;


        when counting =>
            internal_enable <= '1';
            reset <= '0';
            NextState <= compare;


        when compare =>
            internal_enable <= '0';
            if counter_out_1 >= counter_out_2 then
                comb_comparison <= '0';
            else
                comb_comparison <= '1';
            end if;
            if enable = '1' then
                NextState <= compare;
            else
                NextState <= idle;
            end if;
     end case;
end process;

end architecture;
