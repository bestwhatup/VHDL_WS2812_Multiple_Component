library ieee;
use ieee.std_logic_1164.all;

entity tb_Lab1_2_com is
end tb_Lab1_2_com;

architecture testbench of tb_Lab1_2_com is
	component Lab1_2_com is
		port (
				CLK	 : in std_logic;
				RST_B  : in std_logic;
				PB 	 : in std_logic;
				Number_Led_input : in std_logic_vector(3 downto 0);
				DATA 	 : out std_logic
				);	
	end component;
	
	signal t_CLK	 : std_logic;
	signal t_RST_B  : std_logic;
	signal t_PB		 : std_logic;
	signal t_Number_Led_in : std_logic_vector(3 downto 0);
	signal t_DATA	 : std_logic;
	
begin
	DUT: Lab1_2_com port map(CLK => t_CLK,RST_B => T_RST_B,PB => t_PB, Number_Led_input => t_Number_Led_in ,DATA => t_DATA);
	process
		begin
			t_CLK <= '0';
			wait for 10 ns;
			t_CLK <= '1';
			wait for 10 ns;
	end process;
	
	process
		variable state : natural := 0;
	begin
		t_RST_B <= '1';
		wait for 100 ns;
		t_PB <= '1';
		
		wait for 70 us;
		
		case state is
			when 0 =>
				t_PB <= '0'; wait for 100 ns;
				t_PB <= '1'; wait for 100 ns;
				state := 1;
			when 1 =>
				t_Number_Led_in <= "0001"; wait for 100 ns;
				t_PB <= '0'; wait for 100 ns;
				t_PB <= '1'; wait for 100 ns;
				state := 2;
			when 2 =>
				t_Number_Led_in <= "0010"; wait for 100 ns;
				t_PB <= '0'; wait for 100 ns;
				t_PB <= '1'; wait for 100 ns;
				state := 3;
				wait for 70 us;
			when 3 =>
				t_Number_Led_in <= "0011"; wait for 100 ns;
				t_PB <= '0'; wait for 100 ns;
				t_PB <= '1'; wait for 100 ns;
				state := 4;
				wait for 70 us;
			when 4 =>
				t_Number_Led_in <= "0100"; wait for 100 ns;
				t_PB <= '0'; wait for 100 ns;
				t_PB <= '1'; wait for 100 ns;
				state := 5;
				wait for 70 us;
			when 5 =>
				t_RST_B <= '0'; wait for 100 ns;
				t_RST_B <= '1'; wait for 100 ns;
				state := 6;
			when others => null;
		end case;
	end process;
end testbench;