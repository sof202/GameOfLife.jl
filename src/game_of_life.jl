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
    j, i = cell.I
    top = max(0, j - 1)
    bottom = min(j + 1, size(board)[2])
    left = max(0, i - 1)
    right = min(i + 1, size(board)[1])
    surrounding_cells = board[left:right, top:bottom]
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

end # module game_of_life
