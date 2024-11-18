function update -d "update brew, fish, fisher and mac app store"
    echo 'start updating ...'

    echo 'updating homebrew'
    brew update
    brew upgrade
    brew cleanup

    echo 'updating fish shell'
    fisher
    fish_update_completions

    echo 'checking Apple Updates'
    /usr/sbin/softwareupdate -ia

    exit 0
end
