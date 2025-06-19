module game_of_life

using UnicodePlots

ALIVE_CHAR = '#'
DEAD_CHAR = '-'

function setup_board(width::Int, height::Int)
    board = rand((0, 1), (height, width))
    return board
end

function get_number_of_neighbors(cell::CartesianIndex, board::Matrix{Int})
    row, col = cell.I
    top = max(1, row - 1)
    bottom = min(row + 1, size(board)[1])
    left = max(1, col - 1)
    right = min(col + 1, size(board)[2])
    return sum(@view board[top:bottom, left:right]) - board[cell]
end

function update_cell(cell::CartesianIndex, board::Matrix{Int})
    surrounding_cells = get_number_of_neighbors(cell, board)
    if board[cell] == 1
        board[cell] = surrounding_cells > 3 ? 0 :
                      (surrounding_cells < 2 ? 0 : 1)
    else
        board[cell] = surrounding_cells == 3 ? 1 : 0
    end
end

function update_board(board::Matrix{Int})
    foreach(cell -> update_cell(cell, board), CartesianIndices(board))
    return board
end

function plot_board(board)
    board_plot = UnicodePlots.heatmap(
        board,
        colorbar=false,
        labels=false,
    )
    display(board_plot)
end

function play_game(board; max_steps=100)
    println("Game start")
    step = 0
    while sum(board) != 0 && step < max_steps
        # Clear terminal and move cursor to top
        print("\033[2J\033[H")
        println("Step: ", step)
        plot_board(board)
        sleep(0.1)
        board = update_board(board)
        step += 1
    end
end

end # module game_of_life
