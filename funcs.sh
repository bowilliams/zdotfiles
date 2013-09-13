function to_install() {
  local desired installed
  local -A remain
  desired=$1
  installed=$2
  remain=$(comm -13 <(printf "%s\n" $=installed | sort) <(printf "%s\n" $=desired | sort))
  echo "${=remain}"
}