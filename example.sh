cd "$(dirname ${BASH_SOURCE[0]})"
PROJECT_PATH="$(pwd)/Example"


echo "===== Test 1 (function defined in Example.jl) ====="
rm -rf ~/.julia/compiled/v1.6/Example

echo '
module Example
greet() = println("Hello!")
end
' > "${PROJECT_PATH}/src/Example.jl"
echo "Expecting 'Hello!'"
nix run --no-warn-dirty '.#example'

echo '
module Example
greet() = println("Goodbye!")
end
' > "${PROJECT_PATH}/src/Example.jl"
echo "Expecting 'Goodbye!'"
nix run --no-warn-dirty '.#example'


echo
echo "===== Test 2 (function defined in included file) ====="
rm -rf ~/.julia/compiled/v1.6/Example

echo '
module Example
include("foo.jl")
end
' > "${PROJECT_PATH}/src/Example.jl"

echo '
greet() = println("Hello!")
' > "${PROJECT_PATH}/src/foo.jl"
echo "Expecting 'Hello!'"
nix run --no-warn-dirty '.#example'

echo '
greet() = println("Goodbye!")
' > "${PROJECT_PATH}/src/foo.jl"
echo "Expecting 'Goodbye!'"
nix run --no-warn-dirty '.#example'


echo
echo "===== Test 3 (same as Test 2 but deleting the compilation cache between runs) ====="

echo '
module Example
include("foo.jl")
end
' > "${PROJECT_PATH}/src/Example.jl"

echo '
greet() = println("Hello!")
' > "${PROJECT_PATH}/src/foo.jl"
echo "Expecting 'Hello!'"
rm -rf ~/.julia/compiled/v1.6/Example
nix run --no-warn-dirty '.#example'

echo '
greet() = println("Goodbye!")
' > "${PROJECT_PATH}/src/foo.jl"
echo "Expecting 'Goodbye!'"
rm -rf ~/.julia/compiled/v1.6/Example
nix run --no-warn-dirty '.#example'
