module game_of_life

ALIVE_CHAR = '#'
DEAD_CHAR = '-'

function setup_board(width::Int, height::Int)
    board = rand((0, 1), (height, width))
    return board
end

function print_board(board::Matrix{Int})
    character_board = map(
        x -> if x == 1
            ALIVE_CHAR
        else
            DEAD_CHAR
        end, board
    )
    for row in 1:size(board)[1]
        for col in 1:size(board)[2]
            print(character_board[row, col])
        end
        print('\n')
    end
end


function get_number_of_neighbors(cell::CartesianIndex, board::Matrix{Int})
    row, col = cell.I
    top = max(1, row - 1)
    bottom = min(row + 1, size(board)[1])
    left = max(1, col - 1)
    right = min(col + 1, size(board)[2])
    surrounding_cells = board[top:bottom, left:right]
    return sum(surrounding_cells)
end

function update_cell(cell::CartesianIndex, board::Matrix{Int})
    surrounding_cells = get_number_of_neighbors(cell, board)
    if board[cell] == 1
        surrounding_cells -= 1
        board[cell] = surrounding_cells > 3 ? 0 :
                      (surrounding_cells < 2 ? 0 : 1)
    else
        board[cell] = surrounding_cells == 3 ? 1 : 0
    end
end

function update_board(board::Matrix{Int})
    foreach(cell -> update_cell(cell, board), CartesianIndices(board))
end

end # module game_of_life
