module game_of_life

using UnicodePlots

function clearScreen()
    print("\033[2J\033[H")
end

function setup_random_board(width::Int, height::Int)
    board = rand(Bool, (height, width))
    return board
end

function create_glider(width::Int, height::Int)
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

function get_number_of_neighbors(cell::CartesianIndex, board::Matrix{Bool})
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

function update_cell(cell::CartesianIndex, board::Matrix{Bool})
    surrounding_cells = get_number_of_neighbors(cell, board)
    if board[cell] == 1
        return surrounding_cells > 3 ? 0 :
               (surrounding_cells < 2 ? 0 : 1)
    end
    return surrounding_cells == 3 ? 1 : 0
end

function update_board!(new_board::Matrix{Bool}, board::Matrix{Bool})
    for cell in CartesianIndices(board)
        new_board[cell] = update_cell(cell, board)
    end
    return new_board
end

function plot_board(board)
    board_plot = UnicodePlots.heatmap(
        board,
        colorbar=false,
        labels=false,
        colormap=:inferno,
    )
    display(board_plot)
end

function play_game(board; max_steps=100)
    println("Game start")
    step = 0
    copy_board = similar(board)
    try
        while sum(board) != 0 && step < max_steps
            clearScreen()
            println("Step: ", step)
            plot_board(board)
            sleep(0.1)
            update_board!(copy_board, board)
            copy_board, board = board, copy_board
            step += 1
        end
    catch ex
        isa(ex, InterruptException)
    end
    clearScreen()
    println("Final iteration")
    plot_board(board)
end

end # module game_of_life
