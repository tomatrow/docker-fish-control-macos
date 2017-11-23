function docker-start

    # If '-h' or '--help' then show the help, else error. 
    set -l help_info 'usage: docker-start\n\nStarts Docker (Docker.app) on macOS and waits until the Docker environment is initialized.'
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
    echo '-- Starting Docker.app, if necessary...'

    # Open docker. 
    open -g -a Docker.app; or return

    # Wait for the server to start up, if applicable.  
    set -l i 0
    while not docker system info ^ /dev/null
        set i (math "$i + 1")
        echo "$i -- Waiting for Docker to finish starting up..."
        sleep 1
    end 
    if [ "$i" = '0' ]
        echo ''
    end 

    echo '-- Docker is ready.'
end 