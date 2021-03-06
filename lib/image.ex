defmodule Identicon.Image do
  @moduledoc """
    Stores data representation for an Identicon

  ## Example
      %Identicon.Image{
      hex: [82, 123, 213, 181, 214, 137, 226, 195, 42, 233, 116, 198, 34, 159, 247,
      133]
  }
  """
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end
