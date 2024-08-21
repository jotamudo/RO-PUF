----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/01/2023 09:19:56 AM
-- Design Name: 
-- Module Name: bidirectional_buffer - rtl
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

entity bidirectional_buffer is
  port(
    T : in std_logic;
    I : in std_logic;
    O_NEW : out std_logic;
    IO : inout std_logic
  );
end bidirectional_buffer;

architecture rtl of bidirectional_buffer is
begin
  IO <= I when T = '1' else 'Z';
  O_NEW <= IO;
end rtl;
