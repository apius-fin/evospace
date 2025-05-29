#!/bin/bash
#--------------------------------------------------------------------------------#
#                               USER_ANSWER_FUNC                                 #
#--------------------------------------------------------------------------------#
# A function for requesting a yes/no(y/n) response from the user with input verification
ask_user() {
    local attempts=3
    local choice_question="$1"
    local exit_answer="$2"
    # A variable for setting a constant string with possible answers to a question.
    local various_answer="${dark_blue_b}yes/no (y/n):${end_color}"

    while [ $attempts -gt 0 ]; do
        echo -ne "${blue_b}$choice_question $various_answer${end_color} "
        read user_answer
        user_answer=${user_answer,,} # Convert everything to lowercase
        case "$user_answer" in
            yes|y|д|да) return 0 ;;  # If answer "yes" or "y", return 0 (да)
            no|n|н|нет) return 1 ;;   # If answer "no" or "n", return 1 (нет)
            *)
                ((attempts--))
                echo -e "${yellow_b_in_red_back}You have entered an invalid response. There are still attempts left: $attempts.${end_color}"
                ;;
        esac
    done

    echo -e "${yellow_b_in_red_back}$exit_answer${end_color}"
    log_message "$end_log_message" false
    exit 1
}