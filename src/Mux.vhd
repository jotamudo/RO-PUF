library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_p is
    generic (ChainLenght: integer := 5);
    Port ( s : in std_logic_vector(3 downto 0);
           enable : in std_logic;
           y : out std_logic);
end mux_p;

architecture mux of mux_p is
    signal ro_out : std_logic_vector(15 downto 0);
begin

    RO_FOR: for i in 0 to 15 generate
    begin
        RO_GENIE_i : entity work.RO_GENIE
        generic map(RO_ChainLength => ChainLenght)
        port map(
            ENABLE => enable,
            RO_OSC_OUT => ro_out(i)
        );
    end generate RO_FOR;

    process(ro_out,s)
    begin
    if(s="0000")then
      y<=ro_out(0);
     elsif(s="0001")then
      y<=ro_out(1);
    elsif(s="0010")then
      y<=ro_out(2);
    elsif(s="0011")then
      y<=ro_out(3);
    elsif(s="0100")then
      y<=ro_out(4);
    elsif(s="0101")then
      y<=ro_out(5);
    elsif(s="0110")then
      y<=ro_out(6);
    elsif(s="0111")then
      y<=ro_out(7);
    elsif(s="1000")then
      y<=ro_out(8);
    elsif(s="1001")then
      y<=ro_out(9);
    elsif(s="1010")then
      y<=ro_out(10);
    elsif(s="1011")then
      y<=ro_out(11);
    elsif(s="1100")then
      y<=ro_out(12);
    elsif(s="1101")then
      y<=ro_out(13);
    elsif(s="1110")then
      y<=ro_out(14);
  else
      y<=ro_out(15);
  end if ;
  end process ;
end mux; 

