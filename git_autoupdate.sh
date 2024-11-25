#verifies if a branch exists
branch_exists() {
    git rev-parse --verify "$1" >/dev/null 2>&1
}

#checks if there are any changes not saved or not committed
check_status() {
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Error: Some changes has not been committed or saved yet."
        return 1
    fi
    return 0
}

#creates a target branch ($2) from a source branch($1)
create_branch_from() {
  echo "Moving to branch '$1' and updating it..."
  git checkout "$1"
  git pull origin "$1"
  echo "Creating branch '$2' from '$1'..."
  git checkout -b "$2"
  echo "Branch '$2' was created successfully!"
}

#merges source branch($1) into target branch($2)
merge_into() {
  if branch_exists "$2"; then
      git checkout "$1"
      echo "Updating branch '$1'..."
      git pull origin "$1"
      echo "Going to branch '$2' and merging with '$1'..."
      git checkout "$2"
      git merge "$1"
      echo "Branch '$1' was merged into '$2' successfully!"
  else
      echo "Branch '$2' does not exist. Do you want to create it from '$1'? [n/Y]"
      read -r response
      response=$(echo "$response" | tr '[:upper:]' '[:lower:]') # tolower
      if [[ "$response" == "y" || -z "$response" ]]; then
        create_branch_from $1 $2
      else
        echo "Operation canceled. Branch '$2' was not created."
      fi
  fi
}

#simplify the merging process into a single command
merge_source_into_current() {
  local current_branch=$(git branch --show-current)
  git checkout "$1"
  echo "Updating branch '$1'..."
  git pull origin "$1"
  echo "Going to branch '$current_branch' and merging with '$1'..."
  git checkout "$current_branch"
  git merge "$1"
  echo "Branch '$1' was merged into '$current_branch' successfully!"
}

#merges the current branch into the target branch
d4c() {
  local target_branch="develop"

  if check_status; then
    if [ -z "$1" ]; then
      merge_source_into_current "$target_branch" 
    else
      merge_into "$target_branch" "$1" 
    fi
  else 
    echo "Please, commit or stash your changes before continue."
  fi
}

lovetrain() {
  local target_branch="main"

  if check_status; then
    if [ -z "$1" ]; then
      merge_source_into_current "$target_branch" 
    else
      merge_into "$target_branch" "$1" 
    fi
  else 
    echo "Please, commit or stash your changes before continue."
  fi
}
