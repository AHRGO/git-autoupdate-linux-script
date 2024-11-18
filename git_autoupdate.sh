branch_exists() {
    git rev-parse --verify "$1" >/dev/null 2>&1
}

check_status() {
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Erro: Existem mudanças não salvas ou não commitadas."
        return 1
    fi
    return 0
}

create_branch_from_develop() {
  echo "Criando a branch '$1' a partir de 'develop'..."
  git checkout develop
  git pull origin develop
  git checkout -b "$1"
  echo "A branch '$1' foi criada com sucesso!"
}

merge_develop_into() {
  if branch_exists "$1"; then
      echo "Atualizando a branch 'develop'..."
      git checkout develop
      git pull origin develop
      echo "Indo para a branch '$1' e fazendo merge com 'develop'..."
      git checkout "$1"
      git merge develop
  else
      echo "A branch '$1' não existe. Deseja criá-la a partir de 'develop'? [n/Y]"
      read -r response
      response=$(echo "$response" | tr '[:upper:]' '[:lower:]') # converte a resposta para minúsculas
      if [[ "$response" == "y" || -z "$response" ]]; then
        create_branch_from_develop $1
      else
        echo "Operação cancelada. A branch '$1' não foi criada."
      fi
  fi
}

merge_develop_into_current_branch() {
  local current_branch=$(git branch --show-current)
  echo "Atualizando a branch 'develop'..."
  git checkout develop
  git pull origin develop
  echo "Indo para a branch '$current_branch' e fazendo merge com 'develop'..."
  git checkout "$current_branch"
  git merge develop

}


d4c() {
  if check_status; then
    if [ -z "$1" ]; then
      merge_develop_into_current_branch
    else
      merge_develop_into "$1"
    fi
  else 
    echo "Por favor, commit ou stash as alterações antes de continuar."
  fi
}