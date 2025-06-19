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

end # module game_of_life
