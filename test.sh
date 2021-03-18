demoFun() {
  array=( A B C D 1 2 3 4)
  for element in ${array[*]}; do
    echo "$element"
  done
}

demoFun
