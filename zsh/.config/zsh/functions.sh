function load_sdkman() {
  export SDKMAN_DIR="/Users/pwntester/.sdkman"
  [[ -s "/Users/pwntester/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/pwntester/.sdkman/bin/sdkman-init.sh"
}

function load_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
}

function load_rbenv() {
  export RBENV_ROOT="$HOME/.rbenv"
  export PATH="$RBENV_ROOT/bin:$PATH"
  eval "$(rbenv init -)"
}

function load_nvm() {
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  export PATH="/usr/local/opt/node@16/bin:$PATH"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
}

function cdr() {
  cd "$(gh cdr "$@")" || return
}

function fc() {
  curl -s -X POST https://api.firecrawl.dev/v0/scrape \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
    -d "{\"url\": \"$1\"}" | jq -r '.data.markdown'
}

function sm() {
  # fabric -m=gpt-4o-2024-05-13 -p summarize_meeting
  # pbpaste | llm "$(</Users/pwntester/.config/fabric/custom_patterns/summarize_meeting/system.md)" | FABRIC_OUTPUT_PATH="/Users/pwntester/obsidian/Meeting Notes" save -s "$1"
  # pbpaste | aichat -m claude:claude-3-5-sonnet-20240620 --prompt "$(</Users/pwntester/.config/fabric/custom_patterns/summarize_meeting/system.md)" | FABRIC_OUTPUT_PATH="/Users/pwntester/obsidian/Meeting Notes" save -s "$1"
  pbpaste | aichat --prompt "$(</Users/pwntester/.config/fabric/custom_patterns/summarize_meeting/system.md)" | FABRIC_OUTPUT_PATH="/Users/pwntester/obsidian/Meeting Notes" save -s "$1"
}

function logbook() {
  if [[ $# -eq 0 ]]; then
    DATE=$(date -I)
  else
    DATE="$1"
  fi
  JOURNAL="/Users/pwntester/obsidian/Journal/$DATE.md"

  # Check if the journal file exists
  if [[ -f "$JOURNAL" ]]; then
    echo "Appending to existing journal file: $JOURNAL"
  else
    echo "Creating new journal file: $JOURNAL"
    cat <<EOF >"$JOURNAL"
---
tags:
  - journal
  - daily-notes
created: "$DATE"
links: []
modified: "$DATE"
---

# $DATE

## Notes

EOF

  fi

  PROMPT="Generate a markdown logbook with all the tasks the user worked on during the day. These tasks will be provided in JSON format. Write a short summary for each of the tasks and also include URLs or other notes associated with the tasks, but do not include any dates. Use the following format and template for the response: \
\  
  ## Logbook \
  ### Project title \
  #### Task title \
  Brief summary of the task. \
\
  - URL: [URL] (optional) \
\
  ... \
"

  {
    echo -e "\n\n## Meeting and Conversations\n\n"

    find Meeting\ Notes -type f -name "${DATE}*" -print0 | xargs -0 -I {} basename {} | sed "s/^/- [[/g" | sed "s/\.md$/]]/g"

    load_pyenv
    things-cli -j -r logbook | jq ".[] | select(.stop_date | contains(\"$DATE\"))" | llm "$PROMPT"

  } | tee -a "$JOURNAL"

}

function sarif() {
  nvim -c "QL sarif load $1"
}

week_summary() {
  if [ -z "$1" ]; then
    start_date=$(date -v-7d +%Y-%m-%d)
  else
    start_date="$1"
  fi
  current_date=$(date +%Y-%m-%d)
  echo "Summaring week ($start_date - $current_date)"
  find . -type f -name "*.md" -newermt "$start_date" ! -newermt "$current_date 23:59:59" -print0 | xargs -0 files-to-prompt -c | llm -m claude-3.5-sonnet "create a list of things Ive been worked on based on the journal entries provided. This blob should match all the files from the provided date to the current date. Just output a markdown list"
  # "You will be provided with several journal files containing daily entries. Your task is to analyze these entries and generate a concise list of tasks completed, meetings attended, and any other relevant activities or accomplishments during the period covered by the journal entries. Present this information as a simple markdown list, without any headings, introductions, or conclusions. Each item should be clear and to the point, providing just enough context to understand the task or activity. Do not include any explanatory text outside of the list itself. Group similar tasks together and omit any personal tasks"

}
