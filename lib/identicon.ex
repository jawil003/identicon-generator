defmodule Identicon do
  require Integer

  @doc """
    Creates an Identicon for a String Value

  ## Example
      iex> Identicon.main("john")
      %Identicon.Image{
      hex: [82, 123, 213, 181, 214, 137, 226, 195, 42, 233, 116, 198, 34, 159, 247,
      133]
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  defp save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  defp draw_image(%Identicon.Image{color: [r, g, b], pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color({r, g, b})

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  defp build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_value, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}
        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  defp filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    even_list =
      grid
      |> Enum.filter(fn {value, _index} = _x -> Integer.is_even(value) end)

    %Identicon.Image{image | grid: even_list}
  end

  defp mirror_row([first, second | _tail] = row) do
    row ++ [second, first]
  end

  defp build_grid(%{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  defp pick_color(%{hex: [red, green, blue | _tail]} = image) do
    %Identicon.Image{image | color: [red, green, blue]}
  end

  defp hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
