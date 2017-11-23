function docker-stop

    # If '-h' or '--help' then show the help, else error. 
    set -l help_info 'usage: docker-stop\n\nStops Docker (Docker.app) on macOS.'
    set -l argument_error_info 'ARGUMENT ERROR: Unexpected argument(s) specified. Use -h for help.'
    set -l arg_count (count $argv)
    if [ $arg_count -eq 1 ]
        set argument "$argv[1]"
        switch "$argument"
        case '-h'
            echo -e "$help_info"
            return 0
        case '--help'
            echo -e "$help_info"
            return 0
        case *
            echo "$argument_error_info" >&2
            return 2
        end
    else if [ $arg_count -gt 1 ] 
        echo "$argument_error_info" >&2
        return 2
    end 

    # make sure we are on macOS
    if not [ (uname) = 'Darwin' ]
        echo "This function only runs on macOS." >&2
        return 2
    end 

    # Info
    echo '-- Quitting Docker.app, if running...'

    # Quit Docker if needed. 
    echo 'tell application "Docker"
            if it is running then quit it
          end tell'\
    | osascript -

    echo '-- Docker is stopped.'
    echo 'Caveat: Restarting it too quickly can cause errors.'
end 