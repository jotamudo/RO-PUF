----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.11.2023 14:46:04
-- Design Name: 
-- Module Name: Counter - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter is
    generic(
            COUNTER_LIMIT : integer := 16; -- bits
            ChainLenght : integer := 5
            );
    Port ( reset: in std_logic; -- reset input
           enable : in std_logic;
           sub_challenge: in std_logic_vector (3 downto 0); 
           counter: out std_logic_vector(COUNTER_LIMIT - 1 downto 0) -- output 4-bit counter
     );
end Counter;

architecture Behavioral of Counter is
    signal counter_up: unsigned(COUNTER_LIMIT - 1 downto 0);
    signal clk : std_logic;
begin

RO_MUX : entity work.mux_p
    generic map(ChainLenght => ChainLenght)
    port map(
        s => sub_challenge,
        enable => enable,
        y => clk
    );

-- up counter
process(clk)
begin
if(rising_edge(clk)) then
    if(reset='1') then
         counter_up <= x"0000";
    else
         counter_up <= counter_up + x"0001";
    end if;
 end if;
end process;
counter <= std_logic_vector(counter_up);

end Behavioral;
