defmodule Earmark.Parser.ListParser do
  alias Earmark.Block
  alias Earmark.Line
  alias Earmark.Options

  import Earmark.Helpers.StringHelpers, only: [behead: 2]

  @moduledoc false

  def parse_list_item([item = %Line.ListItem{bullet: bullet, content: content, lnb: lnb, type: type, list_indent: list_indent} | lines], options \\ %Options{}) do
    list_item = %Block.ListItem{bullet: bullet, lnb: lnb, type: type}
    _read_list_item(lines, [content], list_indent, options)
  end


  defp _read_list_item(lines, list_item, width, options)
  defp _read_list_item([], result, _width, options) do
    {Enum.reverse(result),  [], options}
  end
  defp _read_list_item([%Line.Ruler{}|_]=rest, result, _width, options) do
    {Enum.reverse(result),  rest, options}
  end
  defp _read_list_item([%{initial_indent: initial_indent}|_]=rest, result, width, options) when initial_indent < width do
    {Enum.reverse(result),  rest, options}
  end
  defp _read_list_item([item|rest], result, width, options) do
    _read_list_item(rest, [behead(item.line, width)|result], width, options)
  end

end
