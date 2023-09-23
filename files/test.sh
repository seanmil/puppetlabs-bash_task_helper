set -x

task-hash-build() {
  local -r hash="${1}"
  local -r key="${2}"
  local -r value="${3}"
  local -r hashkey="${hash}\t${key}"

  # Try to find an index for the key
  for i in "${!_task_hash_keys[@]}"; do
    [[ "${_task_hash_keys[$i]}" = "${hashkey}" ]] && break
  done

  # If there's an index, set its value. Otherwise, add a new key
  if [[ "${_task_hash_keys[$i]}" = "${hashkey}" ]]; then
    _task_hash_values[$i]="${value}"
  else
    _task_hash_keys=("${_task_hash_keys[@]}" "${hashkey}")
    _task_hash_values=("${_task_hash_values[@]}" "${value}")
  fi
}

task-hash-build2() {
  local -r name="${1}"
  local -r key="${2}"
  local -r value="${3}"

  local -r keyvarname="_task_hash_${name}_keys"
  local -r valvarname="_task_hash_${name}_vals"

  if [[ -z "${!keyvarname}" ]]; then
    echo "initing"
    declare -a "${keyvarname}"
    declare -a "${valvarname}"
  fi
  echo "${!keyvarname}"

  echo ${!keyvarname}[@]

  # set | grep _task_hash_

  local -r keys=("${!keyvarname[@]}")
  echo "${keys[@]}"
  local -r length="${#keys}"

  # Try to find an index for the key
  for i in $(seq 1 $((length+1))); do
    echo "${i}"
    [[ "${!keyvarname[$i]}" = "${key}" ]] && break
  done

  # If there's an index, set its value. Otherwise, add a new key
  if [[ "${keyvarname[$i]}" = "${key}" ]]; then
    echo "setting known index: ${i}"
    IFS= read -r -- "${keyvarname}[$i]" <<< "${key}"
    IFS= read -r -- "${valvarname}[$i]" <<< "${value}"
  else
    echo "setting new index: ${i}"
    IFS= read -r -- "${keyvarname}[$i]" <<< "${key}"
    IFS= read -r -- "${valvarname}[$i]" <<< "${value}"
  fi

}

_task_hash_keys=()
_task_hash_values=()

task-hash-build "foo" "a" "1"
task-hash-build "foo" "b" "2"
task-hash-build "foo" "c" "3"

echo "${_task_hash_keys[@]}"
echo "${_task_hash_values[@]}"

task-verbose-output
