#verifies if a branch exists
branch_exists() {
    git rev-parse --verify "$1" >/dev/null 2>&1
}

#checks if there are any changes not saved or not committed
check_status() {
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Erro: Existem mudanças que não foram salvas ou commitadas."
        return 1
    fi
    return 0
}

#creates a target branch ($2) from a source branch($1)
create_branch_from() {
  echo "Criando a branch '$2' a partir de '$1'..."
  git checkout "$1"
  git pull origin "$1"
  git checkout -b "$2"
  echo "A branch '$2' foi criada com sucesso!"
}

#merges source branch($1) into target branch($2)
merge_into() {
  if branch_exists "$2"; then
      echo "Atualizando a branch '$1'..."
      git checkout "$1"
      git pull origin "$1"
      echo "Indo para a branch '$2' e fazendo merge com '$1'..."
      git checkout "$2"
      git merge "$1"
  else
      echo "A branch '$2' não existe. Deseja criá-la a partir de '$1'? [n/Y]"
      read -r response
      response=$(echo "$response" | tr '[:upper:]' '[:lower:]') # converte a resposta para minúsculas
      if [[ "$response" == "y" || -z "$response" ]]; then
        create_branch_from $1 $2
      else
        echo "Operação cancelada. A branch '$2' não foi criada."
      fi
  fi
}

#simplify the merging process into a single command
merge_source_into_current() {
  local current_branch=$(git branch --show-current)
  echo "Atualizando a branch '$1'..."
  git checkout "$1"
  git pull origin "$1"
  echo "Indo para a branch '$current_branch' e fazendo merge com '$1'..."
  git checkout "$current_branch"
  git merge "$1"
}

#merges the current branch into the target branch
d4c() {
  local target_branch="homolog"

  if check_status; then
    if [ -z "$1" ]; then
      merge_source_into_current "$target_branch" 
    else
      merge_into "$target_branch" "$1" 
    fi
  else 
    echo "Por favor, commite ou faça stash das alterações antes de continuar."
  fi
}

lucy() {
  local target_branch="develop"

  if check_status; then
    if [ -z "$1" ]; then
      merge_source_into_current "$target_branch" 
    else
      merge_into "$target_branch" "$1" 
    fi
  else 
    echo "Por favor, commite ou faça stash das alterações antes de continuar."
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
    echo "Por favor, commite ou faça stash das alterações antes de continuar."
  fi
}