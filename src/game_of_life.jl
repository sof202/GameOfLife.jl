module game_of_life

ALIVE = '#'
DEAD = '-'

function setup_board(width::Int, height::Int)
    board = rand((ALIVE, DEAD), (height, width))
    return board
end

function print_board(board::Matrix{Char})
    for row in 1:size(board)[1]
        for col in 1:size(board)[2]
            print(board[row, col])
        end
        print('\n')
    end
end

end # module game_of_life
