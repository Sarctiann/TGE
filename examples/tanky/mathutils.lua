local function createEmptyRectangle(m, n)
    local matrix = {}
    for i = 1, n do
        matrix[i] = {}
        for j = 1, m do
            if i == 1 or i == n or j == 1 or j == m then
                matrix[i][j] = 1
            else
                matrix[i][j] = 0
            end
        end
    end
    return matrix
end

return { createEmptyRectangle = createEmptyRectangle }
