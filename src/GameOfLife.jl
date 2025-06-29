"Project module that implements Conway's 'game of life' cellular automaton"
module GameOfLife

using UnicodePlots: height
using UnicodePlots

export play_game,
    setup_random_board,
    create_glider

function clear_screen()
    print("\033[2J\033[H")
end

function save_cursor_position()
    print("\033[s")
end

function restore_cursor_to_saved_position()
    print("\033[u")
end

function get_number_of_neighbors(
    cell::CartesianIndex, board::AbstractMatrix{<:Integer})
    rows, cols = size(board)
    row, col = cell.I
    count = 0
    for i in -1:1, j in -1:1
        (i == 0 && j == 0) && continue
        r = mod1(row + i, rows)
        c = mod1(col + j, cols)
        count += board[r, c]
    end
    return count
end

function update_cell(cell::CartesianIndex, board::AbstractMatrix{<:Integer})
    surrounding_cells = get_number_of_neighbors(cell, board)
    if board[cell] == 1
        return surrounding_cells > 3 ? 0 :
               (surrounding_cells < 2 ? 0 : 1)
    end
    return surrounding_cells == 3 ? 1 : 0
end

function update_board!(
    new_board::AbstractMatrix{<:Integer}, board::AbstractMatrix{<:Integer})
    for cell in CartesianIndices(board)
        new_board[cell] = update_cell(cell, board)
    end
    return new_board
end

function plot_board(
    board::AbstractMatrix{<:Integer}, width::Integer, height::Integer)
    board_plot = UnicodePlots.heatmap(
        board,
        colorbar=false,
        labels=false,
        colormap=:inferno,
        height=height,
        width=width,
    )
    display(board_plot)
end

"""
    setup_random_board(width, height)

# Description

Creates a Boolean matrix with random values of set width and height (for use 
with [`play_game`](@ref)).

# Examples

```julia-repl
julia> setup_random_board(5,5)
5×5 Matrix{Bool}:
 0  1  0  1  1
 0  0  1  0  0
 0  1  1  1  0
 1  0  0  0  0
 1  0  1  0  1
```

# See also

[`play_game`](@ref)
"""
function setup_random_board(width::Integer, height::Integer)
    board = rand(Bool, (height, width))
    return board
end

"""
    create_glider(width,height)

# Description

Creates a Boolean matrix of set width and height that contains a glider in the
bottom left (for use with [`play_game`](@ref)).

# Examples

```julia-repl
julia> create_glider(5,5)
5×5 Matrix{Bool}:
 1  0  0  0  0
 0  1  1  0  0
 1  1  0  0  0
 0  0  0  0  0
 0  0  0  0  0
```

# See also

[`play_game`](@ref)
"""
function create_glider(width::Integer, height::Integer)
    if width < 3 || height < 3
        println("Board must be larger than 3x3")
        return
    end
    board = zeros(Bool, width, height)
    board[1, 1] = 1
    board[2, 2:3] .= 1
    board[3, 1:2] .= 1
    return board
end

"""
    play_game(board_generator; width, height, max_steps)

# Description

Simulate Conway's game of life with some intial state generator for a total of
max_steps (early exits if all cells are dead as the state has reached a stable
point). SIGINT (CTRL+C) can be sent to terminate the simulation early.

# Arguments

- board_generator : A function that accepts a width::Integer and a
    height::Integer and returns a Integer Matrix (AbstractMatrix{<:Integer})
    representing the initial configuration of the game state.
    - A malformed function will throw an assertion error

# Examples

```julia-repl
julia> play_game(setup_random_board)
# Animation plays...

Final iteration
    ┌────────────────────┐
    │▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄│
    │▄▄▄▄▄▄▄    ▄▄▄▄▄▄▄▄▄│
    │▄▄▄▄▄▄▄    ▄▄▄▄▄▄▄▄▄│
    │▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄│
    │▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄│
    │▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄│
    │▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄│
    │▄▄▄▄▄▄▄▄▄▄▄▄▄    ▄▄▄│
    │▄▄▄▄▄▄▄▄▄▄▄▄▄    ▄▄▄│
    │▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄│
    └────────────────────┘
```

# See also

`setup_random_board`, `create_glider`
"""
function play_game(board_generator::Function;
    width::Integer=20, height::Integer=20, max_steps::Integer=100)
    step = 0
    current_board = board_generator(width, height)
    @assert isa(current_board, AbstractMatrix{<:Integer}) (
        "board_generator must return a AbstractMatrix{<:Integer}")
    previous_board = similar(current_board)
    clear_screen()
    try
        save_cursor_position()
        while sum(current_board) != 0 && step < max_steps
            restore_cursor_to_saved_position()
            plot_board(current_board, width, height)
            sleep(0.1)
            update_board!(previous_board, current_board)
            previous_board, current_board = current_board, previous_board
            step += 1
        end
    catch ex
        isa(ex, InterruptException) || rethrow()
    end
    clear_screen()
    println("Final iteration")
    plot_board(current_board, width, height)
end

end # module GameOfLife
