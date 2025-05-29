#!/bin/bash
#--------------------------------------------------------------------------------#
#                                COLOR_SECTION                                   #
#--------------------------------------------------------------------------------#
export end_color="\e[0m" #  Reset formatting
export yellow_b_in_red_back="\e[33;1m\e[41m" # Critical notes and errors
export yellow_b="\e[33;1m" # Warnings
export blue_b="\e[36;1m" # Require actions from script executor
export green_b="\e[32;1m" # Info
export white_b_in_green_back="\e[97;1m\e[42m" # Success script ending