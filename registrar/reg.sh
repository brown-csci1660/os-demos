#!/bin/bash -p
set -euo pipefail

#set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

DB=${SCRIPT_DIR}/db

# Load internal commands
export PATH=$PATH:/home/registrar/bin

__check_admin()
{
    if [[ $USER != "registrar" ]]; then
       echo "Sorry, registrar only"
       exit 0
    fi
}

__is_admin()
{
    # Compare real ID to uid of registrar user
    my_real_uid=$(id -ru)
    uid_of_registrar=$(id -u registrar)
    
    if [ $(id -ru) == $(id -u registrar) ]; then
	return 0
    else
	return 1
    fi
}

__check_effective_user_access()
{
    # How an a *really* better way would work:  use system calls 
    # access() to test if a user can use a file
    # - Change effective UID back to alice
    # - Separate out file loading
    # ....
    # This version doesn't do that since it's only a bash script
    # Instead, we spawn a new bash shell to test if the user can read the file.
    # By default, bash will set euid == uid on startup, so this should ensure the
    # check happens with euid as the user's real uid.  
    #
    # Disclaimer:  Nick came up with this idea and couldn't find a reference
    # for it anywhere, so we make no claim this is actually secure.
    
    file="$1"
    return $(bash -c "test -r ${file}")
}


get_enrolled()
{
    course="$1"
    echo $(ls -q1 "$DB/$course/students" | wc -l)
}

get_cap()
{
    course="$1"
    cat "$DB/$course/max_capacity"
}

get_current_user() {
    echo $(id -nu $(id -ru))
}

add_to_course()
{
    course="$1"
    user="$2"

    echo "Adding ${user} to ${course}"
    echo "some_info_here" > $DB/$course/students/$user
}

add()
{
    if [ $# -eq 1 ]; then
	echo "This course requires an override code.  Run with add <course> <file with code>"
	exit 1
    fi
    
    course="$1"
    code_from_user=$(realpath "$2")
    user="$(get_current_user)"

    code_expected=$DB/$course/pending_overrides/$user

    # Problem:  need to read alice's override file as alice's user
    

    # Add if files have equal contents
    if cmp --silent $code_expected $code_from_user; then
	echo "Override code approved!"
	add_to_course $course $user
    else
	echo "Please use a valid override code"
    fi
}


add_slightly_better()
{
    if [ $# -eq 1 ]; then
	echo "This course requires an override code.  Run with add <course> <file with code>"
	exit 1
    fi
    
    course="$1"
    code_from_user="$2"
    user="$(get_current_user)"

    code_expected=$DB/$course/pending_overrides/$user

    # Time of check - time of use vulnerability (TOCTOU)
    
    # Test for access
    if ! __check_effective_user_access $code_from_user; then
	echo "You don't have permission to view this file"
	exit 1
    fi



    sleep 10
    
    
    # Does the access
    cat $code_expected
    if cmp --silent $code_expected $code_from_user; then
	echo "Override code approved!"
	add_to_course $course $user
    else
	echo "Please use a valid override code"
    fi
}


do_list()
{
    course="${1:-}"
    dir="$DB/$course/students"

    if [ -z $course ]; then
	echo -e "Available courses\n$(ls $DB/$course)"
	return 0
    fi

    enrolled=$(get_enrolled $course)
    cap=$(get_cap $course)
    remaining=$(($cap - $enrolled))
    
    echo "$(get_enrolled ${course}) students registered in ${course}:  ${remaining} seats remaining"

    
    if is_admin; then
	echo -e "\n\nStudents registered in ${course}:"
	for s in $(ls -q1 ${dir}); do
	    echo $s
	done
    fi
}

main()
{
    case $1 in
	list)
	    shift
	    do_list $@
	    ;;
	add)
	    shift
	    add $@
	    #add_slightly_better $@
	    ;;
	drop)
	;;
	whoami)
	    cs1660-whoami
	;;
	*)
	    echo "Unrecognized command $1"
	    exit 1
	    ;;
    esac
}

main $@
