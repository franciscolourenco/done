# run this file with jorgebucaran/fishtape
# i.e. fishtape test/done.fish

function setup
  source conf.d/done.fish
end

@test "commands are executed without errors" (
  echo 1 > /dev/null
) $status -eq 0
