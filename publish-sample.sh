#!/bin/sh
# -----------------------------
# env
# -----------------------------
CURRENT_DIR=$PWD
WORK_DIR=~/tmp/$(basename $PWD)
ORIGINAL_CODE_DIR=$CURRENT_DIR

MODE_CLEANUP=false #true(force-push), false(pull & push)

REMOTE_NAME=origin
REMOTE_GIT_URL=git@github.com:kota661/lab-session-affinity.git
REMOTE_WEB_URL=https://github.com/kota661/lab-session-affinity

# -----------------------------
# init
#  作業フォルダを作成しgit initする
# arg:
#  - work_dir
#  - remote_name
#  - remote_git_url
# -----------------------------
init() {
  _work_dir=$1
  _remote_name=$2
  _remote_git_url=$3
  echo init
  [ -d $_work_dir ] && rm -rf $_work_dir
  mkdir $_work_dir
  cd $_work_dir
  if "$MODE_CLEANUP"; then
    git init
    git branch -m main
    git remote add $_remote_name $_remote_git_url
  else
    git clone $_remote_git_url $WORK_DIR
    rm -rf $WORK_DIR/*
  fi
}

# -----------------------------
# collect
#  作業フォルダを作成しgit initする
# arg:
#  - source_dir
#  - destination_dir
# -----------------------------
collect() {
  _source_dir=$1
  _destination_dir=$2

  echo collect
  cp -r $_source_dir/ $_destination_dir/

  # 削除するべきファイルリスト
  delete_targets=("publish.sh" ".envrc" "terraform.tfvars")
  for f in "${delete_targets[@]}"
  do
      [ -e "$_destination_dir/$f" ] && rm "$_destination_dir/$f"
  done
}

# -----------------------------
# gitignore
# arg:
#  - work_dir
# -----------------------------
gitignore() {
  _work_dir=$1

  cd $_work_dir
  echo .envrc >>.gitignore
}

# -----------------------------
# commit
# arg:
#  - work_dir
# -----------------------------
commit() {
  _work_dir=$1

  echo commit
  cd $WORK_DIR
  git add .gitignore
  git add *
  git status

  read -p "commit message? : " commit_message
  git commit -m "$commit_message" -a
}

# -----------------------------
# push
# arg:
#  - work_dir
#  - name
#  - giturl
#  - webpage
# -----------------------------
push() {
  _work_dir=$1
  _remote_name=$2
  _webpage=$3

  cd $_work_dir

  echo Push Code
  echo git logs
  git log -n 2
  read -p "ok? (y/N): " yn
  case "$yn" in [yY]*) ;;
  *)
    echo "abort."
    exit
    ;;
  esac

  if "$MODE_CLEANUP"; then
    git push $_remote_name main:main --force
  else
    git push $_remote_name main:main
  fi

  echo site: $_webpage
}

# -----------------------------
# cleanup
# arg:
#  - current_dir
#  - work_dir
# -----------------------------
cleanup() {
  current_dir=$1
  work_dir=$2

  echo cleanup
  read -p "ok? (y/N): " yn
  case "$yn" in [yY]*) ;;
  *)
    echo "abort."
    exit
    ;;
  esac
  cd $current_dir
  rm -rf $work_dir
}

# -----------------------------
# main
# -----------------------------
main() {
  echo work_dir = $WORK_DIR
  echo git_url = $REMOTE_GIT_URL
  echo git_web_url = $REMOTE_WEB_URL

  while :; do
    case "$1" in
    --cleanup)
      cleanup $CURRENT_DIR $WORK_DIR
      exit 0
      ;;
    -*)
      echo "Error: Unknown option: $1" >&2
      exit 1
      ;;
    *) # No more options
      break
      ;;
    esac
  done
  init $WORK_DIR $REMOTE_NAME $REMOTE_GIT_URL
  collect $ORIGINAL_CODE_DIR $WORK_DIR
  gitignore $WORK_DIR
  commit $WORK_DIR
  push $WORK_DIR $REMOTE_NAME $REMOTE_GIT_URL
  cleanup $CURRENT_DIR $WORK_DIR
}

main "$@"
