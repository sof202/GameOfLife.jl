using GameOfLife
using Test

board::Matrix{Bool} = [
    1 0 1 0
    0 1 0 1
    0 1 0 0
    0 0 0 0
]

@testset "NeighborCounting" begin
    @test GameOfLife.get_number_of_neighbors(CartesianIndex(1, 1), board) == 2
    @test GameOfLife.get_number_of_neighbors(CartesianIndex(2, 2), board) == 3
    @test GameOfLife.get_number_of_neighbors(CartesianIndex(1, 2), board) == 3
    @test GameOfLife.get_number_of_neighbors(CartesianIndex(2, 1), board) == 4
end

@testset "CellUpdating" begin
    @test GameOfLife.update_cell(CartesianIndex(1, 1), board) == 1
    @test GameOfLife.update_cell(CartesianIndex(2, 2), board) == 1
    @test GameOfLife.update_cell(CartesianIndex(1, 2), board) == 1
    @test GameOfLife.update_cell(CartesianIndex(2, 1), board) == 0
    @test GameOfLife.update_cell(CartesianIndex(4, 4), board) == 0
end
