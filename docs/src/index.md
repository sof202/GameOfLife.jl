# GameOfLife.jl 

Conway's game of life is a cellular automaton created by John Conway. It is 
a 2 dimensional cellular automaton with the following rules:

- Cells can be alive (1) or dead (0)
- At each time step, the following criteria depicts each cell's next state
    - If the cell was alive:
        - If the cell is surrounded by > 3 alive cells, it dies of
        overpopulation
        - If the cell is surrounded by < 2 alive cells, it dies of
        underpopulation
    - If the cell was dead and is surrounded by exactly 3 alive cells, it
    becomes alive by reproduction
    - Otherwise the cell remains in the same state


This project imports:

```@docs
GameOfLife
```

