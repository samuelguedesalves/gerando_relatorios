defmodule GenReport do
  alias GenReport.Parser

  def build(filename) do
    # filename = "gen_report.csv"

    Parser.parse_file(filename)
    |> Enum.reduce(build_report(), fn item, report -> sum_values(item, report) end)
  end

  def build(), do: {:error, "Insira o nome de um arquivo"}

  defp sum_values(item, report) do
    [name, hours, _day, month, year] = item

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    } = report

    all_hours = sum_all_hours(all_hours, name, hours)
    hours_per_month = sum_hours_per_month(hours_per_month, name, hours, month)
    hours_per_year = sum_hours_per_year(hours_per_year, name, hours, year)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp sum_all_hours(all_hours, name, hours) do
    find_all_hours = Map.get(all_hours, name)

    if find_all_hours != nil do
      Map.put(all_hours, name, find_all_hours + hours)
    else
      Map.put(all_hours, name, hours)
    end
  end

  defp sum_hours_per_month(hours_per_month, name, hours, month) do
    month_name = get_month_name(month)
    user_months = Map.get(hours_per_month, name)

    if user_months != nil do
      find_month = Map.get(user_months, month_name)

      if find_month != nil do
        updated_user = Map.put(user_months, month_name, find_month + hours)
        Map.put(hours_per_month, name, updated_user)
      else
        updated_user_months = Map.put(user_months, month_name, hours)
        Map.put(hours_per_month, name, updated_user_months)
      end
    else
      Map.put(hours_per_month, name, Map.put(%{}, month_name, hours))
    end
  end

  defp sum_hours_per_year(hours_per_year, name, hours, year) do
    user_years = Map.get(hours_per_year, name)

    if user_years != nil do
      find_year = Map.get(user_years, year)

      if find_year != nil do
        updated_years = Map.put(user_years, year, find_year + hours)
        Map.put(hours_per_year, name, updated_years)
      else
        updated_years = Map.put(user_years, year, hours)
        Map.put(hours_per_year, name, updated_years)
      end
    else
      Map.put(hours_per_year, name, Map.put(%{}, year, hours))
    end
  end

  defp get_month_name(month_number) do
    case month_number do
      1 -> "janeiro"
      2 -> "fevereiro"
      3 -> "março"
      4 -> "abril"
      5 -> "maio"
      6 -> "junho"
      7 -> "julho"
      8 -> "agosto"
      9 -> "setembro"
      10 -> "outubro"
      11 -> "novembro"
      12 -> "dezembro"
    end
  end

  defp build_report() do
    %{
      "all_hours" => %{},
      "hours_per_month" => %{},
      "hours_per_year" => %{}
    }
  end
end

# %{
#   all_hours: %{
#     danilo: 500
#   },
#   hours_per_month: %{
#     danilo: %{
#       janeiro: 40
#     },
#     rafael: %{
#       janeiro: 52
#     }
#   },
#   hours_per_year: %{
#     danilo: %{
#       "2016" => 276,
#       "2017" => 412
#     }
#   }
# }
