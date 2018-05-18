defmodule Coordinate do
    def create(x, y) do
        {x,y}
    end

    def x(coord) do
        elem(coord, 0)
    end

    def y(coord) do
        elem(coord, 1)
    end

    def valid_box(box) do
        cood1 = Enum.at(box, 0 )
        cood2 = Enum.at(box, 1 )
        cood3 = Enum.at(box, 2 )
        cood4 = Enum.at(box, 3 )
        y(cood1) != y(cood3) && y(cood2) != y(cood4)
         && x(cood1) != x(cood3) && x(cood2) != x(cood4)
    end

    def create_box(coord1, coord2) do
        coord3 = create(x(coord1), y(coord2))
        coord4 = create(x(coord2), y(coord1))
        [coord1, coord3, coord2, coord4]
    end

    def dot(u, v) do
        x(u) * x(v) + y(u) * y(v)
    end

    def vector(coord1, coord2) do
        create((x(coord2) - x(coord1)),(y(coord2) - y(coord1)))
    end

    def point_in_boundingbox(p, box) do
        a_b = vector(Enum.at(box, 0 ), Enum.at(box, 1));
        a_m = vector(Enum.at(box, 0 ), p);
        b_c = vector(Enum.at(box, 1 ), Enum.at(box, 2));
        b_m = vector(Enum.at(box, 1 ), p);
        dotABAM = dot(a_b, a_m);
        dotABAB = dot(a_b, a_b);
        dotBCBM = dot(b_c, b_m);
        dotBCBC = dot(b_c, b_c);
        0 <= dotABAM && dotABAM <= dotABAB && 0 <= dotBCBM && dotBCBM <= dotBCBC
    end

end
