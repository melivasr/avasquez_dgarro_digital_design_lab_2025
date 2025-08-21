-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 20.1.0 Build 711 06/05/2020 SJ Lite Edition"

-- DATE "08/14/2025 17:39:18"

-- 
-- Device: Altera 5CSXFC6D6F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	full_subtractor_4bit IS
    PORT (
	A : IN std_logic_vector(3 DOWNTO 0);
	B : IN std_logic_vector(3 DOWNTO 0);
	Cin : IN std_logic;
	S : BUFFER std_logic_vector(3 DOWNTO 0);
	Cout : BUFFER std_logic;
	HEX0 : BUFFER std_logic_vector(6 DOWNTO 0)
	);
END full_subtractor_4bit;

-- Design Ports Information
-- S[0]	=>  Location: PIN_AG30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- S[1]	=>  Location: PIN_AF29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- S[2]	=>  Location: PIN_AH30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- S[3]	=>  Location: PIN_AC27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Cout	=>  Location: PIN_AD26,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- HEX0[0]	=>  Location: PIN_W17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- HEX0[1]	=>  Location: PIN_V18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- HEX0[2]	=>  Location: PIN_AG17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- HEX0[3]	=>  Location: PIN_AG16,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- HEX0[4]	=>  Location: PIN_AH17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- HEX0[5]	=>  Location: PIN_AG18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- HEX0[6]	=>  Location: PIN_AH18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- Cin	=>  Location: PIN_AB30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[0]	=>  Location: PIN_V25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[0]	=>  Location: PIN_Y27,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[1]	=>  Location: PIN_AC28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[1]	=>  Location: PIN_AB28,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[2]	=>  Location: PIN_AD30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[2]	=>  Location: PIN_AC30,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A[3]	=>  Location: PIN_AC29,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B[3]	=>  Location: PIN_W25,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF full_subtractor_4bit IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_A : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_B : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_Cin : std_logic;
SIGNAL ww_S : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_Cout : std_logic;
SIGNAL ww_HEX0 : std_logic_vector(6 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \A[0]~input_o\ : std_logic;
SIGNAL \Cin~input_o\ : std_logic;
SIGNAL \B[0]~input_o\ : std_logic;
SIGNAL \FS0|S~combout\ : std_logic;
SIGNAL \A[1]~input_o\ : std_logic;
SIGNAL \B[1]~input_o\ : std_logic;
SIGNAL \FS1|S~combout\ : std_logic;
SIGNAL \B[2]~input_o\ : std_logic;
SIGNAL \A[2]~input_o\ : std_logic;
SIGNAL \FS1|Cout~combout\ : std_logic;
SIGNAL \FS2|S~combout\ : std_logic;
SIGNAL \A[3]~input_o\ : std_logic;
SIGNAL \B[3]~input_o\ : std_logic;
SIGNAL \FS3|S~combout\ : std_logic;
SIGNAL \FS3|Cout~combout\ : std_logic;
SIGNAL \HEX_DEC|Mux6~0_combout\ : std_logic;
SIGNAL \HEX_DEC|Mux5~0_combout\ : std_logic;
SIGNAL \HEX_DEC|Mux4~0_combout\ : std_logic;
SIGNAL \HEX_DEC|Mux3~0_combout\ : std_logic;
SIGNAL \HEX_DEC|Mux2~0_combout\ : std_logic;
SIGNAL \HEX_DEC|Mux1~0_combout\ : std_logic;
SIGNAL \HEX_DEC|Mux0~0_combout\ : std_logic;
SIGNAL \ALT_INV_B[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_Cin~input_o\ : std_logic;
SIGNAL \HEX_DEC|ALT_INV_Mux0~0_combout\ : std_logic;
SIGNAL \FS3|ALT_INV_S~combout\ : std_logic;
SIGNAL \FS2|ALT_INV_S~combout\ : std_logic;
SIGNAL \FS1|ALT_INV_Cout~combout\ : std_logic;
SIGNAL \FS1|ALT_INV_S~combout\ : std_logic;
SIGNAL \FS0|ALT_INV_S~combout\ : std_logic;

BEGIN

ww_A <= A;
ww_B <= B;
ww_Cin <= Cin;
S <= ww_S;
Cout <= ww_Cout;
HEX0 <= ww_HEX0;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_B[3]~input_o\ <= NOT \B[3]~input_o\;
\ALT_INV_A[3]~input_o\ <= NOT \A[3]~input_o\;
\ALT_INV_B[2]~input_o\ <= NOT \B[2]~input_o\;
\ALT_INV_A[2]~input_o\ <= NOT \A[2]~input_o\;
\ALT_INV_B[1]~input_o\ <= NOT \B[1]~input_o\;
\ALT_INV_A[1]~input_o\ <= NOT \A[1]~input_o\;
\ALT_INV_B[0]~input_o\ <= NOT \B[0]~input_o\;
\ALT_INV_A[0]~input_o\ <= NOT \A[0]~input_o\;
\ALT_INV_Cin~input_o\ <= NOT \Cin~input_o\;
\HEX_DEC|ALT_INV_Mux0~0_combout\ <= NOT \HEX_DEC|Mux0~0_combout\;
\FS3|ALT_INV_S~combout\ <= NOT \FS3|S~combout\;
\FS2|ALT_INV_S~combout\ <= NOT \FS2|S~combout\;
\FS1|ALT_INV_Cout~combout\ <= NOT \FS1|Cout~combout\;
\FS1|ALT_INV_S~combout\ <= NOT \FS1|S~combout\;
\FS0|ALT_INV_S~combout\ <= NOT \FS0|S~combout\;

-- Location: IOOBUF_X89_Y16_N56
\S[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS0|S~combout\,
	devoe => ww_devoe,
	o => ww_S(0));

-- Location: IOOBUF_X89_Y15_N39
\S[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS1|S~combout\,
	devoe => ww_devoe,
	o => ww_S(1));

-- Location: IOOBUF_X89_Y16_N39
\S[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS2|S~combout\,
	devoe => ww_devoe,
	o => ww_S(2));

-- Location: IOOBUF_X89_Y16_N22
\S[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS3|S~combout\,
	devoe => ww_devoe,
	o => ww_S(3));

-- Location: IOOBUF_X89_Y16_N5
\Cout~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \FS3|Cout~combout\,
	devoe => ww_devoe,
	o => ww_Cout);

-- Location: IOOBUF_X60_Y0_N19
\HEX0[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \HEX_DEC|Mux6~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX0(0));

-- Location: IOOBUF_X80_Y0_N2
\HEX0[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \HEX_DEC|Mux5~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX0(1));

-- Location: IOOBUF_X50_Y0_N93
\HEX0[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \HEX_DEC|Mux4~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX0(2));

-- Location: IOOBUF_X50_Y0_N76
\HEX0[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \HEX_DEC|Mux3~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX0(3));

-- Location: IOOBUF_X56_Y0_N36
\HEX0[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \HEX_DEC|Mux2~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX0(4));

-- Location: IOOBUF_X58_Y0_N76
\HEX0[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \HEX_DEC|Mux1~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX0(5));

-- Location: IOOBUF_X56_Y0_N53
\HEX0[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \HEX_DEC|ALT_INV_Mux0~0_combout\,
	devoe => ww_devoe,
	o => ww_HEX0(6));

-- Location: IOIBUF_X89_Y20_N61
\A[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(0),
	o => \A[0]~input_o\);

-- Location: IOIBUF_X89_Y21_N4
\Cin~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Cin,
	o => \Cin~input_o\);

-- Location: IOIBUF_X89_Y25_N21
\B[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(0),
	o => \B[0]~input_o\);

-- Location: LABCELL_X85_Y16_N30
\FS0|S\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS0|S~combout\ = ( \Cin~input_o\ & ( \B[0]~input_o\ & ( \A[0]~input_o\ ) ) ) # ( !\Cin~input_o\ & ( \B[0]~input_o\ & ( !\A[0]~input_o\ ) ) ) # ( \Cin~input_o\ & ( !\B[0]~input_o\ & ( !\A[0]~input_o\ ) ) ) # ( !\Cin~input_o\ & ( !\B[0]~input_o\ & ( 
-- \A[0]~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111100001111111100001111000011110000111100000000111100001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datac => \ALT_INV_A[0]~input_o\,
	datae => \ALT_INV_Cin~input_o\,
	dataf => \ALT_INV_B[0]~input_o\,
	combout => \FS0|S~combout\);

-- Location: IOIBUF_X89_Y20_N78
\A[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(1),
	o => \A[1]~input_o\);

-- Location: IOIBUF_X89_Y21_N38
\B[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(1),
	o => \B[1]~input_o\);

-- Location: LABCELL_X85_Y16_N39
\FS1|S\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS1|S~combout\ = ( \Cin~input_o\ & ( \B[0]~input_o\ & ( !\A[1]~input_o\ $ (\B[1]~input_o\) ) ) ) # ( !\Cin~input_o\ & ( \B[0]~input_o\ & ( !\A[0]~input_o\ $ (!\A[1]~input_o\ $ (!\B[1]~input_o\)) ) ) ) # ( \Cin~input_o\ & ( !\B[0]~input_o\ & ( 
-- !\A[0]~input_o\ $ (!\A[1]~input_o\ $ (!\B[1]~input_o\)) ) ) ) # ( !\Cin~input_o\ & ( !\B[0]~input_o\ & ( !\A[1]~input_o\ $ (!\B[1]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111111110000101001010101101010100101010110101111000000001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[0]~input_o\,
	datac => \ALT_INV_A[1]~input_o\,
	datad => \ALT_INV_B[1]~input_o\,
	datae => \ALT_INV_Cin~input_o\,
	dataf => \ALT_INV_B[0]~input_o\,
	combout => \FS1|S~combout\);

-- Location: IOIBUF_X89_Y25_N55
\B[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(2),
	o => \B[2]~input_o\);

-- Location: IOIBUF_X89_Y25_N38
\A[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(2),
	o => \A[2]~input_o\);

-- Location: LABCELL_X85_Y16_N42
\FS1|Cout\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS1|Cout~combout\ = ( \Cin~input_o\ & ( \B[0]~input_o\ & ( (!\A[1]~input_o\) # (\B[1]~input_o\) ) ) ) # ( !\Cin~input_o\ & ( \B[0]~input_o\ & ( (!\B[1]~input_o\ & (!\A[1]~input_o\ & !\A[0]~input_o\)) # (\B[1]~input_o\ & ((!\A[1]~input_o\) # 
-- (!\A[0]~input_o\))) ) ) ) # ( \Cin~input_o\ & ( !\B[0]~input_o\ & ( (!\B[1]~input_o\ & (!\A[1]~input_o\ & !\A[0]~input_o\)) # (\B[1]~input_o\ & ((!\A[1]~input_o\) # (!\A[0]~input_o\))) ) ) ) # ( !\Cin~input_o\ & ( !\B[0]~input_o\ & ( (\B[1]~input_o\ & 
-- !\A[1]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100010001000100110101001101010011010100110101001101110111011101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[1]~input_o\,
	datab => \ALT_INV_A[1]~input_o\,
	datac => \ALT_INV_A[0]~input_o\,
	datae => \ALT_INV_Cin~input_o\,
	dataf => \ALT_INV_B[0]~input_o\,
	combout => \FS1|Cout~combout\);

-- Location: LABCELL_X85_Y16_N51
\FS2|S\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS2|S~combout\ = ( \A[2]~input_o\ & ( \FS1|Cout~combout\ & ( \B[2]~input_o\ ) ) ) # ( !\A[2]~input_o\ & ( \FS1|Cout~combout\ & ( !\B[2]~input_o\ ) ) ) # ( \A[2]~input_o\ & ( !\FS1|Cout~combout\ & ( !\B[2]~input_o\ ) ) ) # ( !\A[2]~input_o\ & ( 
-- !\FS1|Cout~combout\ & ( \B[2]~input_o\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101101010101010101010101010101010100101010101010101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[2]~input_o\,
	datae => \ALT_INV_A[2]~input_o\,
	dataf => \FS1|ALT_INV_Cout~combout\,
	combout => \FS2|S~combout\);

-- Location: IOIBUF_X89_Y20_N95
\A[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(3),
	o => \A[3]~input_o\);

-- Location: IOIBUF_X89_Y20_N44
\B[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(3),
	o => \B[3]~input_o\);

-- Location: LABCELL_X85_Y16_N54
\FS3|S\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS3|S~combout\ = ( \B[3]~input_o\ & ( \FS1|Cout~combout\ & ( !\A[3]~input_o\ $ (((!\A[2]~input_o\) # (\B[2]~input_o\))) ) ) ) # ( !\B[3]~input_o\ & ( \FS1|Cout~combout\ & ( !\A[3]~input_o\ $ (((!\B[2]~input_o\ & \A[2]~input_o\))) ) ) ) # ( \B[3]~input_o\ 
-- & ( !\FS1|Cout~combout\ & ( !\A[3]~input_o\ $ (((\B[2]~input_o\ & !\A[2]~input_o\))) ) ) ) # ( !\B[3]~input_o\ & ( !\FS1|Cout~combout\ & ( !\A[3]~input_o\ $ (((!\B[2]~input_o\) # (\A[2]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000010101111101011110101000011110101000010100000101011110101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[2]~input_o\,
	datac => \ALT_INV_A[2]~input_o\,
	datad => \ALT_INV_A[3]~input_o\,
	datae => \ALT_INV_B[3]~input_o\,
	dataf => \FS1|ALT_INV_Cout~combout\,
	combout => \FS3|S~combout\);

-- Location: LABCELL_X85_Y16_N3
\FS3|Cout\ : cyclonev_lcell_comb
-- Equation(s):
-- \FS3|Cout~combout\ = ( \B[3]~input_o\ & ( \FS1|Cout~combout\ & ( (!\A[2]~input_o\) # ((!\A[3]~input_o\) # (\B[2]~input_o\)) ) ) ) # ( !\B[3]~input_o\ & ( \FS1|Cout~combout\ & ( (!\A[3]~input_o\ & ((!\A[2]~input_o\) # (\B[2]~input_o\))) ) ) ) # ( 
-- \B[3]~input_o\ & ( !\FS1|Cout~combout\ & ( (!\A[3]~input_o\) # ((!\A[2]~input_o\ & \B[2]~input_o\)) ) ) ) # ( !\B[3]~input_o\ & ( !\FS1|Cout~combout\ & ( (!\A[2]~input_o\ & (!\A[3]~input_o\ & \B[2]~input_o\)) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000010001000110011001110111010001000110011001110111011111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[2]~input_o\,
	datab => \ALT_INV_A[3]~input_o\,
	datad => \ALT_INV_B[2]~input_o\,
	datae => \ALT_INV_B[3]~input_o\,
	dataf => \FS1|ALT_INV_Cout~combout\,
	combout => \FS3|Cout~combout\);

-- Location: LABCELL_X85_Y16_N6
\HEX_DEC|Mux6~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \HEX_DEC|Mux6~0_combout\ = ( \FS0|S~combout\ & ( (!\FS2|S~combout\ & (!\FS1|S~combout\ $ (\FS3|S~combout\))) # (\FS2|S~combout\ & (!\FS1|S~combout\ & \FS3|S~combout\)) ) ) # ( !\FS0|S~combout\ & ( (\FS2|S~combout\ & (!\FS1|S~combout\ & !\FS3|S~combout\)) 
-- ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000001000000010000000100000010000110100001101000011010000110",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS2|ALT_INV_S~combout\,
	datab => \FS1|ALT_INV_S~combout\,
	datac => \FS3|ALT_INV_S~combout\,
	dataf => \FS0|ALT_INV_S~combout\,
	combout => \HEX_DEC|Mux6~0_combout\);

-- Location: LABCELL_X85_Y16_N9
\HEX_DEC|Mux5~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \HEX_DEC|Mux5~0_combout\ = ( \FS0|S~combout\ & ( (!\FS1|S~combout\ & (\FS2|S~combout\ & !\FS3|S~combout\)) # (\FS1|S~combout\ & ((\FS3|S~combout\))) ) ) # ( !\FS0|S~combout\ & ( (\FS2|S~combout\ & ((\FS3|S~combout\) # (\FS1|S~combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001000101010101000100010101010101000100001100110100010000110011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS2|ALT_INV_S~combout\,
	datab => \FS1|ALT_INV_S~combout\,
	datad => \FS3|ALT_INV_S~combout\,
	dataf => \FS0|ALT_INV_S~combout\,
	combout => \HEX_DEC|Mux5~0_combout\);

-- Location: LABCELL_X85_Y16_N12
\HEX_DEC|Mux4~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \HEX_DEC|Mux4~0_combout\ = ( \FS0|S~combout\ & ( (\FS2|S~combout\ & (\FS1|S~combout\ & \FS3|S~combout\)) ) ) # ( !\FS0|S~combout\ & ( (!\FS2|S~combout\ & (\FS1|S~combout\ & !\FS3|S~combout\)) # (\FS2|S~combout\ & ((\FS3|S~combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010010100100101001001010010010100000001000000010000000100000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS2|ALT_INV_S~combout\,
	datab => \FS1|ALT_INV_S~combout\,
	datac => \FS3|ALT_INV_S~combout\,
	dataf => \FS0|ALT_INV_S~combout\,
	combout => \HEX_DEC|Mux4~0_combout\);

-- Location: LABCELL_X85_Y16_N15
\HEX_DEC|Mux3~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \HEX_DEC|Mux3~0_combout\ = ( \FS0|S~combout\ & ( (!\FS2|S~combout\ & (!\FS1|S~combout\ & !\FS3|S~combout\)) # (\FS2|S~combout\ & (\FS1|S~combout\)) ) ) # ( !\FS0|S~combout\ & ( (!\FS2|S~combout\ & (\FS1|S~combout\ & \FS3|S~combout\)) # (\FS2|S~combout\ & 
-- (!\FS1|S~combout\ & !\FS3|S~combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100010000100010010001000010001010011001000100011001100100010001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS2|ALT_INV_S~combout\,
	datab => \FS1|ALT_INV_S~combout\,
	datad => \FS3|ALT_INV_S~combout\,
	dataf => \FS0|ALT_INV_S~combout\,
	combout => \HEX_DEC|Mux3~0_combout\);

-- Location: LABCELL_X85_Y16_N18
\HEX_DEC|Mux2~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \HEX_DEC|Mux2~0_combout\ = ( \FS0|S~combout\ & ( (!\FS3|S~combout\) # ((!\FS2|S~combout\ & !\FS1|S~combout\)) ) ) # ( !\FS0|S~combout\ & ( (\FS2|S~combout\ & (!\FS1|S~combout\ & !\FS3|S~combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100010000000000010001000000000011111111100010001111111110001000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS2|ALT_INV_S~combout\,
	datab => \FS1|ALT_INV_S~combout\,
	datad => \FS3|ALT_INV_S~combout\,
	dataf => \FS0|ALT_INV_S~combout\,
	combout => \HEX_DEC|Mux2~0_combout\);

-- Location: LABCELL_X85_Y16_N21
\HEX_DEC|Mux1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \HEX_DEC|Mux1~0_combout\ = ( \FS0|S~combout\ & ( !\FS3|S~combout\ $ (((\FS2|S~combout\ & !\FS1|S~combout\))) ) ) # ( !\FS0|S~combout\ & ( (!\FS2|S~combout\ & (\FS1|S~combout\ & !\FS3|S~combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010001000000000001000100000000010111011010001001011101101000100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \FS2|ALT_INV_S~combout\,
	datab => \FS1|ALT_INV_S~combout\,
	datad => \FS3|ALT_INV_S~combout\,
	dataf => \FS0|ALT_INV_S~combout\,
	combout => \HEX_DEC|Mux1~0_combout\);

-- Location: LABCELL_X85_Y16_N24
\HEX_DEC|Mux0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \HEX_DEC|Mux0~0_combout\ = ( \FS3|S~combout\ & ( \FS0|S~combout\ ) ) # ( !\FS3|S~combout\ & ( \FS0|S~combout\ & ( !\FS1|S~combout\ $ (!\FS2|S~combout\) ) ) ) # ( \FS3|S~combout\ & ( !\FS0|S~combout\ & ( (!\FS2|S~combout\) # (\FS1|S~combout\) ) ) ) # ( 
-- !\FS3|S~combout\ & ( !\FS0|S~combout\ & ( (\FS2|S~combout\) # (\FS1|S~combout\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011111100111111111100111111001100111100001111001111111111111111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \FS1|ALT_INV_S~combout\,
	datac => \FS2|ALT_INV_S~combout\,
	datae => \FS3|ALT_INV_S~combout\,
	dataf => \FS0|ALT_INV_S~combout\,
	combout => \HEX_DEC|Mux0~0_combout\);

-- Location: LABCELL_X23_Y52_N0
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


