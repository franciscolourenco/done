function setup
  source conf.d/done.fish
end

test "command are executed without errors"
  0 -eq (echo 1 > /dev/null; echo $status)
end

