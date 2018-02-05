#!/bin/bash -e

run-step(){
    if [ ! -z ${LAST_STEP} ];then
        [ "${LAST_STEP}" = "$2" ] \
            && unset LAST_STEP
        return 0
    fi
    echo "### $1"
    . scripts/$2.sh
    echo $2 > .last_step
    if [ "$2" != "done" ];then
        echo "======== $2 DONE!!! 
            Can we continue?[y]"
        read can_we_continue
        if [ "${can_we_continue}" != 'y' ];then
            echo "interrupted"
            exit 0
        fi
    fi
}

validate-init(){
    [ -z ${AWS_PROFILE} ] && echo "Missing AWS account profile, set it using:
        export AWS_PROFILE=myuser_with_iam_powers" && exit 1

    echo "Make sure that you have the aws user with right credentials
        AWS_PROFILE=${AWS_PROFILE}"
}

validate-init

[ -f .last_step ] && LAST_STEP=$(cat .last_step)

run-step "Group/user" credentials
run-step "bucket" bucket
run-step "DNS" dns
run-step "Creating my first cluster" cluster
run-step "Addons" addons
run-step "Sample application" sample
run-step "Drop everything" cleanup

rm -f .last_step