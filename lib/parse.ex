defmodule GenReport.Parser do
  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(fn line -> parse_line(line) end)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, &String.downcase(&1))
    |> List.update_at(1, &String.to_integer(&1))
    |> List.update_at(3, &String.to_integer(&1))
    |> List.update_at(4, &String.to_integer(&1))
  end
end
