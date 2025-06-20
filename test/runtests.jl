using game_of_life
using Test

board::Matrix{Bool} = [
    1 0 1 0
    0 1 0 1
    0 1 0 0
    0 0 0 0
]

@testset "NeighborCounting" begin
    @test game_of_life.get_number_of_neighbors(CartesianIndex(1, 1), board) == 2
    @test game_of_life.get_number_of_neighbors(CartesianIndex(2, 2), board) == 3
    @test game_of_life.get_number_of_neighbors(CartesianIndex(1, 2), board) == 3
    @test game_of_life.get_number_of_neighbors(CartesianIndex(2, 1), board) == 4
end

@testset "CellUpdating" begin
    @test game_of_life.update_cell(CartesianIndex(1, 1), board) == 1
    @test game_of_life.update_cell(CartesianIndex(2, 2), board) == 1
    @test game_of_life.update_cell(CartesianIndex(1, 2), board) == 1
    @test game_of_life.update_cell(CartesianIndex(2, 1), board) == 0
    @test game_of_life.update_cell(CartesianIndex(4, 4), board) == 0
end
